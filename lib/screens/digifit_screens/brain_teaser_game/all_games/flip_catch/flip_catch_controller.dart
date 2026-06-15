import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/flip_catch_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';

import '../../../../../locale/localization_manager.dart';
import '../../../../../providers/refresh_token_provider.dart';
import '../../enum/game_session_status.dart';
import 'flip_catch_state.dart';

final brainTeaserGameFlipCatchControllerProvider =
    StateNotifierProvider.autoDispose.family<
        BrainTeaserGameFlipCatchFinderController,
        BrainTeaserGameFlipCatchState,
        int>(
  (ref, levelId) => BrainTeaserGameFlipCatchFinderController(
    brainTeaserGameFlipCatchUseCase: ref.read(brainTeaserGamesUseCaseProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenProvider: ref.read(refreshTokenProvider),
    levelId: levelId,
    localeManagerController: ref.read(
      localeManagerProvider.notifier,
    ),
    brainTeaserGameDetailsTrackingUseCase:
        ref.read(brainTeaserGameDetailsTrackingUseCaseProvider),
  ),
);

class BrainTeaserGameFlipCatchFinderController
    extends StateNotifier<BrainTeaserGameFlipCatchState> {
  final BrainTeaserGamesUseCase brainTeaserGameFlipCatchUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final int levelId;
  final LocaleManagerController localeManagerController;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  BrainTeaserGameFlipCatchFinderController({
    required this.brainTeaserGameFlipCatchUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.levelId,
    required this.localeManagerController,
    required this.brainTeaserGameDetailsTrackingUseCase,
  }) : super(BrainTeaserGameFlipCatchState.empty());

  void pauseGameTimer() {
    if (!mounted) return;
    state = state.copyWith(isTimerPaused: true);
  }

  void resumeGameTimer() {
    if (!mounted) return;
    state = state.copyWith(isTimerPaused: false);
  }

  Future<void> fetchGameData({
    required int gameId,
    required int levelId,
  }) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true);

    try {
      await _executeWithTokenValidation(
        onExecute: () => _fetchBrainTeaserGameFlipCatch(gameId, levelId),
        onError: () {
          if (mounted) {
            state = state.copyWith(isLoading: false);
          }
        },
      );
    } catch (e) {
      _handleError('fetchGameData', e);
    }
  }

  Future<void> _executeWithTokenValidation({
    required Future<void> Function() onExecute,
    required VoidCallback onError,
  }) async {
    final isTokenExpired = tokenStatus.isAccessTokenExpired();

    if (isTokenExpired) {
      await refreshTokenProvider.getNewToken(
        onError: onError,
        onSuccess: onExecute,
      );
    } else {
      await onExecute();
    }
  }

  void _handleError(String methodName, dynamic error) {
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: error.toString(),
    );
  }

  Future<void> _fetchBrainTeaserGameFlipCatch(
    int gameId,
    int levelId,
  ) async {
    if (!mounted) return;

    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final requestModel = AllGamesRequestModel(
          gameId: gameId,
          levelId: levelId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final result = await brainTeaserGameFlipCatchUseCase.call(
        requestModel,
        FlipCatchResponseModel(),
      );

      result.fold(
        (error) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: error.toString(),
            );
          }
        },
        (response) async {
          if (!mounted) return;

          final data = (response as FlipCatchResponseModel).data;
          state = state.copyWith(timerSecond: data?.timer ?? 1);

          state = state.copyWith(
            isLoading: false,
            flipCatchData: data,
          );
        },
      );
    } catch (e) {
      _handleError('_fetchBrainTeaserGameFlipCatch', e);
    }
  }

  Future<void> trackGameProgress(
    GameStageConstant gameStage, {
    VoidCallback? onSuccess,
  }) async {
    if (!mounted) return;

    final sessionId = state.sessionId;
    if (sessionId == null) {
      return;
    }

    try {
      state = state.copyWith(
        gameStageConstant: gameStage,
        isLoading: true,
      );

      await _executeWithTokenValidation(
        onExecute: () => _trackGameDetails(sessionId, gameStage, onSuccess),
        onError: () {
          if (mounted) {
            state = state.copyWith(isLoading: false);
          }
        },
      );
    } catch (e) {
      _handleError('trackGameProgress', e);
    }
  }

  Future<void> _trackGameDetails(
    int sessionId,
    GameStageConstant gameStage,
    VoidCallback? onSuccess,
  ) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true);
    try {
      final requestModel = GamesTrackerRequestModel(
        sessionId: sessionId,
        activityStatus: gameStage.name,
      );

      final result = await brainTeaserGameDetailsTrackingUseCase.call(
        requestModel,
        GamesTrackerResponseModel(),
      );

      result.fold(
        (error) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: error.toString(),
            );
          }
        },
        (response) {
          if (mounted) {
            state = state.copyWith(isLoading: false);
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      _handleError('_trackGameDetails', e);
    }
  }

  Future<void> startGame() async {
    if (!mounted) return;

    try {
      state = state.copyWith(
        gameStageConstant: GameStageConstant.progress,
        showBoldiWithCloud: false,
        isGamePlayEnabled: false,
        isTimerPaused: false,
      );

      state = state.copyWith(
        showWordWithTimer: true,
        currentWord: state.flipCatchData?.targetWords ?? [],
      );

      double elapsedSeconds = 0.0;
      final targetDuration = state.timerSecond.toDouble();
      const checkInterval = 100;

      while (mounted && elapsedSeconds < targetDuration) {
        if (state.gameStageConstant == GameStageConstant.abort) {
          return;
        }

        if (state.isTimerPaused) {
          while (state.isTimerPaused && mounted) {
            await Future.delayed(const Duration(milliseconds: checkInterval));

            if (state.gameStageConstant == GameStageConstant.abort) {
              return;
            }
          }

          continue;
        }

        await Future.delayed(const Duration(milliseconds: checkInterval));
        elapsedSeconds += checkInterval / 1000.0;
      }

      if (!mounted || state.gameStageConstant != GameStageConstant.progress) {
        return;
      }

      state = state.copyWith(
        showWordWithTimer: false,
        showWordList: true,
        isGamePlayEnabled: true,
        wordOptions: state.flipCatchData?.originalText ?? [],
      );
    } catch (e) {
      _handleError('startGame', e);
    }
  }

  Future<void> checkAnswer(int selectedIndex) async {
    if (!mounted || !state.canSelectWord) return;

    if (state.selectedWordIndex != null) return;

    final fullText = state.wordOptions.isNotEmpty ? state.wordOptions[0] : '';
    final words = fullText
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => word.trim())
        .toList();

    state = state.copyWith(
      isGamePlayEnabled: false,
      selectedWordIndex: selectedIndex,
    );

    final targetWordsList = state.flipCatchData?.targetWords ?? [];
    final currentTargetIndex = state.currentTargetIndex ?? 0;
    final hasMultipleTargets = targetWordsList.length > 1;

    String targetWord = '';
    if (targetWordsList.isNotEmpty &&
        currentTargetIndex < targetWordsList.length) {
      targetWord = targetWordsList[currentTargetIndex];
    }

    String stripPunctuation(String text) {
      return text.replaceAll(RegExp(r'[^\w\s]'), '');
    }

    int correctIndex = -1;
    final targetLower = stripPunctuation(targetWord.trim()).toLowerCase();

    for (int i = 0; i < words.length; i++) {
      final originalWord = words[i];
      final cleanedWord = stripPunctuation(originalWord.trim()).toLowerCase();
      final reversedWord =
          String.fromCharCodes(cleanedWord.runes.toList().reversed);

      if (cleanedWord == targetLower || reversedWord == targetLower) {
        correctIndex = i;
        break;
      }
    }

    final isCorrect = selectedIndex == correctIndex && correctIndex != -1;

    if (hasMultipleTargets) {
      if (isCorrect) {
        final newTargetIndex = currentTargetIndex + 1;
        final isLastWord = newTargetIndex >= targetWordsList.length;

        if (isLastWord) {
          state = state.copyWith(isLoading: true);

          try {
            await trackGameProgress(
              GameStageConstant.complete,
              onSuccess: () {
                if (mounted) {
                  state = state.copyWith(
                    isLoading: false,
                    showResult: true,
                    selectedWordIndex: selectedIndex,
                    isAnswerCorrect: true,
                    correctWordIndex: correctIndex,
                    gameStageConstant: GameStageConstant.complete,
                    currentTargetIndex: newTargetIndex,
                    completedTargetIndices: [
                      ...?state.completedTargetIndices,
                      correctIndex
                    ],
                  );
                }
              },
            );
          } catch (e) {
            _handleError('checkAnswer - complete', e);
          }
        } else {
          final updatedCompletedIndices = [
            ...?state.completedTargetIndices,
            correctIndex
          ];

          state = state.copyWith(
            selectedWordIndex: selectedIndex,
            isAnswerCorrect: true,
            correctWordIndex: correctIndex,
            showResult: false,
            completedTargetIndices: updatedCompletedIndices,
            isGamePlayEnabled: false,
          );

          await Future.delayed(const Duration(milliseconds: 800));

          if (mounted) {
            state = state.copyWith(
              selectedWordIndex: null,
              isAnswerCorrect: null,
              clearSelection: true,
              correctWordIndex: null,
              currentTargetIndex: newTargetIndex,
              completedTargetIndices: updatedCompletedIndices,
              isGamePlayEnabled: true,
            );
          }
        }
      } else {
        state = state.copyWith(isLoading: true);

        try {
          await trackGameProgress(
            GameStageConstant.abort,
            onSuccess: () {
              if (mounted) {
                state = state.copyWith(
                  isLoading: false,
                  showResult: true,
                  selectedWordIndex: selectedIndex,
                  isAnswerCorrect: false,
                  correctWordIndex: correctIndex,
                  gameStageConstant: GameStageConstant.abort,
                );
              }
            },
          );
        } catch (e) {
          _handleError('checkAnswer - abort', e);
        }
      }
    } else {
      final status =
          isCorrect ? GameStageConstant.complete : GameStageConstant.abort;

      state = state.copyWith(isLoading: true);

      try {
        await trackGameProgress(
          status,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                isLoading: false,
                showResult: true,
                selectedWordIndex: selectedIndex,
                isAnswerCorrect: isCorrect,
                correctWordIndex: correctIndex,
                gameStageConstant: status,
              );
            }
          },
        );
      } catch (e) {
        _handleError('checkAnswer', e);
      }
    }
  }

  Future<void> checkAnswerByCharRange(
      String selectedText, int startIndex, int endIndex) async {
    if (!mounted || !state.canSelectWord) return;

    if (state.selectedStartIndex != null) {
      return;
    }

    final targetWordsList = state.flipCatchData?.targetWords ?? [];
    final currentTargetIndex = state.currentTargetIndex ?? 0;

    String targetWord = '';
    if (targetWordsList.isNotEmpty &&
        currentTargetIndex < targetWordsList.length) {
      targetWord = targetWordsList[currentTargetIndex];
    }

    String stripPunctuation(String text) {
      return text.replaceAll(RegExp(r'[^\w]'), '').toLowerCase();
    }

    final selectedClean = stripPunctuation(selectedText);
    final targetClean = stripPunctuation(targetWord);
    final reversedTarget =
        String.fromCharCodes(targetClean.runes.toList().reversed);

    final isCorrect =
        selectedClean == targetClean || selectedClean == reversedTarget;

    int? correctStart;
    int? correctEnd;

    final fullText = state.wordOptions[0];
    final targetLower = targetClean.toLowerCase();

    for (int i = 0; i <= fullText.length - targetLower.length; i++) {
      final substring = fullText.substring(i, i + targetLower.length);
      final substringClean = stripPunctuation(substring).toLowerCase();
      final substringReversed =
          String.fromCharCodes(substringClean.runes.toList().reversed);

      if (substringClean == targetLower || substringReversed == targetLower) {
        correctStart = i;
        correctEnd = i + substring.length - 1;
        break;
      }
    }

    state = state.copyWith(
      isGamePlayEnabled: false,
      selectedStartIndex: startIndex,
      selectedEndIndex: endIndex,
      isAnswerCorrect: isCorrect,
      correctStartIndex: correctStart,
      correctEndIndex: correctEnd,
    );

    if (isCorrect) {
      final newTargetIndex = currentTargetIndex + 1;
      final isLastWord = newTargetIndex >= targetWordsList.length;

      if (isLastWord) {
        state = state.copyWith(isLoading: true);
        await trackGameProgress(GameStageConstant.complete, onSuccess: () {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              showResult: true,
              gameStageConstant: GameStageConstant.complete,
            );
          }
        });
      } else {
        final updatedRanges = [
          ...?state.completedRanges,
          {'start': startIndex, 'end': endIndex}
        ];

        state = state.copyWith(
          completedRanges: updatedRanges,
          isGamePlayEnabled: false,
        );

        await Future.delayed(const Duration(milliseconds: 800));

        if (mounted) {
          state = state.copyWith(
            clearSelection: true,
            currentTargetIndex: newTargetIndex,
            completedRanges: updatedRanges,
            isGamePlayEnabled: true,
          );
        }
      }
    } else {
      state = state.copyWith(isLoading: true);
      await trackGameProgress(GameStageConstant.abort, onSuccess: () {
        if (mounted) {
          state = state.copyWith(
            isLoading: false,
            showResult: true,
            gameStageConstant: GameStageConstant.abort,
          );
        }
      });
    }
  }

  Future<void> restartGame(int gameId, int levelId) async {
    if (!mounted) return;
    state = state.resetToInitial();
    await fetchGameData(gameId: gameId, levelId: levelId);
  }
}
