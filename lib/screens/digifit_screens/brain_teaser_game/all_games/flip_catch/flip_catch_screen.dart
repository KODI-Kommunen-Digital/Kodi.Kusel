import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/flip_catch/component/flip_catch_boldi_cloud_overlay_game.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/flip_catch/component/word_timer_overlay.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/flip_catch/flip_catch_state.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/details_controller.dart';

import '../../../../../app_router.dart';
import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../../common_widgets/common_html_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
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
import 'component/drag_selection_component.dart';
import 'component/word_list_overlay.dart';
import 'flip_catch_controller.dart';

class FlipCatchScreen extends ConsumerStatefulWidget {
  final AllGameParams? flipCatchParams;

  const FlipCatchScreen({super.key, required this.flipCatchParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FlipCatchScannerState();
  }
}

class _FlipCatchScannerState extends ConsumerState<FlipCatchScreen> {
  final GlobalKey<DragSelectTextWidgetState> _dragSelectKey = GlobalKey();
  WordTimerOverlayGame? _wordTimerGame;
  String? _pendingSelectedText;
  int? _pendingStartIndex;
  int? _pendingEndIndex;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        brainTeaserGameFlipCatchControllerProvider(
          widget.flipCatchParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchGameData(
        gameId: widget.flipCatchParams?.gameId ?? 1,
        levelId: widget.flipCatchParams?.levelId ?? 1,
      );
    });
  }

  double _calculateWordTimerHeight(List<String> targetWords) {
    final horizontalScreenPadding = 14.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - (horizontalScreenPadding * 2);
    final horizontalPaddingInside = 20.0;
    final verticalPaddingInside = 35.0;
    final topMargin = 40.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: targetWords.join('   '),
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: null,
    );

    textPainter.layout(maxWidth: cardWidth - horizontalPaddingInside * 2);

    final cardHeight = textPainter.height + (verticalPaddingInside * 2) - 10;
    final totalHeight = topMargin + cardHeight + 10;

    // Minimum 280, maximum 700
    return totalHeight.clamp(280.0, 700.0);
  }

  double _calculateWordListHeight(String fullText) {
    final horizontalScreenPadding = 14.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - (horizontalScreenPadding * 2);
    final horizontalPaddingInside = 20.0;
    final verticalPaddingInside = 35.0;
    final topMargin = 30.0;
    final fontSize = 20.0;
    final lineHeight = fontSize * 1.4;

    final words = fullText
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => word.trim())
        .toList();

    final spaceWidth = _calculateSpaceWidth(fontSize);

    double currentX = 0;
    double currentY = 0;
    int lineCount = 1;

    for (int i = 0; i < words.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (currentX + textPainter.width >
              cardWidth - horizontalPaddingInside * 2 &&
          currentX > 0) {
        currentX = 0;
        currentY += lineHeight + 8;
        lineCount++;
      }

      currentX += textPainter.width + spaceWidth;
    }

    final actualContentHeight =
        (lineCount * lineHeight) + ((lineCount - 1) * 8);
    final cardHeight = actualContentHeight + (verticalPaddingInside * 2) + 40;
    final totalHeight = topMargin + cardHeight + 50;

    return totalHeight.clamp(360.0, 800.0);
  }

  double _calculateSpaceWidth(double fontSize) {
    final spacePainter = TextPainter(
      text: TextSpan(
        text: ' ',
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    );
    spacePainter.layout();
    return spacePainter.width + 2;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ),
    );

    final headingText = widget.flipCatchParams?.title ?? '';

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
                          _buildGameStack(state),
                          10.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 30,
                            ),
                            child: CommonHtmlWidget(
                              fontSize: 16,
                              data: state.flipCatchData?.subDescription ?? '',
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
                    description: _getGameStatusDescription(
                        widget.flipCatchParams?.levelId ?? 1),
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

  Widget _buildGameStack(BrainTeaserGameFlipCatchState state) {
    final useWordClick = (widget.flipCatchParams?.levelId ?? 1) <= 5;

    double stackHeight = 240.h;

    if (state.showWordWithTimer && state.currentWord.isNotEmpty) {
      stackHeight =
          _calculateWordTimerHeight(state.flipCatchData?.targetWords ?? []);
    } else if (state.showWordList && state.wordOptions.isNotEmpty) {
      stackHeight = _calculateWordListHeight(state.wordOptions[0]);
    }

    return Container(
      width: double.infinity,
      height: stackHeight,
      margin: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (state.showBoldiWithCloud)
            GameWidget(
              key: const ValueKey('boldi_cloud'),
              game: FlipCatchBoldiCloudOverlayGame(
                width: 330.w,
                height: 330.w,
                cloudText: AppLocalizations.of(context).flip_catch_desc,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          if (state.showWordWithTimer && state.currentWord.isNotEmpty)
            GameWidget(
              key: ValueKey('word_timer_${state.currentWord}'),
              game: _wordTimerGame ??= WordTimerOverlayGame(
                targetWords: state.flipCatchData!.targetWords,
                durationSeconds: state.timerSecond,
                width: MediaQuery.of(context).size.width,
                height: stackHeight,
                timerColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          if (state.showWordList && useWordClick)
            GameWidget(
              key: ValueKey(
                  'game_${state.currentTargetIndex}_${state.selectedWordIndex}_${state.isGamePlayEnabled}'),
              game: WordListOverlayGame(
                fullText: state.wordOptions[0],
                onWordSelected: (index) => _handleWordSelection(index),
                width: MediaQuery.of(context).size.width,
                height: stackHeight,
                background: Colors.white,
                selectedColor: Colors.blue,
                selectedIndex: state.selectedWordIndex,
                isCorrect: state.isAnswerCorrect,
                correctIndex: state.correctWordIndex,
                isEnabled: state.isGamePlayEnabled,
                completedIndices: state.completedTargetIndices,
                currentTargetIndex: state.currentTargetIndex ?? 0,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          if (state.showWordList && !useWordClick)
            DragSelectTextWidget(
              key: _dragSelectKey,
              fullText: state.wordOptions[0],
              onWordSelected: (text, start, end) {
                _handleDragSelection(text, start, end);
              },
              onShowConfirmationDialog: (text, start, end) {
                _showSelectionConfirmationDialog(text, start, end);
              },
              selectedStartIndex: state.selectedStartIndex,
              selectedEndIndex: state.selectedEndIndex,
              isCorrect: state.isAnswerCorrect,
              correctStartIndex: state.correctStartIndex,
              correctEndIndex: state.correctEndIndex,
              isEnabled: state.isGamePlayEnabled,
              completedRanges: state.completedRanges,
              textColor:
                  Theme.of(context).textTheme.bodyLarge!.color ?? Colors.blue,
            ),
        ],
      ),
    );
  }

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;

    final controller = ref.read(
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ).notifier,
    );

    final state = ref.read(
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ),
    );

    switch (state.gameStageConstant) {
      case GameStageConstant.initial:
        await controller.startGame();
        break;

      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;

      case GameStageConstant.abort:
        _wordTimerGame?.stopTimer();
        _wordTimerGame = null;

        await controller.restartGame(
          widget.flipCatchParams?.gameId ?? 1,
          widget.flipCatchParams?.levelId ?? 1,
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
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
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

  Future<void> _showSelectionConfirmationDialog(
      String selectedText, int startIndex, int endIndex) async {
    if (!mounted) return;
    _pendingSelectedText = selectedText;
    _pendingStartIndex = startIndex;
    _pendingEndIndex = endIndex;
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).confirm_selection,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textRegularPoppins(
                text: AppLocalizations.of(context).selected_text,
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
              8.verticalSpace,
              // ✅ Wrap container in ConstrainedBox + SingleChildScrollView
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.h, // ✅ Maximum height
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: textSemiBoldPoppins(
                      text: selectedText,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textOverflow: TextOverflow.visible,
                      // ✅ Show all text
                      maxLines: null, // ✅ Unlimited lines
                    ),
                  ),
                ),
              ),
              12.verticalSpace,
              textRegularPoppins(
                text: AppLocalizations.of(context).selected_desc,
                textAlign: TextAlign.center,
                textOverflow: TextOverflow.visible,
                fontSize: 12,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              _dragSelectKey.currentState?.clearTempSelection();
              _pendingSelectedText = null;
              _pendingStartIndex = null;
              _pendingEndIndex = null;
              if (mounted) {
                ref.read(navigationProvider).removeDialog(context: context);
              }
            },
            isDestructiveAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).no,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (mounted) {
                ref.read(navigationProvider).removeDialog(context: context);
                if (_pendingSelectedText != null &&
                    _pendingStartIndex != null &&
                    _pendingEndIndex != null) {
                  _handleDragSelection(_pendingSelectedText!,
                      _pendingStartIndex!, _pendingEndIndex!);
                }
                _pendingSelectedText = null;
                _pendingStartIndex = null;
                _pendingEndIndex = null;
              }
            },
            isDefaultAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).yes,
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
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ).notifier,
    );
    _wordTimerGame?.pauseTimer();
    controller.pauseGameTimer();

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).abort_flip_catch,
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
              _wordTimerGame?.resumeTimer();
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
                brainTeaserGameFlipCatchControllerProvider(
                  widget.flipCatchParams?.levelId ?? 1,
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

    String text = ((widget.flipCatchParams?.levelId ?? 4) == 4 ||
            (widget.flipCatchParams?.levelId ?? 4) == 5)
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
                        widget.flipCatchParams?.gameId ?? 1,
                      ).notifier,
                    )
                    .fetchBrainTeaserGameDetails(
                      gameId: widget.flipCatchParams?.gameId ?? 1,
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

  void _handleDragSelection(String selectedText, int start, int end) {
    if (!mounted) return;
    final controller = ref.read(
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ).notifier,
    );

    controller.checkAnswerByCharRange(selectedText, start, end);
  }

  void _handleWordSelection(int index) {
    if (!mounted) return;
    final controller = ref.read(
      brainTeaserGameFlipCatchControllerProvider(
        widget.flipCatchParams?.levelId ?? 1,
      ).notifier,
    );
    controller.checkAnswer(index);
  }

  String _getGameStatusDescription(int levelId) {
    switch (levelId) {
      case 4:
        return AppLocalizations.of(context).successful_game_desc_for_level_1;
      case 5:
        return AppLocalizations.of(context).successful_game_desc_for_level_2;
      case 6:
        return AppLocalizations.of(context).successful_game_desc_for_level_3;
      default:
        return "Great effort! Keep pushing your limits.";
    }
  }

  @override
  void dispose() {
    _wordTimerGame?.stopTimer();
    _wordTimerGame = null;
    super.dispose();
  }
}
