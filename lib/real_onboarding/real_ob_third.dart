import 'package:flutter/material.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';

class RealOnboardingThirdScreen extends StatelessWidget {
  const RealOnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light theme only for onboarding
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- TOP FLORAL ASSET ---------- (light theme only)
                Image.asset(
                  'assets/splash/third_one_light.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 2),

                // ---------- TITLE ----------
                Text(
                  AppLocalizations.of(context)!.tattooMaker,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Amaranth',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                // ---------- KEYBOARD ASSET ---------- (light theme only)
                Image.asset(
                  'assets/splash/third_two_light.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 28),

                // ---------- FEATURE TITLE ----------
                Text(
                  AppLocalizations.of(context)!.flowerCreation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amaranth',
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // ---------- DESCRIPTION ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    AppLocalizations.of(context)!.flowerCreationDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.4,
                      fontFamily: 'Amaranth',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
