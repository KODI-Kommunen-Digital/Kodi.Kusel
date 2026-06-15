import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/network_image_text_service_card.dart';
import 'package:kusel/common_widgets/town_hall_map_widget.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_provider.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';
import 'package:kusel/utility/url_launcher_utility.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/custom_progress_bar.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/location_const.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/web_view_page.dart';
import '../../images_path.dart';
import '../../providers/favourite_cities_notifier.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';
import '../full_image/full_image_screen.dart';

class VirtualTownHallScreen extends ConsumerStatefulWidget {
  const VirtualTownHallScreen({super.key});

  @override
  ConsumerState<VirtualTownHallScreen> createState() =>
      _VirtualTownHallScreenState();
}

class _VirtualTownHallScreenState extends ConsumerState<VirtualTownHallScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(virtualTownHallProvider.notifier).getVirtualTownHallDetails();
      ref.read(virtualTownHallProvider.notifier).isUserLoggedIn();
    });
    MatomoService.trackVirtualTownhallScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(virtualTownHallProvider.select((state) => state.loading));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(virtualTownHallProvider.notifier)
                  .getVirtualTownHallDetails();
              ref.read(virtualTownHallProvider.notifier).isUserLoggedIn();
            },
            child: Stack(
              children: [
                _buildBody(context),
                if (isLoading) CustomProgressBar(),
              ],
            ),
          ),
        ));
  }

  Widget _buildBody(BuildContext context) {
    final state = ref.read(virtualTownHallProvider);
    final isLoading = ref.watch(virtualTownHallProvider).loading;
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          _buildClipper(),
          _buildTownHallDetailsUi(state),
          _buildServicesList(onlineServicesList: state.onlineServiceList ?? []),
          _customPageViewer(municipalityList: state.municipalitiesList ?? []),
          if (state.newsList != null && state.newsList!.isNotEmpty)
            EventsListSectionWidget(
              context: context,
              boxFit: BoxFit.cover,
              eventsList: state.newsList ?? [],
              heading: AppLocalizations.of(context).news,
              maxListLimit: 5,
              buttonText: AppLocalizations.of(context).all_news,
              buttonIconPath: imagePath['news_icon'] ?? "",
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
                              .read(virtualTownHallProvider.notifier)
                              .getNewsUsingCityId(cityId: "1");
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
                              .read(virtualTownHallProvider.notifier)
                              .getNewsUsingCityId(cityId: "1");
                        }));
              },
              onFavClickCallback: () {
                ref
                    .read(virtualTownHallProvider.notifier)
                    .getVirtualTownHallDetails();
              },
              isFavVisible: false,
              onSuccess: (bool isFav, int? id) {
                ref
                    .read(virtualTownHallProvider.notifier)
                    .updateNewsIsFav(isFav, id);
              },
            ),
          if (state.eventList != null && state.eventList!.isNotEmpty)
            EventsListSectionWidget(
              boxFit: BoxFit.fill,
              context: context,
              eventsList: state.eventList ?? [],
              heading: AppLocalizations.of(context).event_text,
              maxListLimit: 5,
              buttonText: AppLocalizations.of(context).all_events,
              buttonIconPath: imagePath['calendar'] ?? "",
              isLoading: false,
              onButtonTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: 1,
                        listHeading: AppLocalizations.of(context).events,
                        categoryId: ListingCategoryId.event.eventId,
                        onFavChange: () {
                          ref
                              .read(virtualTownHallProvider.notifier)
                              .getEventsUsingCityId(cityId: "1");
                        }));
              },
              onHeadingTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: 1,
                        listHeading: AppLocalizations.of(context).events,
                        categoryId: ListingCategoryId.event.eventId,
                        onFavChange: () {
                          ref
                              .read(virtualTownHallProvider.notifier)
                              .getEventsUsingCityId(cityId: "1");
                        }));
              },
              isFavVisible: true,
              onSuccess: (bool isFav, int? id) {
                ref
                    .read(virtualTownHallProvider.notifier)
                    .updateEventIsFav(isFav, id);
              },
              onFavClickCallback: () {
                ref
                    .read(virtualTownHallProvider.notifier)
                    .getVirtualTownHallDetails();
              },
            ),
          FeedbackCardWidget(
              height: 270.h,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: feedbackScreenPath, context: context);
              })
        ],
      ),
    );
  }

  Widget _buildClipper() {
    final imageUrl = ref.watch(virtualTownHallProvider).imageUrl;
    return Stack(
      children: [
        SizedBox(
          height: 250.h,
          child: CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 210.h,
            blurredBackground: true,
            isStaticImage: true,
            customWidget1: Positioned(
              left: 0.w,
              top: 20.h,
              child: Row(
                children: [
                  16.horizontalSpace,
                  IconButton(
                      onPressed: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                      icon: Icon(
                          size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                          color: Theme.of(context).primaryColor,
                          Icons.arrow_back)),
                  12.horizontalSpace,
                  textBoldPoppins(
                      color: Theme.of(context).textTheme.labelLarge?.color,
                      fontSize: 19,
                      text: AppLocalizations.of(context).virtual_town_hall),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 100.h,
          left: 0.w,
          right: 0.w,
          child: Card(
            elevation: 8,
            shape: CircleBorder(),
            child: Container(
              height: 120.h,
              width: 70.w,
              padding: EdgeInsets.all(25.w),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: (imageUrl != null)
                  ? ImageUtil.loadNetworkImage(
                      onImageTap: () => ref
                          .read(navigationProvider)
                          .navigateUsingPath(
                              params: FullImageScreenParams(
                                  imageUrL: imageUrl ?? '', sourceId: 1),
                              path: fullImageScreenPath,
                              context: context),
                      imageUrl: imageUrl ?? '',
                      sourceId: 1,
                      fit: BoxFit.contain,
                      svgErrorImagePath:
                          imagePath['virtual_town_hall_map_image']!,
                      context: context,
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTownHallDetailsUi(VirtualTownHallState state) {
    return Padding(
      padding: EdgeInsets.only(left :12.w, right: 12.w, bottom: 12.w, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 6.w),
            child: textBoldPoppins(
                text:
                    "${AppLocalizations.of(context).district} ${state.cityName}" ??
                        "",
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16),
          ),
          15.verticalSpace,
          TownHallMapWidget(
            address: state.address ?? "",
            websiteText: AppLocalizations.of(context).visit_website,
            websiteUrl: state.websiteUrl ?? "https://www.google.com/",
            latitude: state.latitude ?? EventLatLong.kusel.latitude,
            longitude: state.longitude ?? EventLatLong.kusel.longitude,
            phoneNumber: state.phoneNumber ?? '',
            email: state.email ?? '',
            calendarText: AppLocalizations.of(context).open,
            openUntil: state.openUntil ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList({required List<OnlineService> onlineServicesList}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: onlineServicesList.length,
            itemBuilder: (context, index) {
              final item = onlineServicesList[index];
              return NetworkImageTextServiceCard(
                  onTap: () => ref.read(navigationProvider).navigateUsingPath(
                      path: webViewPagePath,
                      params: WebViewParams(
                          url:
                              item.linkUrl ?? "https://www.landkreis-kusel.de"),
                      context: context),
                  imageUrl: item.iconUrl!,
                  text: item.title ?? '',
                  description: item.description ?? '');
            },
          ),
        ],
      ),
    );
  }

  Widget _customPageViewer({required List<Municipality> municipalityList}) {
    VirtualTownHallState state = ref.watch(virtualTownHallProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
      child: Column(
        children: [
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    textRegularPoppins(
                        text: AppLocalizations.of(context)
                            .associated_municipalities,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    12.horizontalSpace,
                    ImageUtil.loadSvgImage(
                      imageUrl: imagePath['arrow_icon'] ?? "",
                      context: context,
                      height: 10.h,
                      width: 16.w,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      municipalityList.length,
                      (index) => InkWell(
                        onTap: () {},
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
                            // if (index != state.highlightsList.length - 1)
                            if (index != municipalityList.length - 1)
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
            height: 280.h,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: PageView.builder(
                controller: PageController(
                    viewportFraction:
                        317.w / MediaQuery.of(context).size.width),
                scrollDirection: Axis.horizontal,
                padEnds: false,
                itemCount: municipalityList.length,
                itemBuilder: (context, index) {
                  final municipality = municipalityList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.h.w),
                    child: HighlightsCard(
                      imageUrl:
                          municipality.mapImage ?? "https://picsum.photos/200",
                      heading: municipality.name ?? "",
                      description: AppLocalizations.of(context).municipality,
                      errorImagePath: imagePath['kusel_map_image'],
                      onPress: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: municipalDetailScreenPath,
                              params: MunicipalDetailScreenParams(
                                  municipalId: municipality.id!.toString(),
                                  onFavUpdate: (isFav, id, isMunicipal) {
                                    _updateList(isFav, id ?? 0);
                                  }),
                            );
                      },
                      isFavourite: municipality.isFavorite ?? false,
                      onFavouriteIconClick: () {
                        ref
                            .watch(favouriteCitiesNotifier.notifier)
                            .toggleFavorite(
                              isFavourite: municipality.isFavorite,
                              id: municipality.id,
                              success: ({required bool isFavorite}) {
                                _updateList(isFavorite, municipality.id ?? 0);
                              },
                              error: ({required String message}) {
                                showErrorToast(
                                    message: message, context: context);
                              },
                            );
                      },
                      isFavouriteVisible: true,
                      sourceId: 1,
                      imageFit: BoxFit.contain,
                    ),
                  );
                },
                onPageChanged: (index) {
                  ref
                      .read(virtualTownHallProvider.notifier)
                      .updateCardIndex(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateList(bool isFav, int cityId) {
    ref
        .read(virtualTownHallProvider.notifier)
        .setIsFavoriteMunicipality(isFav, cityId);
  }
}
