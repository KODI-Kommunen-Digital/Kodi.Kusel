import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/all_municipality/all_municipality_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_params.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/custom_progress_bar.dart';
import '../../common_widgets/custom_shimmer_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../providers/favourite_cities_notifier.dart';

class MeinOrtScreen extends ConsumerStatefulWidget {
  const MeinOrtScreen({super.key});

  @override
  ConsumerState<MeinOrtScreen> createState() => _MeinOrtScreenState();
}

class _MeinOrtScreenState extends ConsumerState<MeinOrtScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(meinOrtProvider.notifier).getMeinOrtDetails();
      ref.read(meinOrtProvider.notifier).isUserLoggedIn();
    });
    MatomoService.trackMeinOrtScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(meinOrtProvider.select((state) => state.isLoading));

    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(meinOrtProvider.notifier).getMeinOrtDetails();
          ref.read(meinOrtProvider.notifier).isUserLoggedIn();
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
    final state = ref.read(meinOrtProvider);
    final isLoading = ref.watch(meinOrtProvider).isLoading;
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 155.h,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                _buildClipper(),
                Positioned(top: 70, child: _buildInfoContainer(context)),
              ],
            ),
          ),
          _customPageViewer(municipalityList: state.municipalityList ?? []),
          ListView.builder(
              itemCount: state.municipalityList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final municipality = state.municipalityList[index];
                return cityListWidget(
                  municipality.topFiveCities ?? [],
                  municipality.name ?? '',
                  5,
                  AppLocalizations.of(context).show_all_places,
                  imagePath['calendar'] ?? "",
                  isLoading,
                  0,
                  0,
                  municipality.id ?? 0,
                  () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: allMunicipalityScreenPath,
                        context: context,
                        params: MunicipalityScreenParams(
                            municipalityId: municipality.id ?? 0,
                            onFavUpdate: (isFav, cityId) {
                              _updateCityList(
                                  isFav, cityId, municipality.id ?? 0);
                            }));
                  },
                );
              }),
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
    return Stack(
      children: [
        SizedBox(
          height: 155.h,
          child: CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 120.h,
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
                      fontSize: 18,
                      text: AppLocalizations.of(context).my_town),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 70, child: _buildInfoContainer(context)),
      ],
    );
  }

  Widget _buildInfoContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 24.h * 2 + 12.h,
          padding: EdgeInsets.all(8.h), // Uniform padding
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: textRegularPoppins(
            text: AppLocalizations.of(context).mein_ort_display_message,
            textOverflow: TextOverflow.visible,
            fontSize: 13,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Widget _customPageViewer({required List<Municipality> municipalityList}) {
    MeinOrtState state = ref.watch(meinOrtProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
      child: Column(
        children: [
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 2.w),
                      child: textRegularPoppins(
                          text: AppLocalizations.of(context)
                              .associated_municipalities,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    12.horizontalSpace,
                    ImageUtil.loadSvgImage(
                        imageUrl: imagePath['arrow_icon'] ?? "",
                        height: 10.h,
                        width: 16.w,
                        context: context)
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
                      errorImagePath: imagePath['kusel_map_image'],
                      onPress: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: municipalDetailScreenPath,
                              params: MunicipalDetailScreenParams(
                                  municipalId: municipality.id.toString(),
                                  onFavUpdate: (isFav, id, isMunicipal) {
                                    if (isMunicipal ?? false) {
                                      _updateMunicipalityList(isFav, id ?? 0);
                                    } else {
                                      _updateCityList(
                                          isFav, id ?? 0, municipality.id ?? 0);
                                    }
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
                                _updateMunicipalityList(
                                    isFavorite, municipality.id ?? 0);
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
                      description: '',
                    ),
                  );
                },
                onPageChanged: (index) {
                  ref.read(meinOrtProvider.notifier).updateCardIndex(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cityListWidget(
      List<City> eventsList,
      String heading,
      int maxListLimit,
      String buttonText,
      String buttonIconPath,
      bool isLoading,
      double? latitude,
      double? longitude,
      int? municipalityId,
      void Function() onPress) {
    if (isLoading) {
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
              child: CustomShimmerWidget.rectangular(
                  height: 15.h,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)))),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (_, index) {
                return eventCartShimmerEffect();
              }),
        ],
      );
    } else if (eventsList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 16.w, 0, 0),
            child: InkWell(
              onTap: onPress,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: heading,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  12.horizontalSpace,
                  ImageUtil.loadSvgImage(
                    imageUrl: imagePath['arrow_icon'] ?? "",
                    context: context,
                    height: 10.h,
                    width: 16.w,
                  )
                ],
              ),
            ),
          ),
          15.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eventsList.length > maxListLimit
                ? maxListLimit
                : eventsList.length,
            itemBuilder: (context, index) {
              final city = eventsList[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                child: ImageTextCardWidget(
                  text: city.name,
                  imageUrl: city.image,
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: ortDetailScreenPath,
                        context: context,
                        params: OrtDetailScreenParams(
                            ortId: city.id!.toString(),
                            onFavSuccess: (isFav, id) {
                              _updateCityList(
                                  isFav ?? false, id ?? 0, municipalityId ?? 0);
                            }));
                  },
                  isFavourite: city.isFavorite,
                  isFavouriteVisible: true,
                  onFavoriteTap: () {
                    ref.watch(favouriteCitiesNotifier.notifier).toggleFavorite(
                          isFavourite: city.isFavorite,
                          id: city.id,
                          success: ({required bool isFavorite}) {
                            _updateCityList(
                                isFavorite, city.id!, municipalityId ?? 0);
                          },
                          error: ({required String message}) {
                            showErrorToast(message: message, context: context);
                          },
                        );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: CustomButton(
              onPressed: onPress,
              text: buttonText,
            ),
          ),
          5.verticalSpace
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: textRegularPoppins(
                text: heading,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          16.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).no_data,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          20.verticalSpace
        ],
      ),
    );
  }

  _updateCityList(bool isFav, int cityId, int municipalityId) {
    ref
        .read(meinOrtProvider.notifier)
        .setIsFavoriteCity(isFav, cityId, municipalityId);
  }

  _updateMunicipalityList(bool isFav, int cityId) {
    ref.read(meinOrtProvider.notifier).setIsFavoriteMunicipality(isFav, cityId);
  }
}
