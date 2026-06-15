import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/local_image_text_service_card.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/all_event/all_event_screen_param.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/tourism/tourism_screen_controller.dart';
import 'package:kusel/utility/url_launcher_utility.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/location_const.dart';
import '../../common_widgets/map_widget/custom_flutter_map.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../common_widgets/web_view_page.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';

class TourismScreen extends ConsumerStatefulWidget {
  const TourismScreen({super.key});

  @override
  ConsumerState<TourismScreen> createState() => _TourismScreenState();
}

class _TourismScreenState extends ConsumerState<TourismScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(tourismScreenControllerProvider.notifier)
          .getRecommendationListing();
      ref.read(tourismScreenControllerProvider.notifier).getAllEvents();
      ref.read(tourismScreenControllerProvider.notifier).getNearByListing();

      ref.read(tourismScreenControllerProvider.notifier).isUserLoggedIn();
    });
    MatomoService.trackTourismScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (ref.watch(tourismScreenControllerProvider).isRecommendationLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(tourismScreenControllerProvider);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(tourismScreenControllerProvider.notifier)
              .getRecommendationListing();
          ref.read(tourismScreenControllerProvider.notifier).getAllEvents();
          ref.read(tourismScreenControllerProvider.notifier).getNearByListing();

          ref.read(tourismScreenControllerProvider.notifier).isUserLoggedIn();
        },
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonBackgroundClipperWidget(
                  clipperType: UpstreamWaveClipper(),
                  imageUrl: imagePath['background_image'] ?? "",
                  height: 120.h,
                  blurredBackground: true,
                  isStaticImage: true,
                  customWidget1: Positioned(
                    left: 20,
                    right: 10,
                    top: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
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
                              Icons.arrow_back,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 38.0),
                            child: textBoldPoppins(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 20,
                              text: AppLocalizations.of(context)
                                  .tourism_and_leisure,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildRecommendation(context),
                32.verticalSpace,
                _buildLocationWidget(context),
                22.verticalSpace,
                if (state.nearByList.isNotEmpty)
                  EventsListSectionWidget(
                    context: context,
                    eventsList: state.nearByList,
                    heading: AppLocalizations.of(context).near_you,
                    maxListLimit: 5,
                    buttonText: AppLocalizations.of(context).show_all_events,
                    buttonIconPath: imagePath['map_icon'] ?? "",
                    isLoading: false,
                    onButtonTap: () {
                      final searchRadius = SearchRadius.radius.value;
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading:
                                  AppLocalizations.of(context).near_you,
                              centerLongitude: state.long,
                              centerLatitude: state.lat,
                              categoryId: 3,
                              radius: searchRadius,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider
                                        .notifier)
                                    .getNearByListing();
                              }));
                    },
                    onHeadingTap: () {
                      final searchRadius = SearchRadius.radius.value;
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              categoryId: 3,
                              listHeading:
                                  AppLocalizations.of(context).near_you,
                              centerLongitude: state.long,
                              centerLatitude: state.lat,
                              radius: searchRadius,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider
                                        .notifier)
                                    .getNearByListing();
                              }));
                    },
                    isFavVisible: true,
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .updateNearByIsFav(isFav, id);
                    },
                    onFavClickCallback: () {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .getNearByListing();
                    },
                  ),
                4.verticalSpace,
                LocalSvgImageTextServiceCard(
                  onTap: () => ref.read(navigationProvider).navigateUsingPath(
                      path: webViewPagePath,
                      params: WebViewParams(
                          url:
                              "https://www.pfaelzerbergland.de/de/aktiv-in-der-natur/wandern"),
                      context: context),
                  imageUrl: 'tourism_service_image',
                  text: AppLocalizations.of(context).hiking_trails,
                  description:
                      AppLocalizations.of(context).discover_kusel_on_foot,
                ),
                20.verticalSpace,
                if (state.allEventList.isNotEmpty)
                  EventsListSectionWidget(
                    context: context,
                    eventsList: state.allEventList,
                    heading: AppLocalizations.of(context).event_text,
                    maxListLimit: 5,
                    isLoading: false,
                    onHeadingTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading:
                                  AppLocalizations.of(context).event_text,
                              categoryId: ListingCategoryId.event.eventId,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider
                                        .notifier)
                                    .getAllEvents();
                              }));
                    },
                    isFavVisible: true,
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .updateEventIsFav(isFav, id);
                    },
                    onFavClickCallback: () {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .getAllEvents();
                    },
                  ),
                22.verticalSpace,
                FeedbackCardWidget(
                    height: 270.h,
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: feedbackScreenPath, context: context);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRecommendation(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tourismScreenControllerProvider);
        final recommendationList = state.recommendationList;

        int currentIndex = state.highlightCount;

        return Padding(
          padding: EdgeInsets.only(left: 2.w, top: 10.h, bottom: 10.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextArrowWidget(
                      text: AppLocalizations.of(context).our_recommendations,
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              path: allEventScreenPath,
                              context: context,
                              params: AllEventScreenParam(onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider
                                        .notifier)
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
                    itemBuilder: (context, index) {
                      final item = recommendationList[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: HighlightsCard(
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
                                          .read(tourismScreenControllerProvider
                                              .notifier)
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
                                  .read(
                                      tourismScreenControllerProvider.notifier)
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
                          .read(tourismScreenControllerProvider.notifier)
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

  _buildLocationWidget(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final borderRadius = 10.r;
        final list = ref.watch(tourismScreenControllerProvider).nearByList;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          height: 300.h,
          width: double.infinity,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.w, right: 20.w),
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        topLeft: Radius.circular(borderRadius))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20.h.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        10.horizontalSpace,
                        textRegularPoppins(
                            text: AppLocalizations.of(context).near_you,
                            fontSize: 14)
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                      width: 18.w,
                      child: ImageUtil.loadLocalSvgImage(
                          imageUrl: 'expand_full',
                          context: context,
                          fit: BoxFit.contain),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: CustomFlutterMap(
                  latitude: EventLatLong.kusel.latitude,
                  longitude: EventLatLong.kusel.longitude,
                  height: 250.h,
                  width: MediaQuery.of(context).size.width,
                  initialZoom: 13,
                  onMapTap: () {},
                  markersList: (list.isNotEmpty)
                      ? list
                          .where((item) =>
                              item.latitude != null && item.longitude != null)
                          .map((item) {
                          return Marker(
                              point: LatLng(item.latitude!, item.longitude!),
                              child: Icon(Icons.location_pin,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryFixed));
                        }).toList()
                      : [],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
