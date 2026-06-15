import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_bottom_nav_card_.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/custom_progress_bar.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_location_widget.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_params.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/network_image_text_service_card.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/web_view_page.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favourite_cities_notifier.dart';
import '../all_municipality/all_municipality_provider.dart';
import '../full_image/full_image_screen.dart';
import 'municipal_detail_controller.dart';

class MunicipalDetailScreen extends ConsumerStatefulWidget {
  MunicipalDetailScreenParams municipalDetailScreenParams;

  MunicipalDetailScreen({super.key, required this.municipalDetailScreenParams});

  @override
  ConsumerState<MunicipalDetailScreen> createState() =>
      _CityDetailScreenState();
}

class _CityDetailScreenState extends ConsumerState<MunicipalDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final id = widget.municipalDetailScreenParams.municipalId;

      ref
          .read(municipalDetailControllerProvider.notifier)
          .getMunicipalPartyDetailUsingId(id: id);
      ref
          .read(municipalDetailControllerProvider.notifier)
          .getEventsUsingCityId(municipalId: id);
      ref
          .read(municipalDetailControllerProvider.notifier)
          .getNewsUsingCityId(municipalId: id);

      ref.read(municipalDetailControllerProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        municipalDetailControllerProvider.select((state) => state.isLoading));
    final state = ref.read(municipalDetailControllerProvider);

    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final id = widget.municipalDetailScreenParams.municipalId;

          ref
              .read(municipalDetailControllerProvider.notifier)
              .getMunicipalPartyDetailUsingId(id: id);
          ref
              .read(municipalDetailControllerProvider.notifier)
              .getEventsUsingCityId(municipalId: id);
          ref
              .read(municipalDetailControllerProvider.notifier)
              .getNewsUsingCityId(municipalId: id);

          ref.read(municipalDetailControllerProvider.notifier).isUserLoggedIn();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: _buildBody(context)),
            if (isLoading) CustomProgressBar(),
            Positioned(
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  },
                  isFavVisible: true,
                  isFav:
                      state.municipalPartyDetailDataModel?.isFavorite ?? false,
                  onFavChange: () {
                    ref.watch(favouriteCitiesNotifier.notifier).toggleFavorite(
                          isFavourite:
                              state.municipalPartyDetailDataModel?.isFavorite,
                          id: state.municipalPartyDetailDataModel?.id,
                          success: ({required bool isFavorite}) {
                            _updateMunicipalFavStatus(isFavorite,
                                state.municipalPartyDetailDataModel?.id ?? 0);

                            if (widget
                                    .municipalDetailScreenParams.onFavUpdate !=
                                null) {
                              widget.municipalDetailScreenParams.onFavUpdate!(
                                  isFavorite,
                                  state.municipalPartyDetailDataModel?.id ?? 0,
                                  true);
                            }
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
    ));
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(municipalDetailControllerProvider);
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildClipper(),
          _buildDescription(context),
          12.verticalSpace,
          _buildServicesList(context),
          12.verticalSpace,
          _buildLocationCard(),
          25.verticalSpace,
          _buildPlacesOfTheCommunity(context),
          18.verticalSpace,
          if (ref.watch(municipalDetailControllerProvider).eventList.isNotEmpty)
            EventsListSectionWidget(
              context: context,
              eventsList: state.eventList,
              heading: AppLocalizations.of(context).event_text,
              maxListLimit: 5,
              buttonText: AppLocalizations.of(context).all_events,
              buttonIconPath: imagePath['calendar'] ?? "",
              isLoading: false,
              showEventLoading: state.showEventLoading,
              onButtonTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: int.parse(
                            widget.municipalDetailScreenParams.municipalId),
                        listHeading: AppLocalizations.of(context).events,
                        categoryId: ListingCategoryId.event.eventId,
                        onFavChange: () {
                          ref
                              .read(municipalDetailControllerProvider.notifier)
                              .getEventsUsingCityId(
                                  municipalId: widget
                                      .municipalDetailScreenParams.municipalId);
                        }));
              },
              onHeadingTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: int.parse(
                            widget.municipalDetailScreenParams.municipalId),
                        listHeading: AppLocalizations.of(context).events,
                        categoryId: ListingCategoryId.event.eventId,
                        onFavChange: () {
                          ref
                              .read(municipalDetailControllerProvider.notifier)
                              .getEventsUsingCityId(
                                  municipalId: widget
                                      .municipalDetailScreenParams.municipalId);
                        }));
              },
              isFavVisible: true,
              onSuccess: (bool isFav, int? id) {
                ref
                    .read(municipalDetailControllerProvider.notifier)
                    .updateEventIsFav(isFav, id);
              },
              onFavClickCallback: () {
                final id = widget.municipalDetailScreenParams.municipalId;
                ref
                    .read(municipalDetailControllerProvider.notifier)
                    .getEventsUsingCityId(municipalId: id);
              },
            ),
          12.verticalSpace,
          if (ref.watch(municipalDetailControllerProvider).newsList.isNotEmpty)
            EventsListSectionWidget(
              boxFit: BoxFit.cover,
              context: context,
              eventsList: state.newsList,
              heading: AppLocalizations.of(context).news,
              maxListLimit: 5,
              buttonText: AppLocalizations.of(context).all_news,
              buttonIconPath: imagePath['news_icon'] ?? "",
              isLoading: false,
              showEventLoading: state.showNewsLoading,
              onButtonTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: int.parse(
                            widget.municipalDetailScreenParams.municipalId),
                        listHeading: AppLocalizations.of(context).news,
                        categoryId: ListingCategoryId.news.eventId,
                        onFavChange: () {
                          ref
                              .read(municipalDetailControllerProvider.notifier)
                              .getNewsUsingCityId(
                                  municipalId: widget
                                      .municipalDetailScreenParams.municipalId);
                        }));
              },
              onHeadingTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: int.parse(
                            widget.municipalDetailScreenParams.municipalId),
                        listHeading: AppLocalizations.of(context).news,
                        categoryId: ListingCategoryId.news.eventId,
                        onFavChange: () {
                          ref
                              .read(municipalDetailControllerProvider.notifier)
                              .getNewsUsingCityId(
                                  municipalId: widget
                                      .municipalDetailScreenParams.municipalId);
                        }));
              },
              isFavVisible: true,
              onSuccess: (bool isFav, int? id) {
                ref
                    .read(municipalDetailControllerProvider.notifier)
                    .updateNewsIsFav(isFav, id);
              },
              onFavClickCallback: () {
                final id = widget.municipalDetailScreenParams.municipalId;
                ref
                    .read(municipalDetailControllerProvider.notifier)
                    .getNewsUsingCityId(municipalId: id);
              },
            ),
          FeedbackCardWidget(
            height: 270.h,
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: feedbackScreenPath, context: context);
            },
          ),
        ],
      ),
    );
  }

  _buildClipper() {
    final state = ref.watch(municipalDetailControllerProvider);
    return Stack(
      children: [
        SizedBox(
          height: 250.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['city_background_image'] ?? "",
            height: 210.h,
            isBackArrowEnabled: true,
            isStaticImage: true,
          ),
        ),
        Positioned(
          top: 105.h,
          left: 0.w,
          right: 0.w,
          child: Card(
            elevation: 4,
            shape: CircleBorder(),
            child: Container(
              height: 110.h,
              width: 100.w,
              padding: EdgeInsets.all(26.w),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: (state.municipalPartyDetailDataModel?.image != null)
                  ? ImageUtil.loadNetworkImage(
                      memCacheWidth: 540,
                      memCacheHeight: 580,
                      imageUrl: state.municipalPartyDetailDataModel!.image!,
                      sourceId: 1,
                      fit: BoxFit.contain,
                      svgErrorImagePath: imagePath['crest']!,
                      context: context,
                      onImageTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: fullImageScreenPath,
                            params: FullImageScreenParams(
                                imageUrL:
                                    state.municipalPartyDetailDataModel!.image!,
                                sourceId: 1),
                            context: context);
                      },
                    )
                  : Center(
                      child:  CircularProgressIndicator()
                    ),
            ),
          ),
        )
      ],
    );
  }

  _buildDescription(context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(municipalDetailControllerProvider);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textBoldPoppins(
              text: state.municipalPartyDetailDataModel?.name ??
                  'Kusel-Altenglan',
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            16.verticalSpace,
            textRegularMontserrat(
                maxLines: 20,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                text: state.municipalPartyDetailDataModel?.description ??
                    "Die Verbandsgemeinde Kusel-Altenglan ist eine Gebietskörperschaft im Landkreis Kusel  in Rheinland-Pfalz. Sie ist zum 1. Januar 2018 aus dem freiwilligen Zusammenschluss der  Verbandsgemeinden Altenglan und Kusel entstanden. Ihr gehören die Stadt Kusel sowie 33 weitere Ortsgemeinden an, der Verwaltungssitz ist in Kusel."),
            32.verticalSpace,
            textBoldPoppins(
                text:
                    "${AppLocalizations.of(context).new_municipality} ${state.municipalPartyDetailDataModel?.name ?? ""} ",
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
            textOverflow: TextOverflow.visible)
          ],
        ),
      );
    });
  }

  _buildLocationCard() {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(municipalDetailControllerProvider);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CityDetailLocationWidget(
          phoneNumber:
              state.municipalPartyDetailDataModel?.phone ?? '+49 6381 424-0',
          webUrl: state.municipalPartyDetailDataModel?.websiteUrl ??
              'https://google.com',
          address: state.municipalPartyDetailDataModel?.address ??
              'Trierer Str. 49-51, 66869 Kusel',
          long: (state.municipalPartyDetailDataModel?.longitude != null)
              ? double.parse(state.municipalPartyDetailDataModel!.longitude!)
              : EventLatLong.kusel.longitude,
          lat: (state.municipalPartyDetailDataModel?.latitude != null)
              ? double.parse(state.municipalPartyDetailDataModel!.latitude!)
              : EventLatLong.kusel.latitude,
          websiteText: AppLocalizations.of(context).visit_website,
          calendarText:
              state.municipalPartyDetailDataModel?.openUntil ?? "16:00:00",
        ),
      );
    });
  }

  _buildPlacesOfTheCommunity(BuildContext context) {
    final municipalId = ref
            .read(municipalDetailControllerProvider)
            .municipalPartyDetailDataModel
            ?.id ??
        0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Baseline(
                  baseline: 16, // Adjust based on your text size
                  baselineType: TextBaseline.alphabetic,
                  child: textRegularPoppins(
                    text: AppLocalizations.of(context).places_of_the_community,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                10.horizontalSpace, // spacing between text and icon
                Baseline(
                  baseline: 16,
                  baselineType: TextBaseline.alphabetic,
                  child: ImageUtil.loadSvgImage(
                    imageUrl: imagePath['arrow_icon'] ?? "",
                    context: context,
                    height: 10.h,
                    width: 16.w,
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (ref
                          .read(municipalDetailControllerProvider)
                          .cityList
                          .length >
                      5)
                  ? 5
                  : ref.read(municipalDetailControllerProvider).cityList.length,
              itemBuilder: (context, index) {
                final item =
                    ref.read(municipalDetailControllerProvider).cityList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: ImageTextCardWidget(
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: ortDetailScreenPath,
                          context: context,
                          params: OrtDetailScreenParams(
                              ortId: item.id!.toString(),
                              onFavSuccess: (isFav, id) {
                                _updateCityList(isFav ?? false, id ?? 0);
                                if (widget.municipalDetailScreenParams
                                        .onFavUpdate !=
                                    null) {
                                  widget.municipalDetailScreenParams
                                          .onFavUpdate!(
                                      isFav ?? false, id ?? 0, false);
                                }
                              }));
                    },
                    imageUrl: item.image!,
                    text: item.name ?? '',
                    sourceId: 1,
                    isFavourite: item.isFavorite,
                    isFavouriteVisible: true,
                    onFavoriteTap: () {
                      ref
                          .watch(favouriteCitiesNotifier.notifier)
                          .toggleFavorite(
                            isFavourite: item.isFavorite,
                            id: item.id,
                            success: ({required bool isFavorite}) {
                              _updateCityList(isFavorite, item.id!);
                              if (widget.municipalDetailScreenParams
                                      .onFavUpdate !=
                                  null) {
                                widget.municipalDetailScreenParams.onFavUpdate!(
                                    isFavorite, item.id, false);
                              }
                            },
                            error: ({required String message}) {
                              showErrorToast(
                                  message: message, context: context);
                            },
                          );
                    },
                  ),
                );
              }),
          10.verticalSpace,
          CustomButton(
              onPressed: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: allMunicipalityScreenPath,
                    context: context,
                    params: MunicipalityScreenParams(
                        municipalityId: municipalId,
                        onFavUpdate: (isFav, cityId) {
                          _updateCityList(isFav, cityId);
                        }));
              },
              text: AppLocalizations.of(context).show_all_locations)
        ],
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(municipalDetailControllerProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.municipalPartyDetailDataModel?.onlineServices
                        ?.length ??
                    0,
                itemBuilder: (context, index) {
                  if (state.municipalPartyDetailDataModel?.onlineServices !=
                      null) {
                    final item = state
                        .municipalPartyDetailDataModel!.onlineServices![index];
                    return NetworkImageTextServiceCard(
                        onTap: () => ref
                            .read(navigationProvider)
                            .navigateUsingPath(
                                path: webViewPagePath,
                                params: WebViewParams(
                                    url: item.linkUrl ??
                                        "https://www.landkreis-kusel.de"),
                                context: context),
                        imageUrl: item.iconUrl!, //??item.iconUrl
                        text: item.title ?? '',
                        description: item.description ?? '');
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _customTextIconCard(
  //     {required Function() onTap,
  //     required String imageUrl,
  //     required String text,
  //     String? description}) {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.r),
  //     ),
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Container(
  //         padding:
  //             EdgeInsets.only(left: 2.w, right: 14.w, top: 20.h, bottom: 20.h),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).canvasColor,
  //             borderRadius: BorderRadius.circular(15.r)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             20.horizontalSpace,
  //             Expanded(
  //               flex: 3,
  //               child: ImageUtil.loadNetworkImage(
  //                 // onImageTap: () {
  //                 //   ref.read(navigationProvider).navigateUsingPath(
  //                 //       path: fullImageScreenPath,
  //                 //       params: FullImageScreenParams(
  //                 //           imageUrL: imageUrl, sourceId: 3),
  //                 //       context: context);
  //                 // },
  //                 height: 35.h,
  //                 width: 35.w,
  //                 imageUrl: imageUrl,
  //                 context: context,
  //                 sourceId: 3,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             10.horizontalSpace,
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 26.0),
  //                   child: textBoldMontserrat(
  //                       text: text,
  //                       color: Theme.of(context).textTheme.bodyLarge?.color, textAlign: TextAlign.center, textOverflow: TextOverflow.visible),
  //                 ),
  //                 if (description != null)
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 24),
  //                     child: textRegularMontserrat(
  //                         text: description ?? '',
  //                         fontSize: 11,
  //                         textOverflow: TextOverflow.visible,
  //                         textAlign: TextAlign.start),
  //                   )
  //               ],
  //             ),
  //             Align(
  //                 alignment: Alignment.centerRight,
  //                 child: Image.asset(
  //                   imagePath["link_icon"] ?? '',
  //                   height: 40.h,
  //                   width: 40.w,
  //                 )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _updateCityList(bool isFav, int cityId) {
    ref
        .read(municipalDetailControllerProvider.notifier)
        .setIsFavoriteCity(isFav, cityId);
  }

  _updateMunicipalFavStatus(bool isFav, int id) {
    ref
        .read(municipalDetailControllerProvider.notifier)
        .setIsFavoriteMunicipal(isFav);
    // ref.read(meinOrtProvider.notifier).setIsFavoriteCity(isFav, id);
  }
}
