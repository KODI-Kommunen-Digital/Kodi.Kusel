import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/offline_router.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/params/digifit_overview_params.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../app_router.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/downstream_wave_clipper.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'digifit_overview_controller.dart';

class DigifitOverviewScreen extends ConsumerStatefulWidget {
  final DigifitOverviewScreenParams digifitOverviewScreenParams;

  const DigifitOverviewScreen(
      {super.key, required this.digifitOverviewScreenParams});

  @override
  ConsumerState<DigifitOverviewScreen> createState() =>
      _DigifitOverviewScreenState();
}

class _DigifitOverviewScreenState extends ConsumerState<DigifitOverviewScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(digifitOverviewScreenControllerProvider.notifier)
          .fetchDigifitOverview(
              widget.digifitOverviewScreenParams.parcoursModel.locationId ?? 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(digifitOverviewScreenControllerProvider.notifier)
                .fetchDigifitOverview(widget
                        .digifitOverviewScreenParams.parcoursModel.locationId ??
                    0);
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClipper(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDigifitTrophiesScreenUi(),
                    30.verticalSpace,
                    FeedbackCardWidget(
                      height: 270.h,
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: feedbackScreenPath, context: context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).loaderDialog(
        context, ref.read(digifitOverviewScreenControllerProvider).isLoading);
  }

  Widget _buildClipper() {
    return Stack(
      children: [
        SizedBox(
          height: 320.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['digifit_overview_image'] ?? "",
            height: 280.h,
            blurredBackground: false,
            isBackArrowEnabled: true,
            isStaticImage: true,
          ),
        ),
        Positioned(
          top: 175.h,
          left: 0.w,
          right: 0.w,
          child: Container(
            height: 120.h,
            width: 70.w,
            padding: EdgeInsets.all(25.w),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ImageUtil.loadSvgImage(
              imageUrl: imagePath['dumble_icon']!,
              fit: BoxFit.contain,
              height: 40.h,
              width: 40.w,
              context: context,
            ),
          ),
        )
      ],
    );
  }

  _buildDigifitTrophiesScreenUi() {
    var digifitOverview = ref
        .watch(digifitOverviewScreenControllerProvider)
        .digifitOverviewDataModel;

    var availableStation = digifitOverview?.parcours?.availableStation ?? [];

    var completedStation = digifitOverview?.parcours?.completedStation ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: textBoldPoppins(
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontSize: 24,
              textAlign: TextAlign.left,
              text: digifitOverview?.parcours?.name ?? "",
            ),
          ),
          18.verticalSpace,
          DigifitStatusWidget(
            pointsValue: digifitOverview?.userStats?.points ?? 0,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue: digifitOverview?.userStats?.trophies ?? 0,
            trophiesText: AppLocalizations.of(context).trophies,
            onButtonTap: () async {
              String path = digifitQRScannerScreenPath;

              if (!ref.read(networkStatusProvider).isNetworkAvailable) {
                path = offlineDigifitQRScannerScreenPath;
              }
              final barcode = await ref
                  .read(navigationProvider)
                  .navigateUsingPath(path: path, context: context);

              if (barcode != null) {
                ref
                    .read(digifitOverviewScreenControllerProvider.notifier)
                    .getSlug(barcode, (String slugUrl) {
                  final value =
                      ref.read(networkStatusProvider).isNetworkAvailable;

                  if (value) {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: digifitExerciseDetailScreenPath,
                        context: context,
                        params: DigifitExerciseDetailsParams(
                            station: DigifitInformationStationModel(id: null),
                            locationId: widget.digifitOverviewScreenParams
                                    .parcoursModel.locationId ??
                                0,
                            slug: slugUrl,
                            onFavCallBack: () {
                              ref
                                  .read(digifitOverviewScreenControllerProvider
                                      .notifier)
                                  .fetchDigifitOverview(widget
                                      .digifitOverviewScreenParams
                                      .parcoursModel
                                      .locationId!);
                            }));
                  } else {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: offlineDigifitExerciseDetailScreenPath,
                        context: context,
                        params: DigifitExerciseDetailsParams(
                            station: DigifitInformationStationModel(id: null),
                            slug: slugUrl,
                            onFavCallBack: () {
                              ref
                                  .read(digifitOverviewScreenControllerProvider
                                      .notifier)
                                  .fetchDigifitOverview(widget
                                      .digifitOverviewScreenParams
                                      .parcoursModel
                                      .locationId!);
                            }));
                  }
                }, () {
                  showErrorToast(
                      message:
                          AppLocalizations.of(context).something_went_wrong,
                      context: context);
                });
              }
            },
          ),
          18.verticalSpace,
          if (availableStation.isNotEmpty)
            _buildAvailableCourseDetailSection(
              title: AppLocalizations.of(context).digifit_open_exercise,
              stationList: availableStation,
            ),
          18.verticalSpace,
          if (completedStation.isNotEmpty)
            _buildCompleteCourseDetailSection(
                title: AppLocalizations.of(context).digifit_completed_exercise,
                stationList: completedStation),
        ],
      ),
    );
  }

  _buildAvailableCourseDetailSection({
    required String title,
    required List<DigifitOverviewStationModel> stationList,
  }) {
    final sourceId = ref
            .read(digifitOverviewScreenControllerProvider)
            .digifitOverviewDataModel
            ?.sourceId ??
        0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        18.verticalSpace,
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: textRegularPoppins(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        10.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: stationList.length,
            itemBuilder: (context, index) {
              var station = stationList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                  onCardTap: () {
                    final value =
                        ref.read(networkStatusProvider).isNetworkAvailable;
                    if (value) {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: digifitExerciseDetailScreenPath,
                          context: context,
                          params: DigifitExerciseDetailsParams(
                              station: DigifitInformationStationModel(
                                id: station.id,
                                name: station.name,
                                isFavorite: station.isFavorite,
                                muscleGroups: station.muscleGroups,
                              ),
                              locationId: widget.digifitOverviewScreenParams
                                      .parcoursModel.locationId ??
                                  0,
                              onFavCallBack: () {
                                ref
                                    .read(
                                        digifitOverviewScreenControllerProvider
                                            .notifier)
                                    .fetchDigifitOverview(widget
                                            .digifitOverviewScreenParams
                                            .parcoursModel
                                            .locationId ??
                                        0);
                              }));
                    } else {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: offlineDigifitExerciseDetailScreenPath,
                          context: context,
                          params: DigifitExerciseDetailsParams(
                              station: DigifitInformationStationModel(
                                id: station.id,
                                name: station.name,
                                isFavorite: station.isFavorite,
                                muscleGroups: station.muscleGroups,
                              ),
                              locationId: widget.digifitOverviewScreenParams
                                      .parcoursModel.locationId ??
                                  0,
                              onFavCallBack: () {
                                ref
                                    .read(
                                        digifitOverviewScreenControllerProvider
                                            .notifier)
                                    .fetchDigifitOverview(widget
                                            .digifitOverviewScreenParams
                                            .parcoursModel
                                            .locationId ??
                                        0);
                              }));
                    }
                  },
                  imageUrl: station.machineImageUrl ?? '',
                  heading: station.muscleGroups ?? '',
                  title: station.name ?? '',
                  isFavouriteVisible:
                      ref.read(networkStatusProvider).isNetworkAvailable,
                  isFavorite: station.isFavorite ?? false,
                  sourceId: sourceId,
                  isCompleted: station.isCompleted,
                  onFavorite: () async {
                    DigifitEquipmentFavParams params =
                        DigifitEquipmentFavParams(
                            isFavorite: !station.isFavorite!,
                            equipmentId: station.id ?? 0,
                            locationId: widget.digifitOverviewScreenParams
                                .parcoursModel.locationId!);

                    await ref
                        .read(digifitOverviewScreenControllerProvider.notifier)
                        .availableStationOnFavTap(
                            digifitEquipmentFavParams: params);
                    if (widget.digifitOverviewScreenParams.onFavChange !=
                        null) {
                      widget.digifitOverviewScreenParams.onFavChange!();
                    }
                  },
                ),
              );
            }),
        10.verticalSpace,
      ],
    );
  }

  _buildCompleteCourseDetailSection({
    required String title,
    required List<DigifitOverviewStationModel> stationList,
  }) {
    return Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: textRegularPoppins(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            12.horizontalSpace,
          ],
        ),
        10.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: stationList.length,
            itemBuilder: (context, index) {
              var station = stationList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                  onCardTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: digifitExerciseDetailScreenPath,
                        context: context,
                        params: DigifitExerciseDetailsParams(
                            station: DigifitInformationStationModel(
                              id: station.id,
                              name: station.name,
                              isFavorite: station.isFavorite,
                              muscleGroups: station.muscleGroups,
                            ),
                            locationId: widget.digifitOverviewScreenParams
                                    .parcoursModel.locationId ??
                                0,
                            onFavCallBack: () {
                              ref
                                  .read(digifitOverviewScreenControllerProvider
                                      .notifier)
                                  .fetchDigifitOverview(widget
                                          .digifitOverviewScreenParams
                                          .parcoursModel
                                          .locationId ??
                                      0);

                              widget.digifitOverviewScreenParams.onFavChange
                                  ?.call();
                            }));
                  },
                  imageUrl: station.machineImageUrl ?? '',
                  heading: station.muscleGroups ?? '',
                  title: station.name ?? '',
                  isFavouriteVisible:
                      ref.read(networkStatusProvider).isNetworkAvailable,
                  isFavorite: station.isFavorite ?? false,
                  sourceId: 1,
                  isCompleted: station.isCompleted,
                  onFavorite: () async {
                    DigifitEquipmentFavParams params =
                        DigifitEquipmentFavParams(
                            isFavorite: !station.isFavorite!,
                            equipmentId: station.id ?? 0,
                            locationId: widget.digifitOverviewScreenParams
                                .parcoursModel.locationId!);

                    await ref
                        .read(digifitOverviewScreenControllerProvider.notifier)
                        .completedStationOnFavTap(
                            digifitEquipmentFavParams: params);

                    if (widget.digifitOverviewScreenParams.onFavChange !=
                        null) {
                      widget.digifitOverviewScreenParams.onFavChange!();
                    }
                  },
                ),
              );
            }),
        10.verticalSpace,
      ],
    );
  }
}
