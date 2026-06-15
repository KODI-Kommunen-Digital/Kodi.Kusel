import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_provider.dart';

import '../../navigation/navigation.dart';
import '../../screens/fliter_screen/filter_screen_controller.dart';
import '../text_styles.dart';

class DatePickerWidget extends ConsumerStatefulWidget {
  const DatePickerWidget({super.key});

  @override
  ConsumerState<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends ConsumerState<DatePickerWidget> {
  final datePickerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(datePickerProvider);
    final stateNotifier = ref.read(datePickerProvider.notifier);
    final dateFormat = DateFormat('yyyy-MM-dd');
    DateTime? startDate = state.startDate;
    DateTime? endDate = state.endDate;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20.r)),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 250.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Form(
          key: datePickerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBoldPoppins(
                  text: AppLocalizations.of(context).define_period,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).from,
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              5.verticalSpace,
              _buildDateSelectorButton(
                onDatePick: () async {
                  // final DateTime? date = await showDatePicker(
                  //   context: context,
                  //   initialDate: selectedDate ?? DateTime.now(),
                  //   firstDate: DateTime(1900),
                  //   lastDate: DateTime(2100),
                  // );
                  stateNotifier.pickDate(context, true);
                },
                isStartDate: true,
                displayText: (startDate != null)
                    ? dateFormat.format(startDate)
                    : AppLocalizations.of(context).select_start_date,
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).to,
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              5.verticalSpace,
              _buildDateSelectorButton(
                onDatePick: () async {
                  // DateTime? selectedDate = endDate;
                  // final DateTime? date = await showDatePicker(
                  //   context: context,
                  //   initialDate: selectedDate ?? DateTime.now(),
                  //   firstDate: startDate ?? DateTime(1900),
                  //   lastDate: DateTime(2100),
                  // );
                  stateNotifier.pickDate(context, false);
                },
                isStartDate: false,
                displayText: (endDate != null)
                    ? dateFormat.format(endDate)
                    : AppLocalizations.of(context).select_end_date,
              ),
              5.verticalSpace,
              Visibility(
                  visible:
                      ((state.startDate == null || state.endDate == null) &&
                          state.error),
                  child: textRegularPoppins(
                      text: AppLocalizations.of(context)
                          .please_select_start_and_end_date,
                      color: Theme.of(context).colorScheme.error)),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      stateNotifier.resetDates();
                      ref
                          .read(navigationProvider)
                          .removeTopPage(context: context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              width: 1.h.w,
                              color: Theme.of(context).primaryColor)),
                      child: textRegularPoppins(
                          text: AppLocalizations.of(context).cancel,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ),
                  _filterButton(
                      text: AppLocalizations.of(context).apply,
                      isEnabled: true,
                      context: context,
                      enableLeadingIcon: true,
                      onTap: () {
                        if (state.startDate == null || state.endDate == null) {
                          ref.read(datePickerProvider.notifier).onValidation();
                        } else {
                          ref
                              .read(filterScreenProvider.notifier)
                              .setDateInterval(
                                  type: IntervalType.definePeriod,
                                  callBack: () {},
                                  startDate: startDate,
                                  endDate: endDate);
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectorButton({
    required Function() onDatePick,
    required bool isStartDate,
    required String displayText,
  }) {
    return GestureDetector(
      onTap: () async {
        onDatePick();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: textRegularPoppins(
            text: displayText,
            textAlign: TextAlign.start,
            color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _filterButton(
      {required String text,
      required bool isEnabled,
      required bool enableLeadingIcon,
      required BuildContext context,
      required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: isEnabled
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        child: Row(
          children: [
            (enableLeadingIcon && isEnabled)
                ? Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  )
                : Container(),
            textRegularPoppins(
                text: text,
                color: isEnabled
                    ? Theme.of(context).textTheme.labelSmall?.color
                    : Theme.of(context).textTheme.bodyMedium?.color),
            5.horizontalSpace,
            (!enableLeadingIcon && isEnabled)
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
