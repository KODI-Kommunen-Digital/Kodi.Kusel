import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/digifit/digifit_options_card.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/offline_router.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_controller.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../common_widgets/digifit/digifit_map_card.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/toast_message.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import '../digifit_overview/params/digifit_overview_params.dart';

class DigifitInformationScreen extends ConsumerStatefulWidget {
  const DigifitInformationScreen({super.key});

  @override
  ConsumerState<DigifitInformationScreen> createState() =>
      _DigifitStartScreenState();
}

class _DigifitStartScreenState extends ConsumerState<DigifitInformationScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(digifitInformationControllerProvider.notifier)
          .fetchDigifitInformation();
    });
    MatomoService.trackDigifitOverviewViewed();
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
                .read(digifitInformationControllerProvider.notifier)
                .fetchDigifitInformation();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              children: [
                // Background
                CommonBackgroundClipperWidget(
                  height: 200.h,
                  clipperType: UpstreamWaveClipper(),
                  imageUrl: imagePath['home_screen_background'] ?? '',
                  isStaticImage: true,
                ),

                Positioned(
                  top: 30.h,
                  left: 10.r,
                  child: _buildHeadingArrowSection(),
                ),

                // fav icon
                // Visibility(
                //   visible: ref.watch(networkStatusProvider).isNetworkAvailable,
                //   child: Positioned(
                //     top: 30.h,
                //     right: 10.r,
                //     child: GestureDetector(
                //       onTap: () {
                //         ref.read(navigationProvider).navigateUsingPath(
                //             path: digifitFavScreenPath, context: context);
                //       },
                //       child: Container(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 8.w, vertical: 8.h),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Theme.of(context).colorScheme.secondary),
                //         child: Icon(
                //           Icons.favorite_border,
                //           color: Theme.of(context).cardColor,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDigifitOverviewScreenUi(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    ).loaderDialog(
        context, ref.read(digifitInformationControllerProvider).isLoading);
  }

  _buildHeadingArrowSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              Icons.arrow_back,
              color: Theme.of(context).primaryColor),
        ),
        16.horizontalSpace,
        textBoldPoppins(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 24,
          text: AppLocalizations.of(context).digifit_parcours,
        ),
      ],
    );
  }

  _buildDigifitOverviewScreenUi() {
    var state = ref.watch(digifitInformationControllerProvider);
    final parcoursList = state.digifitInformationDataModel?.parcours ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          DigifitStatusWidget(
            pointsValue:
                state.digifitInformationDataModel?.userStats?.points ?? 0,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue:
                state.digifitInformationDataModel?.userStats?.trophies ?? 0,
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
                    .read(digifitInformationControllerProvider.notifier)
                    .getSlug(barcode, (String slugUrl) {
                  final isNetwork =
                      ref.read(networkStatusProvider).isNetworkAvailable;

                  if (isNetwork) {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: digifitExerciseDetailScreenPath,
                        context: context,
                        params: DigifitExerciseDetailsParams(
                            station: DigifitInformationStationModel(id: null),
                            slug: slugUrl,
                            onFavCallBack: () {
                              ref
                                  .read(digifitInformationControllerProvider
                                      .notifier)
                                  .fetchDigifitInformation();
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
                                  .read(digifitInformationControllerProvider
                                      .notifier)
                                  .fetchDigifitInformation();
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
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: DigifitOptionsCard(
                  cardText: AppLocalizations.of(context).brain_teasers,
                  svgImageUrl: imagePath['brain_teaser_icon'] ?? '',
                  onCardTap: () {
                    final value =
                        ref.read(networkStatusProvider).isNetworkAvailable;
                    if (value) {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: brainTeasersGameListScreenPath,
                          context: context);
                    }
                  },
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: DigifitOptionsCard(
                  cardText: AppLocalizations.of(context).points_and_trophy,
                  svgImageUrl: imagePath['trophy_icon'] ?? '',
                  onCardTap: () {
                    final value =
                        ref.read(networkStatusProvider).isNetworkAvailable;
                    if (value) {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: digifitTrophiesScreenPath, context: context);
                    }
                  },
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ...parcoursList.map(
            (parcours) => _buildCourseDetailSection(
              parcoursModel: parcours,
            ),
          ),
        ],
      ),
    );
  }

  _buildCourseDetailSection(
      {bool? isButtonVisible,
      required DigifitInformationParcoursModel parcoursModel}) {
    final sourceId = ref
            .read(digifitInformationControllerProvider)
            .digifitInformationDataModel
            ?.sourceId ??
        0;

    return Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: textSemiBoldPoppins(
                  text: parcoursModel.name ?? '',
                  fontSize: 18,
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
        10.verticalSpace,
        DigifitMapCard(
          imagePath: parcoursModel.mapImageUrl ?? '',
          sourceId: sourceId,
          onImageTap: () {
            bool value = ref.read(networkStatusProvider).isNetworkAvailable;
            if (value) {
              ref.read(navigationProvider).navigateUsingPath(
                  path: digifitOverViewScreenPath,
                  context: context,
                  params: DigifitOverviewScreenParams(
                      parcoursModel: parcoursModel,
                      onFavChange: () {
                        ref
                            .read(digifitInformationControllerProvider.notifier)
                            .fetchDigifitInformation();
                      }));
            } else {
              ref.read(navigationProvider).navigateUsingPath(
                  path: offlineDigifitOverViewScreenPath,
                  context: context,
                  params: DigifitOverviewScreenParams(
                      parcoursModel: parcoursModel,
                      onFavChange: () {
                        ref
                            .read(digifitInformationControllerProvider.notifier)
                            .fetchDigifitInformation();
                      }));
            }
          },
        ),
        2.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: parcoursModel.stations?.length ?? 0,
            itemBuilder: (context, index) {
              final station = parcoursModel.stations![index];
              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: DigifitTextImageCard(
                  imageUrl: station.machineImageUrl ?? '',
                  heading: station.muscleGroups ?? '',
                  title: station.name ?? '',
                  isFavouriteVisible:
                      ref.read(networkStatusProvider).isNetworkAvailable,
                  isFavorite: station.isFavorite ?? false,
                  sourceId: sourceId,
                  onCardTap: () {
                    final value =
                        ref.read(networkStatusProvider).isNetworkAvailable;
                    if (value) {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: digifitExerciseDetailScreenPath,
                          context: context,
                          params: DigifitExerciseDetailsParams(
                              station: station,
                              locationId: parcoursModel.locationId ?? 0,
                              onFavCallBack: () {
                                ref
                                    .read(digifitInformationControllerProvider
                                        .notifier)
                                    .fetchDigifitInformation();
                              }));
                    } else {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: offlineDigifitExerciseDetailScreenPath,
                          context: context,
                          params: DigifitExerciseDetailsParams(
                              station: station,
                              locationId: parcoursModel.locationId ?? 0,
                              onFavCallBack: () {
                                ref
                                    .read(digifitInformationControllerProvider
                                        .notifier)
                                    .fetchDigifitInformation();
                              }));
                    }
                  },
                  isCompleted: station.isCompleted,
                  onFavorite: () {
                    DigifitEquipmentFavParams digifitEquipmentFavParams =
                        DigifitEquipmentFavParams(
                            isFavorite: station.isFavorite != null
                                ? !station.isFavorite!
                                : false,
                            equipmentId: station.id ?? 0,
                            locationId: parcoursModel.locationId ?? 0);
                    ref
                        .read(digifitInformationControllerProvider.notifier)
                        .onFavTap(
                            digifitEquipmentFavParams:
                                digifitEquipmentFavParams);
                  },
                ),
              );
            }),
        10.verticalSpace,
        Visibility(
          visible: isButtonVisible ?? true,
          child: CustomButton(
            height: 48,
            textSize: 16,
              onPressed: () {
                final value =
                    ref.read(networkStatusProvider).isNetworkAvailable;

                if (value) {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: digifitOverViewScreenPath,
                      context: context,
                      params: DigifitOverviewScreenParams(
                          parcoursModel: parcoursModel,
                          onFavChange: () {
                            ref
                                .read(digifitInformationControllerProvider
                                    .notifier)
                                .fetchDigifitInformation();
                          }));
                } else {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: offlineDigifitOverViewScreenPath,
                      context: context,
                      params: DigifitOverviewScreenParams(
                          parcoursModel: parcoursModel,
                          onFavChange: () {
                            ref
                                .read(digifitInformationControllerProvider
                                    .notifier)
                                .fetchDigifitInformation();
                          }));
                }
              },
              text: AppLocalizations.of(context).show_course),
        ),
        10.verticalSpace
      ],
    );
  }
}
