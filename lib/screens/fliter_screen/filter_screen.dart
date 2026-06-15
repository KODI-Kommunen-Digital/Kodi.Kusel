import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as nav;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';
import '../../common_widgets/custom_dropdown.dart';
import '../../common_widgets/custom_toggle_button.dart';
import '../../common_widgets/date_picker/date_picker_widget.dart';
import '../all_event/all_event_screen_controller.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(filterScreenProvider.notifier).fetchCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: _buildFilterScreenUi(context)),
    );
  }

  Widget _buildFilterScreenUi(BuildContext context) {
    final localization = AppLocalizations.of(context);

    Map<IntervalType, String> timeIntervalMap = {
      IntervalType.today: localization.today,
      IntervalType.weekend: localization.weekend,
      IntervalType.next7Days: localization.next_7_days,
      IntervalType.next30Days: localization.next_30_days,
      IntervalType.definePeriod: localization.define_period,
    };

    List<String> groupTypeList = [
      localization.alone,
      localization.as_a_couple,
      localization.with_children,
      localization.groups,
      localization.seniors,
      localization.people_with_disabilities
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textRegularPoppins(
                    text: AppLocalizations.of(context).settings,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                GestureDetector(
                  onTap: () {
                    final state = ref.read(filterScreenProvider);
                    ref.read(filterScreenProvider.notifier).onReset();
                    ref.read(allEventScreenProvider.notifier).onResetFilter();
                    ref.read(allEventScreenProvider.notifier).applyFilter(
                        startAfterDate: state.startAfterDate,
                        endBeforeDate: state.endBeforeDate,
                        cityId: state.cityId,
                        filterCount: ref
                            .read(filterScreenProvider.notifier)
                            .appliedFilterCount());
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor)),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context).reset,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                )
              ],
            ),
            16.verticalSpace,
            _buildDropdownSection(timeIntervalMap, groupTypeList),
            13.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: textRegularPoppins(
                  text: AppLocalizations.of(context).perimeter,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            8.verticalSpace,
            _buildSlider(context, ref.watch(filterScreenProvider).sliderValue),
            15.verticalSpace,
            _buildSortBySection(),
            12.verticalSpace,
            _buildOptionsToggle(
                ref.watch(filterScreenProvider).toggleFiltersMap),
            Padding(
              padding: EdgeInsets.all(15.h.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(navigationProvider)
                          .removeTopPage(context: context);
                    },
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context).cancel,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  _filterButton(
                      text: AppLocalizations.of(context).apply,
                      isEnabled: true,
                      context: context,
                      enableLeadingIcon: true,
                      onTap: () {
                        final state = ref.read(filterScreenProvider);
                        ref.read(allEventScreenProvider.notifier).applyFilter(
                            startAfterDate: state.startAfterDate,
                            endBeforeDate: state.endBeforeDate,
                            cityId: state.cityId,
                            filterCount: ref
                                .read(filterScreenProvider.notifier)
                                .appliedFilterCount());
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildDropdownSection(
      Map<IntervalType, String> timeIntervalMap, List<String> groupTypeList) {
    final state = ref.watch(filterScreenProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, AppLocalizations.of(context).period),
        CustomDropdown(
          hintText:
              "${AppLocalizations.of(context).select} ${AppLocalizations.of(context).period}",
          items: timeIntervalMap.values.toList(),
          selectedItem: state.periodValue ?? '',
          onSelected: (String? newValue) {
            ref.read(filterScreenProvider.notifier).onDropdownItemSelected(
                newValue ?? '', DropdownType.period, timeIntervalMap, () {
              showDialog(
                context: context,
                builder: (context) => customAlertDialog(),
              );
            });
          },
        ),
        Visibility(
            visible: (state.currentIntervalType == IntervalType.definePeriod) &&
                (state.startAfterDate != null && state.endBeforeDate != null),
            child: Column(
              children: [
                10.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: textRegularPoppins(
                          fontSize: 10,
                          text: AppLocalizations.of(context).from,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                ),
                5.verticalSpace,
                _buildDateSelectorButton(
                  onDatePick: () {},
                  isStartDate: true,
                  displayText: state.startAfterDate ?? '',
                ),
                10.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: textRegularPoppins(
                          fontSize: 10,
                          text: AppLocalizations.of(context).to,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                ),
                5.verticalSpace,
                _buildDateSelectorButton(
                  onDatePick: () {},
                  isStartDate: false,
                  displayText: state.endBeforeDate ?? '',
                ),
              ],
            )),
        15.verticalSpace,
        _buildLabel(context, AppLocalizations.of(context).target_group),
        CustomDropdown(
          hintText: "Select ${AppLocalizations.of(context).target_group}",
          items: groupTypeList,
          selectedItem: ref.watch(filterScreenProvider).targetGroupValue ?? '',
          onSelected: (String? newValue) {
            ref.read(filterScreenProvider.notifier).onDropdownItemSelected(
                newValue ?? '', DropdownType.targetGroup, null, () {});
          },
        ),
        10.verticalSpace,
        _buildLabel(context, AppLocalizations.of(context).ort),
        CustomDropdown(
          hintText: "Select ${AppLocalizations.of(context).ort}",
          selectedItem: ref.watch(filterScreenProvider).ortItemValue ?? '',
          items: ref.read(filterScreenProvider).cityListItems,
          onSelected: (String? newValue) {
            ref.read(filterScreenProvider.notifier).onDropdownItemSelected(
                newValue ?? '', DropdownType.ort, null, () {});
          },
        ),
      ],
    );
  }

  Widget customAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: DatePickerWidget(),
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
          color: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBoldPoppins(
            text: AppLocalizations.of(context).sort_by,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color),
        12.verticalSpace,
        Row(
          children: [
            _filterButton(
                text: AppLocalizations.of(context).actuality,
                isEnabled: ref.watch(filterScreenProvider).isActualityEnabled,
                context: context,
                enableLeadingIcon: false,
                onTap: () {
                  ref
                      .read(filterScreenProvider.notifier)
                      .onSortByButtonTap("Actuality");
                }),
            15.horizontalSpace,
            _filterButton(
                text: AppLocalizations.of(context).distance,
                isEnabled: ref.watch(filterScreenProvider).isDistanceEnabled,
                context: context,
                enableLeadingIcon: false,
                onTap: () {
                  ref
                      .read(filterScreenProvider.notifier)
                      .onSortByButtonTap("Distance");
                })
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, double sliderValue) {
    return Row(
      children: [
        Flexible(
          flex: 10,
          child: Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: sliderValue.round().toString(),
            onChanged: (double value) {
              ref.read(filterScreenProvider.notifier).updateSlider(value);
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: textRegularPoppins(
                text: "${sliderValue.round().toString()} km",
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        )
      ],
    );
  }

  Widget _buildOptionsToggle(Map<String, bool> toggleFilterMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBoldPoppins(
            text: AppLocalizations.of(context).options,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            boxShadow: [],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: toggleFilterMap.entries.map((entry) {
                return _toggleWidget(
                    context: context,
                    text: entry.key,
                    isToggled: entry.value,
                    onValueChange: (value, type) {
                      ref
                          .read(filterScreenProvider.notifier)
                          .onToggleUpdate(value, entry.key);
                    });
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _toggleWidget(
      {required BuildContext context,
      required String text,
      required bool isToggled,
      required Function(bool value, String type) onValueChange}) {
    final localization = AppLocalizations.of(context);
    Map<String, String> toggleTextLocalizationMap = {
      'Dogs allowed': localization.dogs_allow,
      'Accessible': localization.accessible,
      'Reachable by public transport':
          localization.reachable_by_public_transport,
      'Free of charge': localization.free_of_charge,
      'Bookable online': localization.bookable_online,
      'Open air': localization.open_air,
      'Card payment possible': localization.card_payment_possible,
    };
    String? displayText = toggleTextLocalizationMap[text] ?? '';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          CustomToggleButton(
              selected: isToggled,
              onValueChange: (value) => {onValueChange(value, text)}),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: textRegularPoppins(
                  text: displayText,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  textAlign: TextAlign.start,
                  textOverflow: TextOverflow.visible),
            ),
          ),
        ],
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

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
      child: textSemiBoldPoppins(
        text: text,
        fontSize: 10,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
