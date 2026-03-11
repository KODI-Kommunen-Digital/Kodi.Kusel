import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/category/category_screen_controller.dart';
import 'package:kusel/screens/category/category_screen_state.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

import '../../common_widgets/category_grid_card_view.dart';
import '../../images_path.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryScreenProvider.notifier).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryScreenState categoryScreenState =
        ref.watch(categoryScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(categoryScreenState, context),
    ).loaderDialog(context, categoryScreenState.loading);
  }

  _buildBody(CategoryScreenState categoryScreenState, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
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
                  child: ClipPath(
                    clipper: UpstreamWaveClipper(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16.r,
                  top: 68.h,
                  child: textBoldPoppins(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 18,
                      text: AppLocalizations.of(context).category_heading),
                ),
              ],
            ),
          ),
          categoryView(categoryScreenState, context),
          80.verticalSpace
        ],
      ),
    );
  }

  categoryView(CategoryScreenState categoryScreenState, BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 135.h),
        itemCount: categoryScreenState.exploreCategories.length,
        itemBuilder: (BuildContext context, int index) {
          var exploreCategory = categoryScreenState.exploreCategories[index];
          return GestureDetector(
            onTap: () {
              if (ref
                  .read(categoryScreenProvider.notifier)
                  .isSubCategoryAvailable(exploreCategory)) {
                ref.read(navigationProvider).navigateUsingPath(
                    path: subCategoryScreenPath,
                    context: context,
                    params: SubCategoryScreenParameters(
                        id: exploreCategory.id ?? 0,
                        categoryHeading: exploreCategory.name ?? ""));
              } else {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    // Need to be replaced with actual lat-long value
                    params: SelectedEventListScreenParameter(
                        radius: 1,
                        centerLatitude: EventLatLong.kusel.latitude,
                        centerLongitude: EventLatLong.kusel.longitude,
                        listHeading: exploreCategory.name ?? "" ?? '',
                        categoryId: exploreCategory.id,
                        onFavChange: () {}),
                    context: context);
              }
            },
            child: CategoryGridCardView(
              imageUrl: exploreCategory.image ?? "",
              title: exploreCategory.name ?? "",
            ),
          );
        });
  }
}
