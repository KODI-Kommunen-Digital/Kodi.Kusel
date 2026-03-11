import 'package:domain/model/response_model/filter/get_filter_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/new_filter_screen/category_filter_screen.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_controller.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_params.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

import '../../common_widgets/calendar_dialog.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/text_styles.dart';

class NewFilterScreen extends ConsumerStatefulWidget {
  NewFilterScreenParams params;

  NewFilterScreen({super.key, required this.params});

  @override
  ConsumerState<NewFilterScreen> createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends ConsumerState<NewFilterScreen> {
  TextEditingController periodTextEditingController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(newFilterScreenControllerProvider.notifier).fetchFilterList(
          selectedCityName: widget.params.selectedCityName,
          selectedCityId: widget.params.selectedCityId,
          radius: widget.params.radius,
          categoryIdList: widget.params.selectedCategoryId,
          categoryNameList: widget.params.selectedCategoryName,
          endDate: widget.params.endDate,
          startDate: widget.params.startDate);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!KuselDateUtils.checkDatesAreSame(
          widget.params.startDate, defaultDate)) {
        periodTextEditingController.text =
            KuselDateUtils.formatDateInFormatDDMMYYYY(
                widget.params.startDate.toString());

        if (!KuselDateUtils.checkDatesAreSame(
            widget.params.endDate, defaultDate)) {
          final toLabel = AppLocalizations.of(context).to;
          periodTextEditingController.text =
              "${periodTextEditingController.text} $toLabel ${KuselDateUtils.formatDateInFormatDDMMYYYY(widget.params.endDate.toString())}";
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newFilterScreenControllerProvider);

    return PopScope(
      onPopInvokedWithResult: (value, _) {},
      child: Scaffold(
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildBody(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 20.0),
      child: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              ref
                  .read(navigationProvider)
                  .removeTopPageAndReturnValue(context: context, result: null);
            },
            icon: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_back,
                color: Theme.of(context).primaryColor)),
        title: textSemiBoldPoppins(
            text: AppLocalizations.of(context).filter,
            fontSize: 22,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(newFilterScreenControllerProvider.notifier).reset();
              periodTextEditingController.text = "";
            },
            child: textBoldMontserrat(
                text: AppLocalizations.of(context).reset,
                color: Theme.of(context).colorScheme.secondary),
          )
        ],
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          22.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: textRegularMontserrat(
              text: AppLocalizations.of(context).period,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .color
                  ?.withOpacity(0.9),
            ),
          ),
          4.verticalSpace,
          KuselTextField(
            hintText: AppLocalizations.of(context).today,
            enableBorderColor: Theme.of(context).dividerColor,
            onTap: () async {
              await showCommonDateRangeDialog(
                context: context,
                startDate: KuselDateUtils.checkDatesAreSame(
                        ref.read(newFilterScreenControllerProvider).startDate,
                        defaultDate)
                    ? null
                    : ref.read(newFilterScreenControllerProvider).startDate,
                endDate: KuselDateUtils.checkDatesAreSame(
                        ref.read(newFilterScreenControllerProvider).endDate,
                        defaultDate)
                    ? null
                    : ref.read(newFilterScreenControllerProvider).endDate,
                onDateChanged: (result) {
                  debugPrint("Date range changed: $result");

                  if (result.isNotEmpty) {
                    periodTextEditingController.text = "";
                    DateTime startDate = result[0] ?? defaultDate;
                    DateTime endDate = (result.length > 1 && result[1] != null)
                        ? result[1]!
                        : defaultDate;

                    if (!KuselDateUtils.checkDatesAreSame(
                        startDate, defaultDate)) {
                      periodTextEditingController.text =
                          KuselDateUtils.formatDateInFormatDDMMYYYY(
                              // Changed here
                              startDate.toString());
                    }

                    if (!KuselDateUtils.checkDatesAreSame(
                        endDate, defaultDate)) {
                      periodTextEditingController.text =
                          "${periodTextEditingController.text} ${AppLocalizations.of(context).to} ${KuselDateUtils.formatDateInFormatDDMMYYYY(endDate.toString())}"; // Changed here
                    }

                    ref
                        .read(newFilterScreenControllerProvider.notifier)
                        .updateStartEndDate(startDate, endDate);
                  }
                },
              );
            },
            readOnly: true,
            textEditingController: periodTextEditingController,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                Icons.calendar_month_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          12.verticalSpace,
          Divider(
            thickness: 1,
          ),
          12.verticalSpace,
          _buildCategory(context),
          8.verticalSpace,
          _buildLocationAndDistance(context),
          185.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 150.w,
                  child: CustomButton(
                    textSize: 16,
                    onPressed: () {
                      ref.read(navigationProvider).removeTopPageAndReturnValue(
                          context: context, result: null);
                    },
                    isOutLined: true,
                    text: AppLocalizations.of(context).digifit_abort,
                    textColor: Theme.of(context).primaryColor,
                  )),
              SizedBox(
                  width: 150.w,
                  child: CustomButton(
                      textSize: 16,
                      icon: "assets/png/check.png",
                      iconHeight: 20.h,
                      iconWidth: 20.w,
                      onPressed: () {
                        final state =
                            ref.read(newFilterScreenControllerProvider);

                        ref
                            .read(navigationProvider)
                            .removeTopPageAndReturnValue(
                                context: context,
                                result: NewFilterScreenParams(
                                    selectedCityId: state.selectedCityId,
                                    selectedCityName: state.selectedCityName,
                                    radius: state.sliderValue,
                                    startDate: state.startDate,
                                    endDate: state.endDate,
                                    selectedCategoryName:
                                        List.from(state.selectedCategoryName),
                                    selectedCategoryId:
                                        List.from(state.selectedCategoryId)));
                      },
                      text: AppLocalizations.of(context).apply))
            ],
          )
        ],
      ),
    );
  }

  _buildCategory(BuildContext context) {
    return _buildCommonChipCard(
        ref.read(newFilterScreenControllerProvider).selectedCategoryName,
        AppLocalizations.of(context).category, () {
      ref.read(navigationProvider).navigateUsingPath(
          path: categoryFilterScreenPath,
          context: context,
          params: CategoryScreenParams(
              selectedCategoryIdList: List.from(ref
                  .read(newFilterScreenControllerProvider)
                  .selectedCategoryId),
              selectedCategoryNameList: List.from(ref
                  .read(newFilterScreenControllerProvider)
                  .selectedCategoryName)));
    });
  }

  _buildLocationAndDistance(BuildContext context) {
    return _buildCommonTextCard(
        AppLocalizations.of(context).location_and_distance,
        ref.read(newFilterScreenControllerProvider).selectedCityName, () {
      ref.read(navigationProvider).navigateUsingPath(
            path: locationDistanceScreenPath,
            context: context,
          );
    });
  }

  Widget _buildCommonChipCard(
      List<String> chipList, String tileTitle, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 20.w, top: 16.h, bottom: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBoldMontserrat(
                      text: tileTitle,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                  8.verticalSpace,

                  // When no cities are selected
                  if (chipList.isEmpty)
                    textSemiBoldMontserrat(
                        text: AppLocalizations.of(context).all,
                        fontSize: 14,
                        color: const Color(0xFF6972A8)),

                  // When chips exist
                  if (chipList.isNotEmpty)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        // Take first 3 chips
                        ...chipList.take(3).map((item) => _buildChip(item)),

                        // If more than 3, show +N chip
                        if (chipList.length > 3)
                          _buildChip('+${chipList.length - 3}', isExtra: true),
                      ],
                    ),
                ],
              ),
            ),
            Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

// Helper chip builder
  Widget _buildChip(String label, {bool isExtra = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isExtra ? 16.w : 16.w,
        // Increase horizontal padding for +N chip
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: isExtra ? Colors.transparent : const Color(0xFFAADB40),
        borderRadius: BorderRadius.circular(20.r),
        border: isExtra
            ? Border.all(
                color: const Color(0xFFAADB40),
                width: 1.5,
              )
            : null,
      ),
      child: textRegularMontserrat(
          text: label,
          fontSize: 15,
          color: Theme.of(context).textTheme.displayMedium!.color),
    );
  }

  _buildCommonTextCard(String tileTitle, String subTitle, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 20.w, top: 16.h, bottom: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(20.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBoldMontserrat(text: tileTitle, fontSize: 16),
                8.verticalSpace,
                if (subTitle.isEmpty)
                  textSemiBoldMontserrat(
                      text: AppLocalizations.of(context).all,
                      color: Color.fromRGBO(105, 114, 168, 1)),
                if (subTitle.isNotEmpty)
                  textSemiBoldMontserrat(
                      text: subTitle,
                      fontSize: 14,
                      color: Color.fromRGBO(105, 114, 168, 1))
              ],
            ),
            Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }
}
