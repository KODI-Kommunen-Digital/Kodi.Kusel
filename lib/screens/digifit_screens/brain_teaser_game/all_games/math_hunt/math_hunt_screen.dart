import 'package:flame/game.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_bottom_nav_card_.dart';
import 'package:kusel/common_widgets/common_html_widget.dart';
import 'package:kusel/common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/math_hunt/math_hunt_state.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/params/all_game_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app_router.dart';
import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
import '../../../../../common_widgets/feedback_card_widget.dart';
import '../../../../../common_widgets/text_styles.dart';
import '../../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../../images_path.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../navigation/navigation.dart';
import '../../../digifit_start/digifit_information_controller.dart';
import '../../enum/game_session_status.dart';
import '../../game_details/details_controller.dart';
import 'math_hunt_controller.dart';
import 'math_hunt_ui.dart';

class MathHuntScreen extends ConsumerStatefulWidget {
  final AllGameParams? mathHuntGameParams;

  const MathHuntScreen({super.key, required this.mathHuntGameParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MathHuntScreenState();
}

class _MathHuntScreenState extends ConsumerState<MathHuntScreen> {
  MathGameUI? _gameInstance;
  bool _shouldShowGame = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        brainTeaserGameMathHuntControllerProvider(
          widget.mathHuntGameParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchBrainTeaserGameMathHunt(
        gameId: widget.mathHuntGameParams?.gameId ?? 1,
        levelId: widget.mathHuntGameParams?.levelId ?? 1,
        onSuccess: () {
          if (mounted) {
            setState(() {
              _shouldShowGame = true;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brainTeaserGameMathHuntControllerProvider(
        widget.mathHuntGameParams?.levelId ?? 1));
    final controller = ref.read(brainTeaserGameMathHuntControllerProvider(
            widget.mathHuntGameParams?.levelId ?? 1)
        .notifier);

    final headingText = widget.mathHuntGameParams?.title ?? '';

    ref.listen<BrainTeaserGameMathHuntState>(
      brainTeaserGameMathHuntControllerProvider(
          widget.mathHuntGameParams?.levelId ?? 1),
      (previous, next) {
        if (_gameInstance != null) {
          _updateGameUI(next);
        }
      },
    );

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
                        height: 140.h,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 20.0),
                            child: SizedBox(
                              height: 220.h,
                              width: double.infinity,
                              child: _buildMathHunt(state, controller),
                            ),
                          ),
                          2.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 30,
                            ),
                            child: CommonHtmlWidget(
                              data:
                                  state.mathHuntDataModel?.subDescription ?? '',
                              fontSize: 16,
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
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () => _handleBackNavigation(context),
                  isFavVisible: false,
                  isFav: false,
                  gameDetailsStageConstant: state.gameStage,
                  onGameStageConstantTap: _handleBottomNavTap,
                ),
              ),
              if (state.showResult)
                Positioned(
                  bottom: 80.h,
                  left: 0,
                  right: 0,
                  child: GameStatusCardWidget(
                    isStatus: state.isAnswerCorrect ?? false,
                    description: _getGameStatusDescription(
                        widget.mathHuntGameParams?.levelId ?? 1),
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
          onPressed: () => _handleBackNavigation(context),
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

  void _updateGameUI(BrainTeaserGameMathHuntState state) {
    if (_gameInstance?.cloudText == null) return;

    _gameInstance!.updateGameState(
      problem: state.currentProblem.isEmpty
          ? AppLocalizations.of(context).math_hunt_game_desc
          : state.currentProblem,
      showProblem: state.showProblem,
      showOptions: state.showOptions,
      options: state.mathHuntDataModel?.options ?? [],
      showTimer: state.showTimer,
      isAnswerCorrect: state.isAnswerCorrect,
      selectedAnswerIndex: state.selectedAnswerIndex,
      timerDuration: state.mathHuntDataModel?.timer?.toDouble(),
    );
  }

  Widget _buildMathHunt(
    BrainTeaserGameMathHuntState state,
    BrainTeaserGameMathHuntController controller,
  ) {
    if (!_shouldShowGame) {
      return const SizedBox.shrink();
    }

    _gameInstance ??= MathGameUI(
        onGameStart: () => controller.startGame(),
        onOptionSelected: (optionIndex) =>
            controller.handleOptionSelected(optionIndex),
        context: context);

    return GameWidget(game: _gameInstance!);
  }

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;

    final controller = ref.read(brainTeaserGameMathHuntControllerProvider(
      widget.mathHuntGameParams?.levelId ?? 1,
    ).notifier);

    final state = ref.read(brainTeaserGameMathHuntControllerProvider(
      widget.mathHuntGameParams?.levelId ?? 1,
    ));

    switch (state.gameStage) {
      case GameStageConstant.initial:
        await controller.startGame();
        break;

      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;

      case GameStageConstant.abort:
        setState(() {
          _shouldShowGame = false;
        });
        await controller.restartGameWithRefetch(
          gameId: widget.mathHuntGameParams?.gameId ?? 1,
          levelId: widget.mathHuntGameParams?.levelId ?? 1,
          onSuccess: () {
            if (mounted) {
              setState(() {
                _shouldShowGame = true;
              });
            }
          },
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

    final state = ref.read(brainTeaserGameMathHuntControllerProvider(
      widget.mathHuntGameParams?.levelId ?? 1,
    ));

    switch (state.gameStage) {
      case GameStageConstant.progress:
        await _showAbortDialog(context);
        break;

      case GameStageConstant.complete:
        await _showCompleteDialog(context);
        break;

      default:
        if (mounted) {
          ref.read(navigationProvider).removeTopPage(context: context);
        }
        break;
    }
  }

  Future<void> _showCompleteDialog(BuildContext context) async {
    if (!mounted) return;

    String text = ((widget.mathHuntGameParams?.levelId ?? 7) == 7 ||
            (widget.mathHuntGameParams?.levelId ?? 1) == 8)
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
            onPressed: () {
              if (!mounted) return;

              ref.read(navigationProvider).removeDialog(context: context);

              if (!mounted) return;

              ref.read(navigationProvider).removeTopPage(context: context);

              Future.microtask(() {
                ref
                    .read(
                      brainTeaserGameDetailsControllerProvider(
                        widget.mathHuntGameParams?.gameId ?? 1,
                      ).notifier,
                    )
                    .fetchBrainTeaserGameDetails(
                      gameId: widget.mathHuntGameParams?.gameId ?? 1,
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

  Future<void> _showAbortDialog(BuildContext context) async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameMathHuntControllerProvider(
        widget.mathHuntGameParams?.levelId ?? 1,
      ).notifier,
    );

    controller.pauseSequence();
    _gameInstance?.pauseTimer();

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).abort_math_hunt_game,
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

              controller.resumeSequence();
              _gameInstance?.resumeTimer();
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

  String _getGameStatusDescription(int levelId) {
    switch (levelId) {
      case 7:
        return AppLocalizations.of(context).successful_game_desc_for_level_1;
      case 8:
        return AppLocalizations.of(context).successful_game_desc_for_level_2;
      case 9:
        return AppLocalizations.of(context).successful_game_desc_for_level_3;
      default:
        return "Great effort! Keep pushing your limits.";
    }
  }

  @override
  void dispose() {
    _gameInstance = null;
    super.dispose();
  }
}
