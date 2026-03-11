import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/local_image_text_service_card.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_controller.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_state.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_bottom_nav_card_.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/listing_id_enum.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/web_view_page.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../../providers/favourite_cities_notifier.dart';
import '../all_event/all_event_screen_param.dart';
import '../event/event_detail_screen_controller.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';
import '../full_image/full_image_screen.dart';
import '../municipal_party_detail/widget/municipal_detail_location_widget.dart';
import 'ort_detail_screen_params.dart';

class OrtDetailScreen extends ConsumerStatefulWidget {
  OrtDetailScreenParams ortDetailScreenParams;

  OrtDetailScreen({super.key, required this.ortDetailScreenParams});

  @override
  ConsumerState<OrtDetailScreen> createState() => _OrtDetailScreenState();
}

class _OrtDetailScreenState extends ConsumerState<OrtDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(ortDetailScreenControllerProvider.notifier)
          .getOrtDetail(ortId: widget.ortDetailScreenParams.ortId);
      ref.read(ortDetailScreenControllerProvider.notifier).getHighlights();
      ref
          .read(ortDetailScreenControllerProvider.notifier)
          .getEvents(widget.ortDetailScreenParams.ortId);
      ref
          .read(ortDetailScreenControllerProvider.notifier)
          .getNews(widget.ortDetailScreenParams.ortId);

      ref.read(ortDetailScreenControllerProvider.notifier).isUserLoggedIn();
    });
    MatomoService.trackMeinOrtScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    ).loaderDialog(
        context, ref.watch(ortDetailScreenControllerProvider).isLoading);
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(ortDetailScreenControllerProvider);
    final ortDetailDataModel = state.ortDetailDataModel;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(ortDetailScreenControllerProvider.notifier)
              .getOrtDetail(ortId: widget.ortDetailScreenParams.ortId);
          ref.read(ortDetailScreenControllerProvider.notifier).getHighlights();
          ref
              .read(ortDetailScreenControllerProvider.notifier)
              .getEvents(widget.ortDetailScreenParams.ortId);
          ref
              .read(ortDetailScreenControllerProvider.notifier)
              .getNews(widget.ortDetailScreenParams.ortId);

          ref.read(ortDetailScreenControllerProvider.notifier).isUserLoggedIn();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildScreen(context),
            ),
            Positioned(
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () {
                    ref.read(navigationProvider).removeTopPage(context: context);
                  },
                  isFavVisible: true,
                  isFav: ortDetailDataModel?.isFavorite ?? false,
                  onFavChange: () {
                    ref.watch(favouriteCitiesNotifier.notifier).toggleFavorite(
                          isFavourite: ortDetailDataModel?.isFavorite,
                          id: ortDetailDataModel?.id,
                          success: ({required bool isFavorite}) {
                            _updateCityFavStatus(
                                isFavorite, ortDetailDataModel?.id ?? 0);
                            widget.ortDetailScreenParams.onFavSuccess!(
                                isFavorite, ortDetailDataModel?.id ?? 0);
                          },
                          error: ({required String message}) {
                            showErrorToast(message: message, context: context);
                          },
                        );
                  },
                )),
          ],
        ),
      ),
    );
  }

  _buildScreen(BuildContext context) {
    final state = ref.watch(ortDetailScreenControllerProvider);
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildClipper(),
            _buildTitle(context),
            _buildDescription(context),
            10.verticalSpace,
            _buildButton(context),
            8.verticalSpace,
            customPageViewer(),
            20.verticalSpace,
            if (ref
                .watch(ortDetailScreenControllerProvider)
                .eventsList
                .isNotEmpty)
              EventsListSectionWidget(
                boxFit: BoxFit.cover,
                context: context,
                eventsList: state.eventsList,
                heading: AppLocalizations.of(context).all_events,
                maxListLimit: 3,
                buttonText: AppLocalizations.of(context).all_events,
                buttonIconPath: imagePath['calendar'] ?? "",
                isLoading: false,
                onButtonTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: allEventScreenPath,
                      context: context,
                      params: AllEventScreenParam(onFavChange: () {
                        ref
                            .read(ortDetailScreenControllerProvider.notifier)
                            .getEvents(widget.ortDetailScreenParams.ortId);
                      }));
                },
                onHeadingTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: allEventScreenPath,
                      context: context,
                      params: AllEventScreenParam(onFavChange: () {
                        ref
                            .read(ortDetailScreenControllerProvider.notifier)
                            .getEvents(widget.ortDetailScreenParams.ortId);
                      }));
                },
                onFavClickCallback: () {
                  ref
                      .read(ortDetailScreenControllerProvider.notifier)
                      .getEvents(widget.ortDetailScreenParams.ortId);
                },
                onSuccess: (isFav, eventId) {
                  ref
                      .read(ortDetailScreenControllerProvider.notifier)
                      .setIsFavoriteEvent(isFav, eventId);
                },
                isFavVisible: true,
              ),
            if (state.newsList != null && state.newsList!.isNotEmpty)
              EventsListSectionWidget(
                boxFit: BoxFit.cover,
                context: context,
                eventsList: state.newsList ?? [],
                heading: AppLocalizations.of(context).news,
                maxListLimit: 5,
                buttonText: AppLocalizations.of(context).all_news,
                buttonIconPath: imagePath['map_icon'] ?? "",
                isLoading: false,
                onButtonTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          cityId: 1,
                          listHeading: AppLocalizations.of(context).news,
                          categoryId: ListingCategoryId.news.eventId,
                          onFavChange: () {
                            ref
                                .read(
                                    ortDetailScreenControllerProvider.notifier)
                                .getNews(widget.ortDetailScreenParams.ortId);
                          }));
                },
                onHeadingTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          cityId: 1,
                          listHeading: AppLocalizations.of(context).news,
                          categoryId: ListingCategoryId.news.eventId,
                          onFavChange: () {
                            ref
                                .read(
                                    ortDetailScreenControllerProvider.notifier)
                                .getNews(widget.ortDetailScreenParams.ortId);
                          }));
                },
                isFavVisible: true,
                onFavClickCallback: () {
                  ref
                      .read(ortDetailScreenControllerProvider.notifier)
                      .getEvents(widget.ortDetailScreenParams.ortId);
                },
                onSuccess: (bool isFav, int? id) {
                  ref
                      .read(ortDetailScreenControllerProvider.notifier)
                      .updateNewsIsFav(isFav, id);
                },
              ),
            if(ref.watch(ortDetailScreenControllerProvider).ortDetailDataModel?.mayorName!=null)
            // _buildMayorCard(),
            LocalSvgImageTextServiceCard(
              onTap: () => ref.read(navigationProvider).navigateUsingPath(
                  path: webViewPagePath,
                  params: WebViewParams(url: "https://www.pfaelzerbergland.de/de/aktiv-in-der-natur/wandern"),
                  context: context),
              imageUrl: 'tourism_service_image',
              text: AppLocalizations.of(context).hiking_trails,
              description: AppLocalizations.of(context).discover_kusel_on_foot,
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CityDetailLocationWidget(
                phoneNumber: state.ortDetailDataModel?.phone ?? '-',
                webUrl: state.ortDetailDataModel?.websiteUrl ?? "",
                address: state.ortDetailDataModel?.address ?? "-",
                websiteText: AppLocalizations.of(context).visit_website,
                calendarText: state.ortDetailDataModel?.openUntil ?? "",
                lat: state.latitude,
                long: state.longitude,
              ),
            ),
            20.verticalSpace,
            FeedbackCardWidget(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: feedbackScreenPath, context: context);
              },
              height: 270.h,
            ),
          ],
        ));
  }

  _buildMayorCard() {
    final state = ref.watch(ortDetailScreenControllerProvider);
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Card(
        color: Theme.of(context).canvasColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              child: Row(
                children: [
                  (state.ortDetailDataModel?.mayorImage != null)
                      ? ImageUtil.loadNetworkImage(
                          imageUrl: state.ortDetailDataModel!.mayorImage!,
                          context: context,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 70.h.w,
                          color: Theme.of(context).hintColor,
                        ),
                  20.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textBoldPoppins(
                          fontWeight: FontWeight.w600,
                          text: state.ortDetailDataModel?.mayorName ??
                              "Maxime Musterfrau",
                          fontSize: 13,
                          textOverflow: TextOverflow.visible,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: textSemiBoldPoppins(
                            text: state.ortDetailDataModel?.mayorDescription ??
                                "In diesem Abschnitt werden ein paar Worte über den bzw. die amtierende Bürger-meister:in gesagt.",
                            fontSize: 12,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w200,
                            textOverflow: TextOverflow.visible,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildClipper() {
    final state = ref.watch(ortDetailScreenControllerProvider);
    return Stack(
      children: [
        SizedBox(
          height: 260.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['city_background_image'] ?? "",
            height: 260.h,
            isBackArrowEnabled: true,
            isStaticImage: true,
          ),
        ),
        Positioned(
          top: 132.h,
          left: 0.w,
          right: 0.w,
          child: Card(
            elevation: 8,
            shape: CircleBorder(),
            child: Container(
              height: 120.h,
              width: 70.w,
              padding: EdgeInsets.all(30.w),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: (state.ortDetailDataModel?.image != null)
                  ? ImageUtil.loadNetworkImage(
                       memCacheWidth: 130,
                      memCacheHeight: 130,
                      imageUrl: state.ortDetailDataModel!.image!,
                      sourceId: 1,
                      fit: BoxFit.contain,
                      onImageTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: fullImageScreenPath,
                            params: FullImageScreenParams(
                              imageUrL: state.ortDetailDataModel!.image!,
                              sourceId: 1
                            ),
                            context: context);
                      },
                      svgErrorImagePath: imagePath['crest']!,
                      context: context,
                    )
                  : Center(
                      child: Image.asset(
                        imagePath['crest']!,
                        height: 120.h,
                        width: 100.w,
                      ),
                    ),
            ),
          ),
        )
      ],
    );
  }

  _buildTitle(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(ortDetailScreenControllerProvider);

        return Padding(
          padding: EdgeInsets.all(14.h.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBoldPoppins(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  text: state.ortDetailDataModel?.name ?? "",
                  fontSize: 18),
              10.verticalSpace,
              textSemiBoldMontserrat(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  text: state.ortDetailDataModel?.subtitle ?? "",
                  textOverflow: TextOverflow.visible)
            ],
          ),
        );
      },
    );
  }

  _buildDescription(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(ortDetailScreenControllerProvider);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: textRegularMontserrat(
            text: state.ortDetailDataModel?.description ?? "",
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            textAlign: TextAlign.start,
            maxLines: 50),
      );
    });
  }

  _buildButton(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(ortDetailScreenControllerProvider);
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: CustomButton(
            onPressed: () => ref.read(navigationProvider).navigateUsingPath(
                path: webViewPagePath,
                params:
                    WebViewParams(url: state.ortDetailDataModel!.websiteUrl!),
                context: context),
            text: AppLocalizations.of(context).view_ort),
      );
    });
  }

  _updateCityFavStatus(bool isFav, int id) {
    ref
        .read(ortDetailScreenControllerProvider.notifier)
        .setIsFavoriteCity(isFav);
    // ref.read(meinOrtProvider.notifier).setIsFavoriteCity(isFav, id);
    // ref.read(virtualTownHallProvider.notifier).setIsFavoriteMunicipality(isFav, id);
  }

  Widget customPageViewer() {
    OrtDetailScreenState state = ref.watch(ortDetailScreenControllerProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
      child: Column(
        children: [
          40.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextArrowWidget(
                  text: AppLocalizations.of(context).highlights,
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: selectedEventListScreenPath,
                        context: context,
                        params: SelectedEventListScreenParameter(
                          categoryId: ListingCategoryId.highlights.eventId,
                          listHeading: AppLocalizations.of(context).highlights,
                          onFavChange: () {
                            ref
                                .read(
                                    ortDetailScreenControllerProvider.notifier)
                                .getHighlights();
                          },
                        ));
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.highlightsList.length,
                      (index) => InkWell(
                        onTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: eventDetailScreenPath,
                              params: EventDetailScreenParams(
                                  eventId: state.highlightsList[index].id??0));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: currentIndex == index ? 11 : 8,
                              color: currentIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withAlpha(130),
                            ),
                            if (index != state.highlightsList.length - 1)
                              4.horizontalSpace
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          SizedBox(
            height: DeviceHelper.isMobile(context) ? 315.h : 340.h,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
            child: PageView.builder(
              controller: PageController(
                  viewportFraction: 317.w / MediaQuery.of(context).size.width),
              scrollDirection: Axis.horizontal,
              padEnds: false,
              itemCount: state.highlightsList.length,
              itemBuilder: (context, index) {
                final listing = state.highlightsList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.h.w),
                  child: HighlightsCard(
                    imageUrl: listing.logo ?? '',
                    date: listing.createdAt ?? "",
                    heading: listing.title ?? "",
                    description: listing.description ?? "",
                    errorImagePath: imagePath['kusel_map_image'],
                    isFavourite: listing.isFavorite ?? false,
                    onPress: () {
                      ref.read(navigationProvider).navigateUsingPath(
                            context: context,
                            path: eventDetailScreenPath,
                            params: EventDetailScreenParams(eventId: listing.id??0),
                          );
                    },
                    onFavouriteIconClick: () {
                      ref.watch(favoritesProvider.notifier).toggleFavorite(
                          listing, success: ({required bool isFavorite}) {
                        ref
                            .read(ortDetailScreenControllerProvider.notifier)
                            .setIsFavoriteHighlight(isFavorite, listing.id);
                      }, error: ({required String message}) {
                        showErrorToast(message: message, context: context);
                      });
                    },
                    isFavouriteVisible: true,
                    sourceId: listing.sourceId!,
                  ),
                );
              },
              onPageChanged: (index) {
                ref
                    .read(ortDetailScreenControllerProvider.notifier)
                    .updateCardIndex(index);
              },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
