import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../utils/colors.dart';

class InterstitialAdLoadingDialogHandle {
  final BuildContext _context;
  final DateTime _shownAt;
  final Duration _minShowDuration;
  bool _closed = false;

  InterstitialAdLoadingDialogHandle._(
    this._context, {
    DateTime? shownAt,
    Duration minShowDuration = Duration.zero,
    bool isClosed = false,
  }) : _shownAt = shownAt ?? DateTime.now(),
       _minShowDuration = minShowDuration,
       _closed = isClosed;

  bool get isClosed => _closed;

  Future<void> waitForMinShowDuration() async {
    if (_closed) return;
    final elapsed = DateTime.now().difference(_shownAt);
    final remaining = _minShowDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
  }

  void close() {
    unawaited(_closeAfterMinDuration());
  }

  Future<void> _closeAfterMinDuration() async {
    if (_closed) return;
    _closed = true;

    await waitForMinShowDuration();
    final navigator = Navigator.of(_context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

Future<InterstitialAdLoadingDialogHandle> showInterstitialAdLoadingDialog(
  BuildContext context, {
  Duration minShowDuration = const Duration(seconds: 2),
  Duration safetyTimeout = const Duration(seconds: 4),
}) async {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Ensure the dialog closes even if ad callbacks never fire.
  final handleCompleter = Completer<InterstitialAdLoadingDialogHandle>();
  Timer? timer;
  timer = Timer(safetyTimeout, () {
    handleCompleter.future.then((h) => h.close());
  });

  if (kDebugMode) {
    debugPrint(
      '[InterstitialLoadingDialog] request show '
      'minShow=${minShowDuration.inMilliseconds}ms '
      'timeout=${safetyTimeout.inMilliseconds}ms',
    );
  }

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (dialogContext) {
      final shownAt = DateTime.now();
      final handle = InterstitialAdLoadingDialogHandle._(
        dialogContext,
        shownAt: shownAt,
        minShowDuration: minShowDuration,
      );
      if (!handleCompleter.isCompleted) {
        handleCompleter.complete(handle);
      }
      if (kDebugMode) {
        debugPrint(
          '[InterstitialLoadingDialog] shown at=${shownAt.toIso8601String()}',
        );
      }
      return AlertDialog(
        // Requested: use opposite theme colors for this dialog.
        // Dark theme -> light colors; light theme -> dark colors.
        backgroundColor: isDark
            ? AppColors.lightBackground
            : AppColors.darkBackground,
        title: Text(
          l10n.ad,
          style: TextStyle(
            fontFamily: 'Amaranth',
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.textWhite,
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
                  color: isDark ? AppColors.textGrey : AppColors.textGrey,
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
        shownAt: DateTime.now(),
        minShowDuration: Duration.zero,
        isClosed: true,
      );
      handleCompleter.complete(handle);
    }
  });

  return handleCompleter.future;
}
