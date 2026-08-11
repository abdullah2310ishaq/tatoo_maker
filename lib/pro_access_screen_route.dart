import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pro_access_screen.dart';
import 'pro_access_screen_free_trial.dart';
import 'services/remote_config_service.dart';

/// Routes to the free-trial or full paywall based on Remote Config
/// [RemoteConfigKeys.proFreeTrialScreen].
class ProAccessScreen extends StatelessWidget {
  final Widget nextScreen;
  final bool showInterstitialOnClose;
  final bool goToNextScreenOnClose;
  final bool forceTrialEnabled;
  final bool lockTrialToggle;
  final bool alwaysShowTrialToggle;

  const ProAccessScreen({
    super.key,
    required this.nextScreen,
    this.showInterstitialOnClose = false,
    this.goToNextScreenOnClose = false,
    this.forceTrialEnabled = false,
    this.lockTrialToggle = false,
    this.alwaysShowTrialToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final useFreeTrialScreen =
        context.watch<RemoteConfigService>().proFreeTrialScreen;

    if (useFreeTrialScreen) {
      return ProFreeTrialAccessScreen(
        nextScreen: nextScreen,
        showInterstitialOnClose: showInterstitialOnClose,
        goToNextScreenOnClose: goToNextScreenOnClose,
        forceTrialEnabled: forceTrialEnabled,
        lockTrialToggle: lockTrialToggle,
        alwaysShowTrialToggle: alwaysShowTrialToggle,
      );
    }

    return Pro3DayAccessScreen(
      nextScreen: nextScreen,
      showInterstitialOnClose: showInterstitialOnClose,
      goToNextScreenOnClose: goToNextScreenOnClose,
      forceTrialEnabled: forceTrialEnabled,
      lockTrialToggle: lockTrialToggle,
      alwaysShowTrialToggle: alwaysShowTrialToggle,
    );
  }
}
