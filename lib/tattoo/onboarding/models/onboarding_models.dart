// Models for onboarding flow
class ZodiacInfo {
  final String name;
  final String dateRange;
  final String description;
  final String assetPath;

  ZodiacInfo({
    required this.name,
    required this.dateRange,
    required this.description,
    required this.assetPath,
  });
}

class TattooStyleItem {
  final String label;
  final String assetPath;

  const TattooStyleItem({required this.label, required this.assetPath});
}
