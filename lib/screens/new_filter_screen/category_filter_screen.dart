import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_controller.dart';

import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../l10n/app_localizations.dart';

class CategoryFilterScreen extends ConsumerStatefulWidget {
  CategoryScreenParams categoryScreenParams;

  CategoryFilterScreen({super.key, required this.categoryScreenParams});

  @override
  ConsumerState<CategoryFilterScreen> createState() =>
      _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends ConsumerState<CategoryFilterScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(newFilterScreenControllerProvider.notifier)
          .assignCategoryTemporaryValues(
              widget.categoryScreenParams.selectedCategoryIdList,
              widget.categoryScreenParams.selectedCategoryNameList);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 26.0),
            child: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_back,
                color: Theme.of(context).primaryColor),
          )),
      title: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 30.0),
        child: textSemiBoldPoppins(
            text: AppLocalizations.of(context).category,
            fontSize: 22,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final controller = ref.watch(newFilterScreenControllerProvider);
    final controllerNotifier =
        ref.read(newFilterScreenControllerProvider.notifier);
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          height: 400.h,
          margin: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: theme.canvasColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _SelectableRow(
                  label: appLoc.all,
                  isSelected: controller.tempCategoryIdList.isEmpty,
                  onTap: () => controllerNotifier.updateCategoryAllValue(),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 0,
                endIndent: 0,
                height: 1,
              ),
              if (controller.categoryList.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    itemCount: controller.categoryList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (context, index) {
                      final category = controller.categoryList[index];
                      return _SelectableRow(
                        label: category.name ?? '',
                        isSelected:
                            controller.tempCategoryIdList.contains(category.id)
                                ? true
                                : false,
                        onTap: () => controllerNotifier
                            .updateSelectedCategoryList(category),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 150.w,
                child: CustomButton(
                  textSize: 16,
                  onPressed: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
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
                    onPressed: () async {
                      final controller =
                          ref.read(newFilterScreenControllerProvider.notifier);

                      await controller.assignCategoryValues();

                      ref
                          .read(navigationProvider)
                          .removeTopPage(context: context);
                    },
                    text: AppLocalizations.of(context).apply))
          ],
        )
      ],
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            SizedBox(
              height: 30.h,
              width: 35.w,
              child: isSelected
                  ? ImageUtil.loadLocalSvgImage(
                      height: 35.h,
                      width: 35.w,
                      imageUrl: "correct",
                      context: context,
                    )
                  : null,
            ),
            16.horizontalSpace,
            textBoldMontserrat(text: label, fontSize: 15),
          ],
        ),
      ),
    );
  }
}

class CategoryScreenParams {
  List<int> selectedCategoryIdList;
  List<String> selectedCategoryNameList;

  CategoryScreenParams(
      {required this.selectedCategoryIdList,
      required this.selectedCategoryNameList});
}
