import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/usage_limit_provider.dart';
import '../../utils/colors.dart';
import '../../home_shell.dart';
import '../flower_loading_screen.dart';
import '../../pro_access_screen.dart';

/// Generate button widget. Disabled when [enabled] is false (e.g. empty name).
class GenerateButton extends StatelessWidget {
  final String name;
  final bool enabled;

  const GenerateButton({super.key, required this.name, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: enabled && name.isNotEmpty
              ? () async {
                  final usageLimitProvider = context.read<UsageLimitProvider>();
                  final canStartGeneration = await usageLimitProvider
                      .canStartGeneration();
                  if (!context.mounted) return;

                  if (!canStartGeneration) {
                    // Usage limit exceeded: show in-app paywall (no dummy screen).
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProAccessScreen(
                          showInterstitialOnClose: true,
                          goToNextScreenOnClose: true,
                          nextScreen: HomeShell(),
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FlowerLoadingScreen(name: name),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled
                ? const Color(0xFFA6541D) // Burnt orange
                : AppColors.textGrey.withValues(alpha: 0.4),
            disabledBackgroundColor: AppColors.textGrey.withValues(alpha: 0.4),
            foregroundColor: AppColors.textWhite,
            disabledForegroundColor: AppColors.textGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: enabled ? 4 : 0,
          ),
          child: Text(
            l10n.homeGenerate,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Amaranth',
            ),
          ),
        ),
      ),
    );
  }
}
