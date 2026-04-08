import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/tattoo_birthday_ads.dart';

class StepBirthdayPage extends StatefulWidget {
  final int selectedMonth;
  final int selectedDay;
  final int selectedYear;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepBirthdayPage({
    super.key,
    required this.selectedMonth,
    required this.selectedDay,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onDayChanged,
    required this.onYearChanged,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepBirthdayPage> createState() => _StepBirthdayPageState();
}

class _StepBirthdayPageState extends State<StepBirthdayPage> {
  bool _isDateValid() {
    final now = DateTime.now();
    try {
      final selectedDate = DateTime(
        widget.selectedYear,
        widget.selectedMonth + 1, // Month is 0-indexed in widget
        widget.selectedDay,
      );
      // Date is valid if it's not in the future
      return !selectedDate.isAfter(now);
    } catch (e) {
      // Invalid date (e.g., Feb 30)
      return false;
    }
  }

  String _getFormattedDate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    return '${months[widget.selectedMonth]} ${widget.selectedDay} ${widget.selectedYear}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingHeader(currentStep: 2, onBack: widget.onBack),
        const TattooBirthdayBannerAd(),
        SizedBox(height: 40.h),
        // Question and date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.stepBirthdayWhatsYourBirthday,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              _getFormattedDate(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        // Date picker
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: _buildDatePicker(isDark),
          ),
        ),
        const Spacer(),
        TattooBirthdayNativeAd(isDark: isDark),
        // Next button
        OnboardingNextButton(
          enabled: _isDateValid(), // Disabled if date is in future or invalid
          isLastStep: false,
          onPressed: widget.onNext,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildDatePicker(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    final days = List.generate(31, (i) => i + 1);
    final currentYear = DateTime.now().year;
    // Generate years from current year down to 100 years ago
    final years = List.generate(100, (i) => currentYear - i);

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPickerColumn(
                items: months,
                selectedIndex: widget.selectedMonth,
                onChanged: (index) {
                  widget.onMonthChanged(index);
                  setState(() {}); // Rebuild to update button state
                },
                isDark: isDark,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildPickerColumn(
                items: days.map((d) => d.toString()).toList(),
                selectedIndex: widget.selectedDay - 1,
                onChanged: (index) {
                  widget.onDayChanged(index + 1);
                  setState(() {}); // Rebuild to update button state
                },
                isDark: isDark,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildPickerColumn(
                items: years.map((y) => y.toString()).toList(),
                selectedIndex: years.contains(widget.selectedYear)
                    ? years.indexOf(widget.selectedYear)
                    : 0,
                onChanged: (index) {
                  widget.onYearChanged(years[index]);
                  setState(() {}); // Rebuild to update button state
                },
                isDark: isDark,
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFE8B3A),
                    width: 1.5.w,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerColumn({
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
    required bool isDark,
  }) {
    return SizedBox(
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h),
        child: ListWheelScrollView.useDelegate(
          controller: FixedExtentScrollController(initialItem: selectedIndex),
          itemExtent: 50.h,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: onChanged,
          perspective: 0.003,
          diameterRatio: 1.5,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              if (index < 0 || index >= items.length) return null;
              final isSelected = index == selectedIndex;
              return Center(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: isSelected ? 20.sp : 16.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? (isDark ? AppColors.textWhite : AppColors.textPrimary)
                        : (isDark
                              ? AppColors.textGrey.withOpacity(0.4)
                              : AppColors.textGrey.withOpacity(0.4)),
                  ),
                ),
              );
            },
            childCount: items.length,
          ),
        ),
      ),
    );
  }
}
