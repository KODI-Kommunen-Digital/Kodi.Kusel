import 'dart:async';

import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/offline_router.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/enum/digifit_exercise_timer_state.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/digifit_video_player_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../app_router.dart';
import '../../../common_widgets/arrow_back_widget.dart';
import '../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../common_widgets/common_html_widget.dart';
import '../../../common_widgets/custom_button_widget.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/toast_message.dart';
import '../../../navigation/navigation.dart';
import '../../../theme_manager/colors.dart';
import 'digifit_exercise_details_controller.dart';
import 'enum/digifit_exercise_session_status_enum.dart';

class DigifitExerciseDetailScreen extends ConsumerStatefulWidget {
  final DigifitExerciseDetailsParams digifitExerciseDetailsParams;

  const DigifitExerciseDetailScreen(
      {super.key, required this.digifitExerciseDetailsParams});

  @override
  ConsumerState<DigifitExerciseDetailScreen> createState() =>
      _DigifitExerciseDetailScreenState();
}

class _DigifitExerciseDetailScreenState
    extends ConsumerState<DigifitExerciseDetailScreen> {
  Timer? timer;

  @override
  void initState() {
    Future.microtask(() {
      final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;
      ref
          .read(digifitExerciseDetailsControllerProvider(equipmentId).notifier)
          .fetchDigifitExerciseDetails(
              widget.digifitExerciseDetailsParams.station.id ?? 0,
              widget.digifitExerciseDetailsParams.locationId,
              widget.digifitExerciseDetailsParams.slug);
    });
    MatomoService.trackDigifitExerciseDetailViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop == false) {
          await handleAbortBackNavigation(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Stack(
                  children: [
                    Positioned(
                        child: CommonBackgroundClipperWidget(
                      clipperType: UpstreamWaveClipper(),
                      height: 130.h,
                      imageUrl: imagePath['exercise_background'] ?? '',
                      isStaticImage: true,
                      imageFit: BoxFit.values.first,
                    )),
                    Positioned(
                      top: 25.h,
                      left: 15.w,
                      right: 15.w,
                      child: _buildHeadingArrowSection(),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: Column(
                          children: [
                            _buildBody(),
                            20.verticalSpace,
                            FeedbackCardWidget(
                                height: 270.h,
                                onTap: () {
                                  ref
                                      .read(navigationProvider)
                                      .navigateUsingPath(
                                          path: feedbackScreenPath,
                                          context: context);
                                })
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () async {
                    await handleAbortBackNavigation(context);
                  },
                  isFavVisible:
                      ref.read(networkStatusProvider).isNetworkAvailable,
                  isFav: ref
                          .watch(digifitExerciseDetailsControllerProvider(
                              equipmentId))
                          .digifitExerciseEquipmentModel
                          ?.isFavorite ??
                      false,
                  onFavChange: () async {
                    final equipment = ref
                        .read(digifitExerciseDetailsControllerProvider(
                            equipmentId))
                        .digifitExerciseEquipmentModel;

                    if (equipment != null) {
                      DigifitEquipmentFavParams params =
                          DigifitEquipmentFavParams(
                              isFavorite: !equipment.isFavorite,
                              equipmentId: equipment.id,
                              locationId: widget.digifitExerciseDetailsParams
                                      .locationId ??
                                  0);

                      await ref
                          .read(digifitExerciseDetailsControllerProvider(
                                  equipmentId)
                              .notifier)
                          .onFavTap(
                              digifitEquipmentFavParams: params,
                              onFavStatusChange: ref
                                  .read(
                                      digifitExerciseDetailsControllerProvider(
                                              equipmentId)
                                          .notifier)
                                  .detailPageOnFavStatusChange);

                      if (widget.digifitExerciseDetailsParams.onFavCallBack !=
                          null) {
                        widget.digifitExerciseDetailsParams.onFavCallBack!();
                      }
                    }
                  },
                  sessionStage: ref
                      .watch(
                          digifitExerciseDetailsControllerProvider(equipmentId))
                      .sessionStage,
                  onSessionTap: () {
                    final stage = ref
                        .read(digifitExerciseDetailsControllerProvider(
                            equipmentId))
                        .sessionStage;

                    if (stage == ExerciseStageConstant.start ||
                        stage == ExerciseStageConstant.progress) {
                      handleAbortBackNavigation(context);
                    } else {
                      null;
                    }
                  },
                )),
            if (ref
                .watch(digifitExerciseDetailsControllerProvider(equipmentId))
                .isLoading)
              Positioned(
                  top: 0.h,
                  left: 0.w,
                  right: 0.w,
                  bottom: 0.h,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(navigationProvider)
                          .removeDialog(context: context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          height: 100.h,
                          width: 100.w,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ))
          ],
        )),
      ),
    );
  }

  _buildHeadingArrowSection() {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBackWidget(
          onTap: () async {
            await handleAbortBackNavigation(context);
          },
        ),
        16.horizontalSpace,
        Visibility(
            visible: ref
                    .read(digifitExerciseDetailsControllerProvider(equipmentId))
                    .digifitExerciseEquipmentModel
                    ?.userProgress
                    .isCompleted ??
                false,
            child: _isCompletedCard())
      ],
    );
  }

  _isCompletedCard() {
    return Card(
      color: lightThemeHighlightGreenColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(
              Icons.verified,
              color: Theme.of(context).primaryColor,
              size: 18.h.w,
            ),
            8.horizontalSpace,
            textSemiBoldMontserrat(
                text: AppLocalizations.of(context).digifit_completed_top,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                textOverflow: TextOverflow.visible,
                fontSize: 16)
          ],
        ),
      ),
    );
  }

  _buildBody() {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    final digifitExerciseDetailsState =
        ref.watch(digifitExerciseDetailsControllerProvider(equipmentId));

    final description = digifitExerciseDetailsState
            .digifitExerciseEquipmentModel?.description ??
        '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifitVideoPlayerWidget(
              equipmentId: equipmentId,
              videoUrl: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.machineVideoUrl ??
                  '',
              sourceId: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.sourceId ??
                  0,
              startTimer: () {
                startTimer();
              },
              pauseTimer: () {
                pauseTimer();
              },
            ),
            SizedBox(
              height: _calculateSpacingAfterVideo(equipmentId),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: textBoldPoppins(
                  text: digifitExerciseDetailsState
                          .digifitExerciseEquipmentModel?.name ??
                      '',
                  fontSize: 16,
                  textOverflow: TextOverflow.visible,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textAlign: TextAlign.start),
            ),
            8.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: CommonHtmlWidget(data: description, fontSize: 16.sp),
            ),
            12.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: textBoldPoppins(
                  text:
                      AppLocalizations.of(context).digifit_recommended_exercise,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16),
            ),
            8.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: textRegularMontserrat(
                  text: digifitExerciseDetailsState
                          .digifitExerciseEquipmentModel?.recommendation.sets ??
                      '',
                  textOverflow: TextOverflow.visible,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textAlign: TextAlign.start),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: textRegularMontserrat(
                  text: digifitExerciseDetailsState
                          .digifitExerciseEquipmentModel
                          ?.recommendation
                          .repetitions ??
                      '',
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textOverflow: TextOverflow.visible,
                  textAlign: TextAlign.start),
            ),
            Visibility(
              visible: ref
                  .watch(digifitExerciseDetailsControllerProvider(equipmentId))
                  .isScannerVisible,
              child: _buildScanner(context),
            ),
            20.verticalSpace,
            if (digifitExerciseDetailsState
                    .digifitExerciseRelatedEquipmentsModel.isNotEmpty &&
                digifitExerciseDetailsState.isNetworkAvailable)
              _buildCourseDetailSection(
                  isButtonVisible: false,
                  relatedEquipments: digifitExerciseDetailsState
                      .digifitExerciseRelatedEquipmentsModel),
          ],
        ),
      ),
    );
  }

  double _calculateSpacingAfterVideo(int equipmentId) {
    final controller =
        ref.watch(digifitExerciseDetailsControllerProvider(equipmentId));

    bool isScannerVisible = controller.isScannerVisible;
    bool isReadyToSubmitSet = controller.isReadyToSubmitSet;
    bool isCompleted =
        controller.digifitExerciseEquipmentModel?.userProgress.isCompleted ??
            false;

    if (!isScannerVisible && !isReadyToSubmitSet && isCompleted) {
      return 140.h;
    } else if (!isScannerVisible && !isReadyToSubmitSet && !isCompleted) {
      return 30.h;
    } else {
      return 60.h;
    }
  }

  _buildCourseDetailSection(
      {bool? isButtonVisible,
      required List<DigifitExerciseRelatedStationsModel> relatedEquipments}) {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    final sourceId = ref
            .read(digifitExerciseDetailsControllerProvider(equipmentId))
            .digifitExerciseEquipmentModel
            ?.sourceId ??
        0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textRegularPoppins(
            text: AppLocalizations.of(context)
                .digifit_exercise_details_open_station,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textOverflow: TextOverflow.visible,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            textAlign: TextAlign.start),

        10.verticalSpace,

        // related equipments list
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: relatedEquipments.length,
            itemBuilder: (context, index) {
              var equipment = relatedEquipments[index];
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
                                id: equipment.id,
                                name: equipment.name,
                                isFavorite: equipment.isFavorite,
                                muscleGroups: equipment.muscleGroups,
                              ),
                              locationId: widget.digifitExerciseDetailsParams
                                      .locationId ??
                                  0,
                              onFavCallBack: () {
                                ref
                                    .read(
                                        digifitExerciseDetailsControllerProvider(equipmentId)
                                            .notifier)
                                    .fetchDigifitExerciseDetails(
                                        widget.digifitExerciseDetailsParams
                                                .station.id ??
                                            0,
                                        widget.digifitExerciseDetailsParams
                                            .locationId,
                                        widget
                                            .digifitExerciseDetailsParams.slug);
                              }));
                    } else {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: offlineDigifitExerciseDetailScreenPath,
                          context: context,
                          params: DigifitExerciseDetailsParams(
                              station: DigifitInformationStationModel(
                                id: equipment.id,
                                name: equipment.name,
                                isFavorite: equipment.isFavorite,
                                muscleGroups: equipment.muscleGroups,
                              ),
                              locationId: widget.digifitExerciseDetailsParams
                                      .locationId ??
                                  0,
                              onFavCallBack: () {}));
                    }
                  },
                  imageUrl: equipment.machineImageUrl,
                  heading: equipment.muscleGroups,
                  title: equipment.name,
                  isFavouriteVisible:
                      ref.read(networkStatusProvider).isNetworkAvailable,
                  isFavorite: equipment.isFavorite,
                  sourceId: sourceId,
                  onFavorite: () async {
                    DigifitEquipmentFavParams params =
                        DigifitEquipmentFavParams(
                            isFavorite: !equipment.isFavorite,
                            equipmentId: equipment.id,
                            locationId: widget
                                    .digifitExerciseDetailsParams.locationId ??
                                0);

                    await ref
                        .read(digifitExerciseDetailsControllerProvider(
                                equipmentId)
                            .notifier)
                        .onFavTap(
                            digifitEquipmentFavParams: params,
                            onFavStatusChange: ref
                                .read(digifitExerciseDetailsControllerProvider(
                                        equipmentId)
                                    .notifier)
                                .recommendOnFavStatusChange);

                    if (widget.digifitExerciseDetailsParams.onFavCallBack !=
                        null) {
                      widget.digifitExerciseDetailsParams.onFavCallBack!();
                    }
                  },
                ),
              );
            }),
        10.verticalSpace,
        Visibility(
          visible: isButtonVisible ?? true,
          child: CustomButton(
              onPressed: () {}, text: AppLocalizations.of(context).show_course),
        )
      ],
    );
  }

  void showErrorDialog(BuildContext context, String title, String description) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
            text: title, textAlign: TextAlign.center, fontSize: 16),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
              text: description,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              ref.read(navigationProvider).removeDialog(context: context);
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).ok,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  void showAbortedDialog(
      BuildContext context, String title, String description) {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
            text: title, textAlign: TextAlign.center, fontSize: 16),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
              text: description,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              ref.read(navigationProvider).removeDialog(context: context);
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).digifit_continue,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              await ref.read(navigationProvider).removeDialog(context: context);

              final digifitExerciseDetailsState = ref
                  .watch(digifitExerciseDetailsControllerProvider(equipmentId));

              await ref
                  .read(digifitExerciseDetailsControllerProvider(equipmentId)
                      .notifier)
                  .trackExerciseDetails(
                      digifitExerciseDetailsState
                              .digifitExerciseEquipmentModel?.id ??
                          0,
                      widget.digifitExerciseDetailsParams.locationId ?? 0,
                      digifitExerciseDetailsState.currentSetNumber,
                      digifitExerciseDetailsState.digifitExerciseEquipmentModel
                              ?.userProgress.repetitionsPerSet ??
                          0,
                      ExerciseStageConstant.abort, () {
                ref.read(navigationProvider).removeTopPage(context: context);
              });
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).digifit_end_game,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  _buildScanner(BuildContext context) {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    final digifitExerciseDetailsState =
        ref.watch(digifitExerciseDetailsControllerProvider(equipmentId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        30.verticalSpace,
        CustomButton(
            iconHeight: 15.h,
            iconWidth: 15.w,
            icon: imagePath['scan_icon'],
            onPressed: () async {
              final currentSetNumber = ref
                  .read(digifitExerciseDetailsControllerProvider(equipmentId))
                  .currentSetNumber;

              final targetSetNumber = ref
                  .read(digifitExerciseDetailsControllerProvider(equipmentId))
                  .totalSetNumber;

              if (currentSetNumber < targetSetNumber) {
                String path = digifitQRScannerScreenPath;

                if (!ref.read(networkStatusProvider).isNetworkAvailable) {
                  path = offlineDigifitQRScannerScreenPath;
                }

                final result = await ref
                    .read(navigationProvider)
                    .navigateUsingPath(path: path, context: context);

                final qrCodeIdentifier = ref
                        .watch(digifitExerciseDetailsControllerProvider(
                            equipmentId))
                        .digifitExerciseEquipmentModel
                        ?.qrCodeIdentifier ??
                    '';
                if (result != null) {
                  final res = await ref
                      .read(
                          digifitExerciseDetailsControllerProvider(equipmentId)
                              .notifier)
                      .validateQrScanner(result, qrCodeIdentifier);

                  if (res) {
                    await ref
                        .read(digifitExerciseDetailsControllerProvider(
                                equipmentId)
                            .notifier)
                        .trackExerciseDetails(
                            digifitExerciseDetailsState
                                    .digifitExerciseEquipmentModel?.id ??
                                0,
                            widget.digifitExerciseDetailsParams.locationId ?? 0,
                            digifitExerciseDetailsState.currentSetNumber,
                            digifitExerciseDetailsState
                                    .digifitExerciseEquipmentModel
                                    ?.userProgress
                                    .repetitionsPerSet ??
                                0,
                            ExerciseStageConstant.start, () {
                      showSuccessToast(
                          message: AppLocalizations.of(context).session_start,
                          context: context);
                      ref
                          .read(digifitExerciseDetailsControllerProvider(
                                  equipmentId)
                              .notifier)
                          .updateScannerButtonVisibility(false);

                      ref
                          .read(digifitExerciseDetailsControllerProvider(
                                  equipmentId)
                              .notifier)
                          .updateIsReadyToSubmitSetVisibility(true);
                    });
                  } else {
                    showErrorDialog(context, AppLocalizations.of(context).error,
                        AppLocalizations.of(context).validation_falied_message);
                  }
                }
              } else {
                showErrorDialog(context, AppLocalizations.of(context).complete,
                    AppLocalizations.of(context).goal_achieved);
              }
            },
            text: AppLocalizations.of(context).scan_exercise)
      ],
    );
  }

  startTimer() {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    ref
        .read(digifitExerciseDetailsControllerProvider(equipmentId).notifier)
        .updateTimerStatus(TimerState.start);

    final state =
        ref.watch(digifitExerciseDetailsControllerProvider(equipmentId));

    int secondsLeft = state.remainingPauseSecond > 0
        ? state.remainingPauseSecond
        : state.time;

    ref
        .read(digifitExerciseDetailsControllerProvider(equipmentId).notifier)
        .updateRemainingSeconds(secondsLeft);

    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (secondsLeft == 0) {
        pauseTimer();

        ref
            .read(
                digifitExerciseDetailsControllerProvider(equipmentId).notifier)
            .updateIsReadyToSubmitSetVisibility(true);
      } else {
        secondsLeft--;

        ref
            .read(
                digifitExerciseDetailsControllerProvider(equipmentId).notifier)
            .updateRemainingSeconds(secondsLeft);
      }
    });
  }

  pauseTimer() {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    if (timer != null) {
      timer!.cancel();
      ref
          .read(digifitExerciseDetailsControllerProvider(equipmentId).notifier)
          .updateTimerStatus(TimerState.pause);
    }
  }

  Future<void> handleAbortBackNavigation(BuildContext context) async {
    final equipmentId = widget.digifitExerciseDetailsParams.station.id ?? 0;

    bool? isScanner = ref
        .read(digifitExerciseDetailsControllerProvider(equipmentId))
        .isScannerVisible;

    bool? isCompleted = ref
            .read(digifitExerciseDetailsControllerProvider(equipmentId))
            .digifitExerciseEquipmentModel
            ?.userProgress
            .isCompleted ??
        false;

    if (!isScanner && !isCompleted) {
      showAbortedDialog(
          context,
          AppLocalizations.of(context).digifit_abort_exercise_title,
          AppLocalizations.of(context).digifit_abort_exercise_desp);
    } else {
      ref.read(navigationProvider).removeTopPage(context: context);
    }
  }
}
