import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

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
  String? _trialPaidPriceFallback;

  Stream<BillingPurchaseEvent> get purchaseEvents =>
      _purchaseEventsController.stream;

  bool get isStoreAvailable => _isStoreAvailable;

  bool get hasProducts =>
      _productsById.containsKey(kProTrial3DaysProductId) ||
      _productsById.containsKey(kProLifetimeProductId);

  bool get isInitialized => _isInitialized;

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

      // Some Play Billing configurations return multiple ProductDetails for the
      // same subscription productId (trial offer vs paid offer). Keep the paid
      // price around for UI display on the "Free trial" card.
      _trialPaidPriceFallback = null;
      final paidVariants =
          response.productDetails
              .where((p) => p.id == kProTrial3DaysProductId && p.rawPrice > 0)
              .toList()
            ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      if (paidVariants.isNotEmpty) {
        _trialPaidPriceFallback = paidVariants.first.price.trim().isEmpty
            ? null
            : paidVariants.first.price.trim();
      }

      _productsById = _buildProductsById(response.productDetails);

      final countsById = <String, int>{};
      for (final product in response.productDetails) {
        countsById[product.id] = (countsById[product.id] ?? 0) + 1;
      }

      // Log the resolved product per ID (what the app will actually use),
      // then separately note if Play returned multiple variants for that ID.
      for (final entry in _productsById.entries) {
        final product = entry.value;
        final variants = countsById[product.id] ?? 1;
        _log(
          'Product resolved => id=${product.id}, variants=$variants, title=${product.title}, price=${product.price}, currency=${product.currencyCode}, rawPrice=${product.rawPrice}',
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


  String? displayPriceForPlan(BillingPlan plan) {
    final details = productForPlan(plan);
    if (details == null) return null;

    final direct = details.price.trim();
    if (direct.isNotEmpty && direct != '0' && direct.toLowerCase() != 'free') {
      return direct;
    }

    if (defaultTargetPlatform != TargetPlatform.android) {
      return direct.isEmpty ? null : direct;
    }

    if (details is! GooglePlayProductDetails) {
      return direct.isEmpty ? null : direct;
    }

    final subscriptionIndex = details.subscriptionIndex;
    final offers = details.productDetails.subscriptionOfferDetails;
    if (subscriptionIndex == null || offers == null) return null;
    if (subscriptionIndex >= offers.length) return null;

    final offer = offers[subscriptionIndex];
    final paidPhase = offer.pricingPhases.firstWhere(
      (p) => p.priceAmountMicros > 0,
      orElse: () => offer.pricingPhases.isNotEmpty
          ? offer.pricingPhases.last
          : offer.pricingPhases.first,
    );

    final formatted = paidPhase.formattedPrice;
    if (formatted.isNotEmpty) {
      return formatted;
    }

    if (plan == BillingPlan.freeTrial &&
        _trialPaidPriceFallback != null &&
        _trialPaidPriceFallback!.isNotEmpty) {
      return _trialPaidPriceFallback;
    }

    // Fallback: use ProductDetails fields when formatted phase price missing.
    final fallback = details.price.trim();
    return fallback.isEmpty ? null : fallback;
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

    final PurchaseParam purchaseParam = _buildPurchaseParam(
      plan: plan,
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

  Future<void> restorePurchases() async {
    if (!_isInitialized) {
      await initialize();
    }
    if (!_isStoreAvailable) return;

    try {
      _log('Restoring purchases...');
      await _inAppPurchase.restorePurchases();
    } catch (error, stackTrace) {
      _log('Restore purchases failed: $error');
      _log('Restore purchases stack trace: $stackTrace');
    }
  }

  Map<String, ProductDetails> _buildProductsById(
    List<ProductDetails> products,
  ) {
    final resolved = <String, ProductDetails>{};

    for (final product in products) {
      final existing = resolved[product.id];
      if (existing == null) {
        resolved[product.id] = product;
        continue;
      }

      // Android subscriptions can return multiple ProductDetails entries for the
      // same productId (different base plans / offers). For the weekly trial,
      // prefer the offer that actually contains a free phase.
      if (product.id == kProTrial3DaysProductId &&
          defaultTargetPlatform == TargetPlatform.android) {
        resolved[product.id] = _preferTrialOffer(existing, product);
        continue;
      }

      // Keep the first by default.
      resolved[product.id] = existing;
    }

    return resolved;
  }

  ProductDetails _preferTrialOffer(ProductDetails a, ProductDetails b) {
    final aHasTrial = _hasAndroidFreeTrialPhase(a);
    final bHasTrial = _hasAndroidFreeTrialPhase(b);

    if (aHasTrial && !bHasTrial) return a;
    if (!aHasTrial && bHasTrial) return b;

    // If both (or neither) have a trial phase, prefer the one with the lower
    // first paid price (rawPrice is the first pricing phase's rawPrice).
    return b.rawPrice < a.rawPrice ? b : a;
  }

  bool _hasAndroidFreeTrialPhase(ProductDetails details) {
    if (details is! GooglePlayProductDetails) return false;
    final subscriptionIndex = details.subscriptionIndex;
    if (subscriptionIndex == null) return false;

    final offers = details.productDetails.subscriptionOfferDetails;
    if (offers == null || subscriptionIndex >= offers.length) return false;

    final offer = offers[subscriptionIndex];
    return offer.pricingPhases.any((p) => p.priceAmountMicros == 0);
  }

  PurchaseParam _buildPurchaseParam({
    required BillingPlan plan,
    required ProductDetails productDetails,
  }) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return PurchaseParam(productDetails: productDetails);
    }

    // Lifetime is a one-time product; do not pass offerToken.
    if (plan != BillingPlan.freeTrial) {
      return PurchaseParam(productDetails: productDetails);
    }

    if (productDetails is! GooglePlayProductDetails) {
      return PurchaseParam(productDetails: productDetails);
    }

    final offerToken = productDetails.offerToken;
    if (offerToken == null || offerToken.isEmpty) {
      _log(
        'No subscription offer token found for productId=${productDetails.id}. Proceeding without offer token.',
      );
      return PurchaseParam(productDetails: productDetails);
    }

    return GooglePlayPurchaseParam(
      productDetails: productDetails,
      offerToken: offerToken,
    );
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

      final isManagedProduct = _productIds.contains(productId);
      if (!isManagedProduct) {
        // Some devices/flows can deliver a canceled/error update with an empty
        // productId. Still emit an event so UI can stop showing progress.
        if (productId.isEmpty &&
            (purchaseDetails.status == PurchaseStatus.canceled ||
                purchaseDetails.status == PurchaseStatus.error)) {
          _purchaseEventsController.add(
            BillingPurchaseEvent(
              status: purchaseDetails.status == PurchaseStatus.canceled
                  ? BillingPurchaseStatus.canceled
                  : BillingPurchaseStatus.error,
              productId: productId,
            ),
          );
        } else {
          _log('Ignoring purchase update for unmanaged productId=$productId');
        }
        continue;
      }

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
          if (purchaseDetails.pendingCompletePurchase) {
            try {
              _log('Completing purchase for productId=$productId');
              await _inAppPurchase.completePurchase(purchaseDetails);
            } catch (error, stackTrace) {
              _log('Complete purchase failed for productId=$productId: $error');
              _log('Complete purchase stack trace: $stackTrace');
              _purchaseEventsController.add(
                BillingPurchaseEvent(
                  status: BillingPurchaseStatus.error,
                  productId: productId,
                ),
              );
              break;
            }
          }

          if (!_isPurchaseVerificationDataValid(purchaseDetails)) {
            _log(
              'Purchase verification data missing. productId=$productId, status=${purchaseDetails.status}',
            );
            _purchaseEventsController.add(
              BillingPurchaseEvent(
                status: BillingPurchaseStatus.error,
                productId: productId,
              ),
            );
            break;
          }
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
    }
  }

  bool _isPurchaseVerificationDataValid(PurchaseDetails purchaseDetails) {
    final data = purchaseDetails.verificationData.serverVerificationData;
    return data.isNotEmpty;
  }

  Future<void> dispose() async {
    _log('Disposing billing service.');
    await _purchaseSubscription?.cancel();
    await _purchaseEventsController.close();
  }
}
