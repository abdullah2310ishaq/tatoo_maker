import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

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
  String _getFormattedDate() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
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
        const SizedBox(height: 40),
        // Question and date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's your birthday?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _getFormattedDate(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Date picker
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _buildDatePicker(isDark),
          ),
        ),
        const Spacer(),
        // Next button
        OnboardingNextButton(
          enabled: true, // Always enabled for birthday
          isLastStep: false,
          onPressed: widget.onNext,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDatePicker(bool isDark) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = List.generate(31, (i) => i + 1);
    final currentYear = DateTime.now().year;
    final years = List.generate(100, (i) => currentYear - 18 - i);

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPickerColumn(
                items: months,
                selectedIndex: widget.selectedMonth,
                onChanged: widget.onMonthChanged,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPickerColumn(
                items: days.map((d) => d.toString()).toList(),
                selectedIndex: widget.selectedDay - 1,
                onChanged: (index) => widget.onDayChanged(index + 1),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPickerColumn(
                items: years.map((y) => y.toString()).toList(),
                selectedIndex: years.contains(widget.selectedYear)
                    ? years.indexOf(widget.selectedYear)
                    : 0,
                onChanged: widget.onYearChanged,
                isDark: isDark,
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFE8B3A),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: ListWheelScrollView.useDelegate(
          controller: FixedExtentScrollController(initialItem: selectedIndex),
          itemExtent: 50,
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
                    fontSize: isSelected ? 20 : 16,
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
