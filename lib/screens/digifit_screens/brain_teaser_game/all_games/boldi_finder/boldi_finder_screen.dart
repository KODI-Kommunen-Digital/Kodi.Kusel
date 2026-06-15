import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/details_controller.dart';

import '../../../../../app_router.dart';
import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../../common_widgets/common_html_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/common_component/error_overlay_component.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/common_component/success_overlay_component.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/grid_widget.dart';
import '../../../../../common_widgets/feedback_card_widget.dart';
import '../../../../../common_widgets/text_styles.dart';
import '../../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../../images_path.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../navigation/navigation.dart';
import '../../../digifit_start/digifit_information_controller.dart';
import '../../enum/game_session_status.dart';
import '../components/arrow_direction.dart';
import '../components/boldi_component.dart';
import '../components/pause_icon.dart';
import '../params/all_game_params.dart';
import 'boldi_finder_controller.dart';
import 'boldi_finder_state.dart';

class BoldiFinderScreen extends ConsumerStatefulWidget {
  final AllGameParams? boldiFinderParams;

  const BoldiFinderScreen({super.key, required this.boldiFinderParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BoldiFinderScreenState();
  }
}

class _BoldiFinderScreenState extends ConsumerState<BoldiFinderScreen> {
  CommonGridWidget? _gridGame;
  final GlobalKey _gridKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        brainTeaserGameBoldiFinderControllerProvider(
          widget.boldiFinderParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchGameData(
        gameId: widget.boldiFinderParams?.gameId ?? 1,
        levelId: widget.boldiFinderParams?.levelId ?? 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ),
    );

    final headingText = widget.boldiFinderParams?.title ?? '';
    final useInnerPadding = widget.boldiFinderParams?.gameId == 3;

    final gridHeight = 330.w;
    final gridWidth = 330.w;
    final rows = state.rows;
    final columns = state.columns;
    final tileWidth = gridWidth / columns;
    final tileHeight = gridHeight / rows;

    if (_gridGame == null ||
        _gridGame!.params.rows != rows ||
        _gridGame!.params.columns != columns) {
      _gridGame = CommonGridWidget(
        params: CommonGridParams(
          width: gridWidth,
          height: gridHeight,
          tileHeight: tileHeight,
          tileWidth: tileWidth,
          rows: rows,
          columns: columns,
          borderColor: Theme.of(context).dividerColor,
          useInnerPadding: useInnerPadding,
          onCellTapped: _handleCellTap,
        ),
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
                                context: context,
                              ),
                            ),
                          ),

                          10.verticalSpace,

                          // Description
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 30,
                            ),
                            child: CommonHtmlWidget(
                              fontSize: 16,
                              data: state.gameData?.subDescription ?? '',
                            ),
                          ),

                          20.verticalSpace,
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
                  gameDetailsStageConstant: state.gameStage,
                ),
              ),

              if (state.showResult && state.hasAnswerResult)
                Positioned(
                  bottom: 80.h,
                  left: 0,
                  right: 0,
                  child: GameStatusCardWidget(
                    isStatus: state.isAnswerCorrect ?? false,
                    description: _getGameStatusDescription(
                        widget.boldiFinderParams?.levelId ?? 1),
                  ),
                ),
            ],
          ),
        ),
      ).loaderDialog(context, state.isLoading),
    );
  }

  Widget _buildGameStack({
    required BrainTeaserGameBoldiFinderState state,
    required double gridWidth,
    required double gridHeight,
    required double tileWidth,
    required double tileHeight,
    required BuildContext context,
  }) {
    return Stack(
      children: [
        GameWidget(
          key: _gridKey,
          game: _gridGame!,
        ),
        if (state.showBoldi && state.hasBoldiPosition)
          GameWidget(
            key: ValueKey('boldi_${state.boldiRow}_${state.boldiCol}'),
            game: BoldiOverlayGame(
              row: state.boldiRow!,
              column: state.boldiCol!,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
            ),
          ),
        if (state.showArrow && state.hasArrowDirection)
          GameWidget(
            key: ValueKey(
              'arrow_${state.arrowDisplayIndex}_${state.currentArrowDirection}',
            ),
            game: ArrowOverlayGame(
              direction: state.currentArrowDirection!,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              borderColor: Theme.of(context).dividerColor,
              arrowColor:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
              durationSeconds: state.timerSeconds,
            ),
          ),
        if (state.showPause)
          GameWidget(
            key: const ValueKey('pause'),
            game: PauseOverlayGame(
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              borderColor: Theme.of(context).dividerColor,
              arrowColor:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
            ),
          ),
        if (state.showResult &&
            state.hasAnswerResult &&
            state.isAnswerCorrect == true)
          GameWidget(
            key: ValueKey('success_${state.selectedRow}_${state.selectedCol}'),
            game: SuccessOverlayGame(
              row: state.selectedRow!,
              column: state.selectedCol!,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              successColor: Colors.green,
            ),
          ),
        if (state.showResult &&
            state.hasAnswerResult &&
            state.isAnswerCorrect == false)
          GameWidget(
            key: ValueKey(
              'error_${state.selectedRow}_${state.selectedCol}_${state.correctRow}_${state.correctCol}',
            ),
            game: ErrorOverlayGame(
              wrongRow: state.selectedRow!,
              wrongColumn: state.selectedCol!,
              correctRow: state.correctRow ?? 0,
              correctColumn: state.correctCol ?? 0,
              gridWidth: gridWidth,
              gridHeight: gridHeight,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              errorColor: Colors.red,
              correctColor: Colors.green,
            ),
          ),
      ],
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

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ).notifier,
    );

    final state = ref.read(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ),
    );

    switch (state.gameStage) {
      case GameStageConstant.initial:
        await controller.startGame();
        break;

      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;

      case GameStageConstant.abort:
        await controller.restartGame(
          widget.boldiFinderParams?.gameId ?? 1,
          widget.boldiFinderParams?.levelId ?? 1,
        );
        break;

      case GameStageConstant.complete:
        await _handleBackNavigation(context);
        break;

      default:
        break;
    }
  }

  void _handleCellTap(int row, int column) {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ).notifier,
    );

    controller.checkAnswer(row, column);
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ).notifier,
    );

    final state = ref.read(
      brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1,
      ),
    );

    switch (state.gameStage) {
      case GameStageConstant.progress:
        controller.pauseGame();
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

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).abort_game,
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

              final controller = ref.read(
                brainTeaserGameBoldiFinderControllerProvider(
                  widget.boldiFinderParams?.levelId ?? 1,
                ).notifier,
              );

              controller.resumeGame();
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
                brainTeaserGameBoldiFinderControllerProvider(
                  widget.boldiFinderParams?.levelId ?? 1,
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

    String text = ((widget.boldiFinderParams?.levelId ?? 1) == 1 ||
            (widget.boldiFinderParams?.levelId ?? 1) == 2)
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
                        widget.boldiFinderParams?.gameId ?? 1,
                      ).notifier,
                    )
                    .fetchBrainTeaserGameDetails(
                      gameId: widget.boldiFinderParams?.gameId ?? 1,
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

  String _getGameStatusDescription(int levelId) {
    switch (levelId) {
      case 1:
        return AppLocalizations.of(context).successful_game_desc_for_level_1;
      case 2:
        return AppLocalizations.of(context).successful_game_desc_for_level_2;
      case 3:
        return AppLocalizations.of(context).successful_game_desc_for_level_3;
      default:
        return "Great effort! Keep pushing your limits.";
    }
  }

  @override
  void dispose() {
    _gridGame = null;
    super.dispose();
  }
}
