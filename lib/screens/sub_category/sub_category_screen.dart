import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/category_grid_card_view.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/sub_category/sub_category_controller.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';

import '../../theme_manager/colors.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';

class SubCategoryScreen extends ConsumerStatefulWidget {
  final SubCategoryScreenParameters subCategoryScreenParameters;

  const SubCategoryScreen(
      {super.key, required this.subCategoryScreenParameters});

  @override
  ConsumerState<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(subCategoryProvider.notifier)
          .getAllSubCategory(categoryId: widget.subCategoryScreenParameters.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ).loaderDialog(context, ref.read(subCategoryProvider).isLoading),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image at the top
            Positioned(
              top: 0.h,
              child: ClipPath(
                clipper: UpstreamWaveClipper(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .16,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    imagePath['background_image'] ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Blurred overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: Container(
                  color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.4),
                ),
              ),
            ),

            Positioned(
              // left: 16.r,
              top: 25.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      ArrowBackWidget(
                        onTap: () {
                          ref.read(navigationProvider).removeTopPage(context: context);
                        },
                        size: 15,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 18.h),
                          child: textBoldPoppins(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16,
                              textAlign: TextAlign.center,
                              text: widget.subCategoryScreenParameters.categoryHeading),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
                top: MediaQuery.of(context).size.height * .10,
                child: categoryView(context))
          ],
        ),
      ),
    );
  }

  Widget categoryView(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 135.h),
        itemCount: ref.watch(subCategoryProvider).subCategoryDataList.length,
        itemBuilder: (BuildContext context, int index) {
          var exploreSubCategory =
              ref.read(subCategoryProvider).subCategoryDataList[index];
          return GestureDetector(
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: selectedEventListScreenPath,
                  context: context,
                  params:
                  // Need to be replaced with actual lat-long value
                  SelectedEventListScreenParameter(
                      radius: 1,
                      centerLatitude: EventLatLong.kusel.latitude,
                      centerLongitude: EventLatLong.kusel.longitude,
                      categoryId: widget.subCategoryScreenParameters.id,
                      subCategoryId: exploreSubCategory.id,
                      listHeading: exploreSubCategory.name ?? "", onFavChange: () {  }));
            },
            child: CategoryGridCardView(
              imageUrl:
                  exploreSubCategory.image ?? "",
              title: exploreSubCategory.name ?? "",
            ),
          );
        });
  }
}
