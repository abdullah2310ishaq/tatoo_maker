import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../utils/colors.dart';

class InterstitialAdLoadingDialogHandle {
  final BuildContext _context;
  bool _closed = false;

  InterstitialAdLoadingDialogHandle._(this._context, {bool isClosed = false})
      : _closed = isClosed;

  bool get isClosed => _closed;

  void close() {
    if (_closed) return;
    _closed = true;
    final navigator = Navigator.of(_context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

Future<InterstitialAdLoadingDialogHandle> showInterstitialAdLoadingDialog(
  BuildContext context, {
  Duration safetyTimeout = const Duration(seconds: 2),
}) async {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Ensure the dialog closes even if ad callbacks never fire.
  final handleCompleter = Completer<InterstitialAdLoadingDialogHandle>();
  Timer? timer;
  timer = Timer(safetyTimeout, () {
    handleCompleter.future.then((h) => h.close());
  });

  // Don't await: we want to keep executing the interstitial load flow.
  // ignore: unawaited_futures
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (dialogContext) {
      final handle = InterstitialAdLoadingDialogHandle._(dialogContext);
      if (!handleCompleter.isCompleted) {
        handleCompleter.complete(handle);
      }
      return AlertDialog(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        title: Text(
          l10n.ad,
          style: TextStyle(
            fontFamily: 'Amaranth',
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ),
        content: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Ad is loading...',
                style: TextStyle(
                  fontFamily: 'Amaranth',
                  color: isDark
                      ? AppColors.textGrey
                      : AppColors.textGrey.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    timer?.cancel();
    timer = null;

    if (!handleCompleter.isCompleted) {
      // Dialog never built; return a no-op closed handle.
      final handle = InterstitialAdLoadingDialogHandle._(
        context,
        isClosed: true,
      );
      handleCompleter.complete(handle);
    }
  });

  return handleCompleter.future;
}

