import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<List<DateTime?>?> showCommonDateRangeDialog({
  required BuildContext context,
  DateTime? startDate,
  DateTime? endDate,
  Function(List<DateTime?>)? onDateChanged,
}) async {
  final baseTextStyle = TextStyle(
    fontSize: 14.sp,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.displayMedium?.color,
  );

  print('date ====== $startDate , $endDate');

  final results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),

      controlsTextStyle: baseTextStyle,
      dayTextStyle: baseTextStyle,
      selectedDayTextStyle: baseTextStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      weekdayLabelTextStyle: baseTextStyle.copyWith(
        fontWeight: FontWeight.w500,
      ),
      monthTextStyle: baseTextStyle,
      yearTextStyle: baseTextStyle,
      okButtonTextStyle: baseTextStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      cancelButtonTextStyle: baseTextStyle.copyWith(
        color: Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w600,
      ),
      nextMonthIcon: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.secondary,
        size: 15,
      ),
      lastMonthIcon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).colorScheme.secondary,
        size: 15,
      ),
    ),
    dialogSize: Size(325.w, 400.h),
    borderRadius: BorderRadius.circular(12.r),
    value: [startDate, endDate],
  );

  if (results != null && results.isNotEmpty) {
    // ✅ Clean up empty/null selections
    final filtered = results.where((d) => d != null).toList();

    // ✅ Only call callback if there’s at least one valid date
    if (filtered.isNotEmpty) {
      onDateChanged?.call(filtered);
      return filtered;
    }
  }

  return null;
}
