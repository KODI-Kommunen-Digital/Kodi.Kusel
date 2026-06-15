import 'dart:ui' as ui;

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';

import '../../../../../app_router.dart';
import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../../common_widgets/common_html_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/blur_dialog_wrapper.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import '../../../../../common_widgets/feedback_card_widget.dart';
import '../../../../../common_widgets/text_styles.dart';
import '../../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../../images_path.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../navigation/navigation.dart';
import '../../../digifit_start/digifit_information_controller.dart';
import '../../enum/game_session_status.dart';
import '../params/all_game_params.dart';
import '../../game_details/details_controller.dart';
import 'components/digit_dash_boldi_cloud_overlay.dart';
import 'components/digit_dash_grid_ui.dart';
import 'digit_dash_state.dart';
import 'digit_dash_controller.dart';

class DigitDashScreen extends ConsumerStatefulWidget {
  final AllGameParams? digitDashParams;

  const DigitDashScreen({super.key, required this.digitDashParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DigitDashScreenState();
  }
}

class _DigitDashScreenState extends ConsumerState<DigitDashScreen> {
  DigitDashGridOverlayGame? _gridOverlayGame;
  DigitDashBoldiCloudOverlayGame? _boldiCloudGame;
  final GlobalKey _gridKey = GlobalKey();
  final GlobalKey _boldiKey = GlobalKey();

  int? _lastRows;
  int? _lastCols;
  int? _lastLevelId;
  int? _lastInitialNumber;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        brainTeaserGameDigitDashControllerProvider(
          widget.digitDashParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchGameData(
        gameId: widget.digitDashParams?.gameId ?? 1,
        levelId: widget.digitDashParams?.levelId ?? 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    final headingText = widget.digitDashParams?.title ?? '';

    final gridHeight = 330.w;
    final gridWidth = 330.w;
    final rows = state.rows;
    final columns = state.cols;
    final tileWidth = gridWidth / columns;
    final tileHeight = gridHeight / rows;

    final shouldRecreateGame = _gridOverlayGame == null ||
        _lastRows != rows ||
        _lastCols != columns ||
        _lastLevelId != widget.digitDashParams?.levelId ||
        _lastInitialNumber != state.initialNumber ||
        (state.gridNumbers?.isEmpty ?? true);

    if (shouldRecreateGame) {
      _gridOverlayGame = DigitDashGridOverlayGame(
        gridParams: DigitDashGridParams(
          width: gridWidth,
          height: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          rows: rows,
          columns: columns,
          gridNumbers: state.gridNumbers,
          gridAngles: state.gridAngles,
          markedCorrect: state.markedCorrect,
          markedWrong: state.markedWrong,
          selectedIndex: state.selectedIndex,
          isAnswerCorrect: state.isAnswerCorrect,
          onNumberTap: (index) => _handleNumberSelection(index),
          isEnabled: state.isGamePlayEnabled,
          borderColor: Theme.of(context).dividerColor,
          targetCondition: state.targetCondition,
          levelId: widget.digitDashParams?.levelId ?? 1,
          currentTime: state.timerSecond,
          maxTime: state.maxTimerSeconds,
          textColor:
              Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      );

      _lastRows = rows;
      _lastCols = columns;
      _lastLevelId = widget.digitDashParams?.levelId;
      _lastInitialNumber = state.initialNumber;
    } else if (_gridOverlayGame != null) {
      _gridOverlayGame!.gridParams.currentTime = state.timerSecond;
      _gridOverlayGame!.gridParams.gridNumbers = state.gridNumbers;
      _gridOverlayGame!.gridParams.gridAngles = state.gridAngles;
      _gridOverlayGame!.gridParams.markedCorrect = state.markedCorrect;
      _gridOverlayGame!.gridParams.markedWrong = state.markedWrong;
      _gridOverlayGame!.gridParams.selectedIndex = state.selectedIndex;
      _gridOverlayGame!.gridParams.isAnswerCorrect = state.isAnswerCorrect;
      _gridOverlayGame!.gridParams.isEnabled = state.isGamePlayEnabled;
    }
    if (_boldiCloudGame == null && state.showBoldiWithCloud) {
      _boldiCloudGame = DigitDashBoldiCloudOverlayGame(
        width: MediaQuery.of(context).size.width,
        height: 380,
        cloudText: AppLocalizations.of(context).digit_dash_game_desc,
        textColor: Theme.of(context).textTheme.bodyLarge?.color,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop == false) {
          await _handleBackNavigation(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Stack(
                    children: [
                      CommonBackgroundClipperWidget(
                        height: 145.h,
                        clipperType: UpstreamWaveClipper(),
                        imageUrl: imagePath['home_screen_background'] ?? '',
                        isStaticImage: true,
                      ),
                      Positioned(
                        top: 50.h,
                        left: 10.r,
                        child: _buildHeader(headingText),
                      ),
                      Column(
                        children: [
                          130.verticalSpace,
                          Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: gridHeight,
                                  width: gridWidth,
                                  child: _buildGameStack(
                                    state: state,
                                    gridWidth: gridWidth,
                                    gridHeight: gridHeight,
                                    tileWidth: tileWidth,
                                    tileHeight: tileHeight,
                                  ))),
                          10.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 30,
                            ),
                            child: CommonHtmlWidget(
                              fontSize: 16,
                              data: state.digitDashData?.subDescription ?? '',
                            ),
                          ),
                          10.verticalSpace,
                          if (!state.isLoading)
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

              // Bottom navigation
              Positioned(
                bottom: 20.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () async {
                    await _handleBackNavigation(context);
                  },
                  isFavVisible: false,
                  isFav: false,
                  onGameStageConstantTap: _handleBottomNavTap,
                  gameDetailsStageConstant: state.gameStageConstant,
                ),
              ),

              if (state.showResult)
                Positioned(
                  bottom: 80.h,
                  left: 0,
                  right: 0,
                  child: GameStatusCardWidget(
                    isStatus: state.isAnswerCorrect ?? false,
                    description: () {
                      switch (widget.digitDashParams?.levelId ?? 1) {
                        case 10:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_1;
                        case 11:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_2;
                        case 12:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_3;
                        default:
                          return "Great effort! Keep pushing your limits.";
                      }
                    }(),
                  ),
                ),
            ],
          ),
        ),
      ).loaderDialog(context, state.isLoading),
    );
  }

  Widget _buildHeader(String headingText) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await _handleBackNavigation(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: DeviceHelper.isMobile(context) ? null : 12.h.w,
            color: Theme.of(context).primaryColor,
          ),
        ),
        2.horizontalSpace,
        textSemiBoldPoppins(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          text: headingText,
        ),
      ],
    );
  }

  Widget _buildGameStack({
    required BrainTeaserGameDigitDashState state,
    required double gridHeight,
    required double gridWidth,
    required double tileHeight,
    required double tileWidth,
  }) {
    return Stack(
      children: [
        if (state.showBoldiWithCloud && _boldiCloudGame != null)
          Center(
            child: GameWidget(
              key: _boldiKey,
              game: _boldiCloudGame!,
            ),
          ),
        if (state.showGrid && _gridOverlayGame != null)
          GameWidget(
            key: _gridKey,
            game: _gridOverlayGame!,
          ),
      ],
    );
  }

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );

    final state = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    switch (state.gameStageConstant) {
      case GameStageConstant.initial:
        if (widget.digitDashParams?.levelId == 10) {
          await _showLevel1Dialog(context);
        } else if (widget.digitDashParams?.levelId == 11) {
          await _showLevel2Dialog(context);
        } else if (widget.digitDashParams?.levelId == 12) {
          await _showLevel3ForbiddenDialog(context);
        } else {
          await controller.startGame();
        }
        break;

      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;

      case GameStageConstant.abort:
        await controller.restartGame(
          widget.digitDashParams?.gameId ?? 1,
          widget.digitDashParams?.levelId ?? 1,
        );
        break;

      case GameStageConstant.complete:
        await _handleBackNavigation(context);
        break;

      default:
        break;
    }
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    if (!mounted) return;

    final state = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    switch (state.gameStageConstant) {
      case GameStageConstant.progress:
        await _showAbortDialog(context);
        break;

      case GameStageConstant.complete:
        await _showCompletionDialog(context);
        break;

      default:
        if (mounted) {
          ref.read(navigationProvider).removeTopPage(context: context);
        }
        break;
    }
  }

  Future<void> _showAbortDialog(BuildContext context) async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );

    controller.pauseGameTimer();

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).abort_digit_dash,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
            text: AppLocalizations.of(context).abort_game_desc,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.visible,
            fontSize: 12,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (!mounted) return;
              controller.resumeGameTimer();
              ref.read(navigationProvider).removeDialog(context: context);
            },
            isDefaultAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).digifit_continue,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;

              final controller = ref.read(
                brainTeaserGameDigitDashControllerProvider(
                  widget.digitDashParams?.levelId ?? 1,
                ).notifier,
              );

              await ref.read(navigationProvider).removeDialog(context: context);

              if (!mounted) return;

              await controller.trackGameProgress(
                GameStageConstant.abort,
                onSuccess: () {
                  if (mounted) {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  }
                },
              );
            },
            child: textBoldPoppins(
              text: AppLocalizations.of(context).digifit_end_game,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompletionDialog(BuildContext context) async {
    if (!mounted) return;

    String text = ((widget.digitDashParams?.levelId ?? 10) == 10 ||
            (widget.digitDashParams?.levelId ?? 1) == 11)
        ? AppLocalizations.of(context).level_complete_desc
        : AppLocalizations.of(context).all_level_complete;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).level_complete,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
            text: text,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.visible,
            fontSize: 12,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;

              ref.read(navigationProvider).removeDialog(context: context);

              if (!mounted) return;

              ref.read(navigationProvider).removeTopPage(context: context);

              Future.microtask(() async {
                await ref
                    .read(
                      brainTeaserGameDetailsControllerProvider(
                        widget.digitDashParams?.gameId ?? 1,
                      ).notifier,
                    )
                    .fetchBrainTeaserGameDetails(
                      gameId: widget.digitDashParams?.gameId ?? 1,
                    );

                ref
                    .read(digifitInformationControllerProvider.notifier)
                    .fetchDigifitInformation();
              });
            },
            isDefaultAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).ok,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNumberSelection(int index) {
    if (!mounted) return;
    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );
    controller.checkAnswer(index);
  }

  Future<void> _showLevel1Dialog(BuildContext context) async {
    if (!mounted) return;

    final state = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );

    final initialNumber = state.initialNumber;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlurDialogWrapper(
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor: const Color(0xFFE7EEF8),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textSemiBoldPoppins(
                            text: AppLocalizations.of(context)
                                .digit_dash_dialog_title,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(navigationProvider)
                                .removeDialog(context: context);
                          },
                          child: Icon(
                            size:
                                DeviceHelper.isMobile(context) ? null : 12.h.w,
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  textSemiBoldPoppins(
                    text: AppLocalizations.of(context).game_start_at,
                    textAlign: TextAlign.left,
                    fontSize: 16.sp,
                    textOverflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF264579),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: textBoldPoppins(
                        text: initialNumber.toString() ?? "0",
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(30.r),
                      color: const Color(0xFF264579),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      onPressed: () async {
                        if (!mounted) return;
                        ref
                            .read(navigationProvider)
                            .removeDialog(context: context);
                        if (!mounted) return;
                        await controller.startGame();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6.w),
                          textSemiBoldPoppins(
                            text: AppLocalizations.of(context).understood,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLevel2Dialog(BuildContext context) async {
    if (!mounted) return;

    final state = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );

    final conditionText = state.targetCondition?.toLowerCase() ?? '';
    String displayText = '';
    Color highlightColor = Colors.black;

    if (conditionText.contains('odd')) {
      displayText =
          AppLocalizations.of(context).digit_dash_dialog_target_desc_odd;
      highlightColor = const Color(0xFF264579);
    } else if (conditionText.contains('even')) {
      displayText =
          AppLocalizations.of(context).digit_dash_dialog_target_desc_even;
      highlightColor = const Color(0xFFC92120);
    } else {
      displayText = 'Folge der speziellen Regel für dieses Level!';
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlurDialogWrapper(
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor: const Color(0xFFE7EEF8),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textSemiBoldPoppins(
                            text: AppLocalizations.of(context)
                                .digit_dash_dialog_title,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(navigationProvider)
                                .removeDialog(context: context);
                          },
                          child: Icon(
                            size:
                                DeviceHelper.isMobile(context) ? null : 12.h.w,
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  textSemiBoldPoppins(
                    text: displayText,
                    textAlign: TextAlign.left,
                    fontSize: 16.sp,
                    textOverflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(30.r),
                      color: const Color(0xFF264579),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      onPressed: () async {
                        if (!mounted) return;
                        ref
                            .read(navigationProvider)
                            .removeDialog(context: context);
                        if (!mounted) return;
                        await controller.startGame();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6.w),
                          textSemiBoldPoppins(
                            text: AppLocalizations.of(context).understood,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLevel3ForbiddenDialog(BuildContext context) async {
    if (!mounted) return;

    final state = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ),
    );

    final controller = ref.read(
      brainTeaserGameDigitDashControllerProvider(
        widget.digitDashParams?.levelId ?? 1,
      ).notifier,
    );

    final forbiddenNumbers = state.forbiddenNumbers;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlurDialogWrapper(
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor: const Color(0xFFE7EEF8),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textSemiBoldPoppins(
                            text: AppLocalizations.of(context)
                                .digit_dash_dialog_title,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(navigationProvider)
                                .removeDialog(context: context);
                          },
                          child: Icon(
                            size:
                                DeviceHelper.isMobile(context) ? null : 12.h.w,
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  textRegularPoppins(
                    text: AppLocalizations.of(context)
                        .digit_dash_dialog_forbidden_desc,
                    textAlign: TextAlign.left,
                    fontSize: 14.sp,
                    textOverflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Center(
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 10.h,
                        alignment: WrapAlignment.center,
                        children: forbiddenNumbers.map((number) {
                          return Container(
                            width: 40.w,
                            height: 40.w,
                            alignment: Alignment.center,
                            child: Text(
                              number.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF264579),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(30.r),
                      color: const Color(0xFF264579),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      onPressed: () async {
                        if (!mounted) return;
                        ref
                            .read(navigationProvider)
                            .removeDialog(context: context);
                        if (!mounted) return;
                        await controller.startGame();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6.w),
                          textSemiBoldPoppins(
                            text: AppLocalizations.of(context).understood,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _gridOverlayGame = null;
    _boldiCloudGame = null;
    super.dispose();
  }
}
