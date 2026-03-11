import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_progress_bar.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_provider.dart';
import 'package:kusel/screens/all_event/all_event_screen_controller.dart';
import 'package:kusel/screens/all_event/all_event_screen_param.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_params.dart';
import 'package:kusel/theme_manager/colors.dart';

import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../event/event_detail_screen_controller.dart';

class AllEventScreen extends ConsumerStatefulWidget {
  String screenName = "allEventScreen";

  AllEventScreenParam allEventScreenParam;

  AllEventScreen({super.key, required this.allEventScreenParam});

  @override
  ConsumerState<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends ConsumerState<AllEventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(allEventScreenProvider.notifier).getRecommendationListing();
      final currentPageNumber = ref.read(allEventScreenProvider).currentPageNo;
      ref.read(allEventScreenProvider.notifier).getListing(currentPageNumber);
      ref.read(filterScreenProvider.notifier).onReset();
      ref.read(datePickerProvider.notifier).resetDates();
      ref.read(allEventScreenProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageNumber = ref.read(allEventScreenProvider).currentPageNo;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(allEventScreenProvider.notifier)
                  .getRecommendationListing();
              final currentPageNumber =
                  ref.read(allEventScreenProvider).currentPageNo;
              ref
                  .read(allEventScreenProvider.notifier)
                  .getListing(currentPageNumber);
              ref.read(filterScreenProvider.notifier).onReset();
              ref.read(datePickerProvider.notifier).resetDates();
              ref.read(allEventScreenProvider.notifier).isUserLoggedIn();
            },
            child: Stack(
              children: [
                _buildBody(context, currentPageNumber),
                if (ref.watch(allEventScreenProvider).isLoading)
                  CustomProgressBar()
              ],
            ),
          ),
        ));
  }

  Widget _buildBody(BuildContext context, int currentPageNumber) {
    final state = ref.watch(allEventScreenProvider);

    return Stack(
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 110.h,
                  child: CommonBackgroundClipperWidget(
                    clipperType: UpstreamWaveClipper(),
                    imageUrl: imagePath['home_screen_background'] ?? "",
                    height: 110.h,
                    blurredBackground: true,
                    isStaticImage: true,
                    customWidget1: Positioned(
                      left: 0.w,
                      top: 28.h,
                      child: Row(
                        children: [
                          18.horizontalSpace,
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(navigationProvider)
                                    .removeTopPage(context: context);
                              },
                              icon: Icon(
                                  size: DeviceHelper.isMobile(context)
                                      ? null
                                      : 12.h.w,
                                  color: Theme.of(context).primaryColor,
                                  Icons.arrow_back)),
                          8.horizontalSpace,
                          textBoldPoppins(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 22,
                              text: AppLocalizations.of(context).event_text),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildRecommendation(context),
                10.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: textSemiBoldPoppins(
                            text:
                                AppLocalizations.of(context).all_events_filter,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      GestureDetector(
                        onTap: () {
                          final state = ref.read(allEventScreenProvider);

                          ref
                              .read(navigationProvider)
                              .navigateUsingPath(
                                  path: newFilterScreenPath,
                                  context: context,
                                  params: NewFilterScreenParams(
                                      selectedCityId: state.selectedCityId,
                                      selectedCityName: state.selectedCityName,
                                      radius: state.radius,
                                      startDate: state.startDate,
                                      endDate: state.endDate,
                                      selectedCategoryName: List.from(
                                          state.selectedCategoryNameList),
                                      selectedCategoryId: List.from(
                                          state.selectedCategoryIdList)))
                              .then((value) async {
                            if (value != null) {
                              final res = value as NewFilterScreenParams;

                              await ref
                                  .read(allEventScreenProvider.notifier)
                                  .applyNewFilterValues(
                                      res.selectedCategoryName,
                                      res.selectedCityId,
                                      res.selectedCityName,
                                      res.radius,
                                      res.startDate,
                                      res.endDate,
                                      res.selectedCategoryId);

                              await ref
                                  .read(allEventScreenProvider.notifier)
                                  .getListing(1);
                            }
                          });
                        },
                        child: Badge(
                          backgroundColor: Colors.transparent,
                          alignment: Alignment.topCenter,
                          isLabelVisible: ref
                                  .watch(allEventScreenProvider)
                                  .numberOfFiltersApplied !=
                              0,
                          label: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 4.h),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightThemeHighlightGreenColor,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            child: Center(
                              child: textSemiBoldMontserrat(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  text: ref
                                      .watch(allEventScreenProvider)
                                      .numberOfFiltersApplied
                                      .toString(),
                                  fontSize: 14),
                            ),
                          ),
                          child: ImageUtil.loadLocalSvgImage(
                              imageUrl: 'filter_button',
                              context: context,
                              height: 35.h,
                              width: 35.w),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.selectedCategoryNameList.isNotEmpty) ...[
                  16.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: state.selectedCategoryNameList
                              .map((value) => _buildChip(value))
                              .toList(),
                        ),
                      ),
                      8.verticalSpace,
                    ],
                  ),
                ],
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.listingList.isEmpty)
                  Center(
                    child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data,
                    ),
                  )
                else
                  EventsListSectionWidget(
                    eventsList: state.listingList,
                    heading: null,
                    maxListLimit: state.listingList.length,
                    buttonText: null,
                    buttonIconPath: null,
                    isLoading: false,
                    onButtonTap: () {},
                    context: context,
                    isFavVisible: true,
                    onHeadingTap: () {},
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(allEventScreenProvider.notifier)
                          .updateIsFav(isFav, id);
                      widget.allEventScreenParam.onFavChange();
                    },
                    onFavClickCallback: () {
                      ref
                          .read(allEventScreenProvider.notifier)
                          .getListing(currentPageNumber);
                    },
                    isMultiplePagesList: state.isLoadMoreButtonEnabled,
                    onLoadMoreTap: () {
                      ref
                          .read(allEventScreenProvider.notifier)
                          .onLoadMoreList(currentPageNumber);
                    },
                    isMoreListLoading: state.isMoreListLoading,
                  ),
                20.verticalSpace,
                FeedbackCardWidget(
                  height: 240.h,
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: feedbackScreenPath, context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildRecommendation(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(allEventScreenProvider);
        final recommendationList = state.recommendationList;

        int currentIndex = state.highlightCount;

        return Padding(
          padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextArrowWidget(
                      fontSize: 18,
                      text: AppLocalizations.of(context).our_recommendations,
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              path: allEventScreenPath,
                              context: context,
                              params: AllEventScreenParam(onFavChange: () {
                                ref
                                    .read(allEventScreenProvider.notifier)
                                    .getRecommendationListing();
                              }),
                            );
                      },
                    ),
                    if (recommendationList.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            recommendationList.length,
                            (index) => Icon(
                              Icons.circle,
                              size: currentIndex == index ? 11 : 8,
                              color: currentIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withAlpha(130),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              20.verticalSpace,
              // Content area similar to PageView in customPageViewer
              if (recommendationList.isEmpty)
                const SizedBox.shrink()
              else
                SizedBox(
                  height: DeviceHelper.isMobile(context) ? 315.h : 340.h,
                  child: PageView.builder(
                    controller: PageController(
                        viewportFraction:
                            317.w / MediaQuery.of(context).size.width * .9),
                    scrollDirection: Axis.horizontal,
                    padEnds: false,
                    itemCount: min(recommendationList.length, 5),
                    // keep your original limit
                    itemBuilder: (context, index) {
                      final item = recommendationList[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: HighlightsCard(
                          imageFit: BoxFit.cover,
                          date: item.startDate,
                          cardWidth: 280.w,
                          sourceId: item.sourceId ?? 3,
                          imageUrl: item.logo ?? "",
                          heading: item.title ?? "",
                          description: item.description ?? "",
                          isFavourite: item.isFavorite ?? false,
                          isFavouriteVisible: true,
                          onPress: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  path: eventDetailScreenPath,
                                  context: context,
                                  params: EventDetailScreenParams(
                                    eventId: item.id ?? 0,
                                    onFavClick: () {
                                      ref
                                          .read(allEventScreenProvider.notifier)
                                          .getRecommendationListing();
                                    },
                                  ),
                                );
                          },
                          onFavouriteIconClick: () {
                            ref
                                .watch(favoritesProvider.notifier)
                                .toggleFavorite(item,
                                    success: ({required bool isFavorite}) {
                              ref
                                  .read(allEventScreenProvider.notifier)
                                  .updateRecommendationIsFav(
                                      isFavorite, item.id);
                            }, error: ({required String message}) {
                              showErrorToast(
                                  message: message, context: context);
                            });
                          },
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      ref
                          .read(allEventScreenProvider.notifier)
                          .updateCardIndex(index);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, {bool isExtra = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isExtra ? 16.w : 16.w,
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
}
