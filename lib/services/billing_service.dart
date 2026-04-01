import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Store product IDs.
/// - tatooweekly: includes 3-day free trial, then recurring billing by store config.
/// - lifetime: one-time non-consumable purchase.
const String kProTrial3DaysProductId = 'tatooweekly';
const String kProLifetimeProductId = 'lifetime';

enum BillingPlan { freeTrial, lifetime }

enum BillingPurchaseStatus { pending, purchased, canceled, error }

class BillingPurchaseEvent {
  final BillingPurchaseStatus status;
  final String productId;

  const BillingPurchaseEvent({required this.status, required this.productId});
}

class BillingService {
  static const Set<String> _productIds = <String>{
    kProTrial3DaysProductId,
    kProLifetimeProductId,
  };

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final StreamController<BillingPurchaseEvent> _purchaseEventsController =
      StreamController<BillingPurchaseEvent>.broadcast();

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  bool _isStoreAvailable = false;
  bool _isInitialized = false;
  Map<String, ProductDetails> _productsById = const {};

  Stream<BillingPurchaseEvent> get purchaseEvents =>
      _purchaseEventsController.stream;

  bool get isStoreAvailable => _isStoreAvailable;

  bool get hasProducts =>
      _productsById.containsKey(kProTrial3DaysProductId) ||
      _productsById.containsKey(kProLifetimeProductId);

  void _log(String message) {
    debugPrint('[BillingService] $message');
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    _log('Initialize requested.');
    _log('Configured product IDs: $_productIds');

    try {
      _isStoreAvailable = await _inAppPurchase.isAvailable();
      _log('Store available: $_isStoreAvailable');
    } catch (error, stackTrace) {
      _isStoreAvailable = false;
      _log('Store connection failed during isAvailable: $error');
      _log('Store connection stack trace: $stackTrace');
    }

    if (!_isStoreAvailable) {
      _log('Store not available. Billing setup will stay in fallback mode.');
      return;
    }

    try {
      _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _purchaseSubscription?.cancel(),
        onError: (Object error, StackTrace stackTrace) {
          _log('Purchase stream error: $error');
          _log('Purchase stream stack trace: $stackTrace');
        },
      );

      _log('Querying product details from store...');
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(_productIds);
      _log('Store products returned: ${response.productDetails.length}');
      _log('Store products not found: ${response.notFoundIDs}');
      if (response.error != null) {
        _log(
          'Store query error: code=${response.error!.code}, message=${response.error!.message}',
        );
      }
      _productsById = <String, ProductDetails>{
        for (final ProductDetails product in response.productDetails)
          product.id: product,
      };

      for (final ProductDetails product in response.productDetails) {
        _log(
          'Product loaded => id=${product.id}, title=${product.title}, price=${product.price}, currency=${product.currencyCode}, rawPrice=${product.rawPrice}',
        );
      }
    } catch (error, stackTrace) {
      _log('Billing setup failed after store availability check: $error');
      _log('Billing setup stack trace: $stackTrace');
      _isStoreAvailable = false;
      _productsById = const {};
      await _purchaseSubscription?.cancel();
      _purchaseSubscription = null;
      return;
    }
  }

  ProductDetails? productForPlan(BillingPlan plan) {
    return _productsById[_toProductId(plan)];
  }

  Future<bool> purchasePlan(BillingPlan plan) async {
    final ProductDetails? productDetails = productForPlan(plan);
    if (productDetails == null) {
      _log('Purchase start failed: product not found for plan=$plan');
      return false;
    }
    _log(
      'Starting purchase for plan=$plan, productId=${productDetails.id}, price=${productDetails.price}',
    );

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    try {
      return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (error, stackTrace) {
      _log('Purchase launch threw exception: $error');
      _log('Purchase launch stack trace: $stackTrace');
      return false;
    }
  }

  String _toProductId(BillingPlan plan) {
    switch (plan) {
      case BillingPlan.freeTrial:
        return kProTrial3DaysProductId;
      case BillingPlan.lifetime:
        return kProLifetimeProductId;
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    _log('Purchase updates received: ${purchaseDetailsList.length}');
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      final String productId = purchaseDetails.productID;
      _log(
        'Purchase update => productId=$productId, status=${purchaseDetails.status}, pendingComplete=${purchaseDetails.pendingCompletePurchase}, error=${purchaseDetails.error}',
      );

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _purchaseEventsController.add(
            BillingPurchaseEvent(
              status: BillingPurchaseStatus.pending,
              productId: productId,
            ),
          );
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _purchaseEventsController.add(
            BillingPurchaseEvent(
              status: BillingPurchaseStatus.purchased,
              productId: productId,
            ),
          );
          break;
        case PurchaseStatus.canceled:
          _purchaseEventsController.add(
            BillingPurchaseEvent(
              status: BillingPurchaseStatus.canceled,
              productId: productId,
            ),
          );
          break;
        case PurchaseStatus.error:
          _purchaseEventsController.add(
            BillingPurchaseEvent(
              status: BillingPurchaseStatus.error,
              productId: productId,
            ),
          );
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _log('Completing purchase for productId=$productId');
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> dispose() async {
    _log('Disposing billing service.');
    await _purchaseSubscription?.cancel();
    await _purchaseEventsController.close();
  }
}
