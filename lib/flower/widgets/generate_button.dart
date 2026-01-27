import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../flower_loading_screen.dart';

/// Generate button widget
class GenerateButton extends StatelessWidget {
  final String name;

  const GenerateButton({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to loading screen which will generate and show result
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FlowerLoadingScreen(name: name),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA6541D), // Burnt orange
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: Text(
            l10n.homeGenerate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Amaranth',
            ),
          ),
        ),
      ),
    );
  }
}
