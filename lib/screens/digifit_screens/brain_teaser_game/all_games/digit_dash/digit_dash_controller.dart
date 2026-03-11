import 'dart:async';
import 'dart:math';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/digit_dash_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';

import '../../../../../locale/localization_manager.dart';
import '../../../../../providers/refresh_token_provider.dart';
import '../../enum/game_session_status.dart';
import 'digit_dash_state.dart';

final brainTeaserGameDigitDashControllerProvider =
    StateNotifierProvider.autoDispose.family<BrainTeaserGameDigitDashController,
        BrainTeaserGameDigitDashState, int>(
  (ref, levelId) => BrainTeaserGameDigitDashController(
    brainTeaserGameDigitDashUseCase: ref.read(brainTeaserGamesUseCaseProvider),
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

class BrainTeaserGameDigitDashController
    extends StateNotifier<BrainTeaserGameDigitDashState> {
  final BrainTeaserGamesUseCase brainTeaserGameDigitDashUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final int levelId;
  final LocaleManagerController localeManagerController;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  bool _isProcessingTap = false;
  Timer? _gameTimer;

  BrainTeaserGameDigitDashController({
    required this.brainTeaserGameDigitDashUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.levelId,
    required this.localeManagerController,
    required this.brainTeaserGameDetailsTrackingUseCase,
  }) : super(BrainTeaserGameDigitDashState.empty());

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void pauseGameTimer() {
    if (!mounted) return;
    state = state.copyWith(isTimerPaused: true);
  }

  void resumeGameTimer() {
    if (!mounted) return;
    state = state.copyWith(isTimerPaused: false);
  }

  void _stopGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  void _startGameTimer() {
    _gameTimer?.cancel();

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (state.isTimerPaused) {
        return;
      }

      final newTime = state.timerSecond - 1;

      if (newTime <= 0) {
        timer.cancel();

        state = state.copyWith(
          timerSecond: 0,
          isGamePlayEnabled: false,
          isLoading: true,
        );

        trackGameProgress(
          GameStageConstant.abort,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                isLoading: false,
                showResult: true,
                gameStageConstant: GameStageConstant.abort,
                timerSecond: 0,
              );
            }
          },
        );
      } else {
        state = state.copyWith(timerSecond: newTime);
      }
    });
  }

  Future<void> fetchGameData({
    required int gameId,
    required int levelId,
  }) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true);

    try {
      await _executeWithTokenValidation(
        onExecute: () => _fetchBrainTeaserGameDigitDash(gameId, levelId),
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

  Future<void> _fetchBrainTeaserGameDigitDash(
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

      final result = await brainTeaserGameDigitDashUseCase.call(
        requestModel,
        DigitDashResponseModel(),
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

          final data = (response as DigitDashResponseModel).data;
          final timerValue = data?.timer ?? 60;

          state = state.copyWith(
            isLoading: false,
            digitDashData: data,
            timerSecond: timerValue,
            maxTimerSeconds: timerValue,
            currentExpectedNumber: data?.initial ?? 0,
          );
        },
      );
    } catch (e) {
      _handleError('_fetchBrainTeaserGameDigitDash', e);
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
      final rows = state.rows;
      final cols = state.cols;
      final totalSize = rows * cols;
      final initialNumber = state.initialNumber;

      List<int> numbers = List.generate(
        totalSize,
        (index) => initialNumber + index,
      );

      numbers.shuffle(Random());

      final List<double> possibleRotations = [
        0,
        pi / 4,
        pi / 2,
        2 * pi / 3,
        pi,
        3 * pi / 2,
      ];

      List<double> gridAngles = List.generate(
        totalSize,
        (index) {
          final number = numbers[index];

          if (number == 6 || number == 9) {
            return 0.0;
          }

          return possibleRotations[Random().nextInt(possibleRotations.length)];
        },
      );

      List<bool> markedCorrect = List.filled(totalSize, false);
      List<bool> markedWrong = List.filled(totalSize, false);

      state = state.copyWith(
        gameStageConstant: GameStageConstant.progress,
        showBoldiWithCloud: false,
        isGamePlayEnabled: false,
        isTimerPaused: false,
        gridNumbers: numbers,
        gridAngles: gridAngles,
        markedCorrect: markedCorrect,
        markedWrong: markedWrong,
        totalGridSize: totalSize,
      );

      if (levelId == 11) {
        final cond = state.targetCondition?.toLowerCase() ?? '';
        int expected = state.currentExpectedNumber;

        if (cond.contains('odd') && expected % 2 == 0) {
          expected += 1;
        } else if (cond.contains('even') && expected % 2 != 0) {
          expected += 1;
        }

        state = state.copyWith(currentExpectedNumber: expected);
      }

      state = state.copyWith(
        showGrid: true,
        isGamePlayEnabled: true,
      );

      _startGameTimer();
    } catch (e) {
      _handleError('startGame', e);
    }
  }

  Future<void> checkAnswer(int selectedIndex) async {
    if (!mounted || !state.canSelectNumber || _isProcessingTap) return;
    if (state.selectedIndex != null) return;

    _isProcessingTap = true;

    final selectedNumber = state.gridNumbers![selectedIndex];
    if (selectedNumber == null) {
      _isProcessingTap = false;
      return;
    }

    bool isCorrect = false;

    if (levelId == 10) {
      isCorrect = selectedNumber == state.currentExpectedNumber;
    } else if (levelId == 11) {
      final condition = state.targetCondition
              ?.toLowerCase()
              .replaceAll(' ', '_')
              .replaceAll('-', '_') ??
          '';

      final currentExpected = state.currentExpectedNumber;
      bool matchesCondition = false;
      int nextExpected = currentExpected;

      if (condition.contains('odd')) {
        matchesCondition = selectedNumber % 2 != 0;
        nextExpected = currentExpected + 2;
      } else if (condition.contains('even')) {
        matchesCondition = selectedNumber % 2 == 0;
        nextExpected = currentExpected + 2;
      }

      isCorrect = matchesCondition && selectedNumber == currentExpected;

      if (isCorrect) {
        state = state.copyWith(currentExpectedNumber: nextExpected);
      }
    } else if (levelId == 12) {
      final forbidden = state.forbiddenNumbers;
      final currentExpected = state.currentExpectedNumber;
      final selected = selectedNumber;

      int validExpected = currentExpected;
      while (forbidden.contains(validExpected)) {
        validExpected++;
      }

      isCorrect = selected == validExpected && !forbidden.contains(selected);

      if (isCorrect) {
        int nextExpected = validExpected + 1;
        while (forbidden.contains(nextExpected)) {
          nextExpected++;
        }
        state = state.copyWith(currentExpectedNumber: nextExpected);
      }
    }

    List<bool> newMarkedCorrect = List.from(state.markedCorrect!);
    List<bool> newMarkedWrong = List.from(state.markedWrong!);

    if (isCorrect) {
      newMarkedCorrect[selectedIndex] = true;
    } else {
      newMarkedWrong[selectedIndex] = true;
    }

    state = state.copyWith(
      isGamePlayEnabled: false,
      selectedIndex: selectedIndex,
      isAnswerCorrect: isCorrect,
      markedCorrect: newMarkedCorrect,
      markedWrong: newMarkedWrong,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      _isProcessingTap = false;
      return;
    }

    if (isCorrect) {
      if (levelId == 10) {
        state = state.copyWith(
          currentExpectedNumber: state.currentExpectedNumber + 1,
        );
      }

      final maxNumber =
          (state.gridNumbers?.reduce((a, b) => a! > b! ? a : b)) ?? 0;

      if (state.currentExpectedNumber > maxNumber) {
        _stopGameTimer();
        state = state.copyWith(isLoading: true);
        await trackGameProgress(
          GameStageConstant.complete,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                isLoading: false,
                showResult: true,
                gameStageConstant: GameStageConstant.complete,
              );
            }
          },
        );
      } else {
        state = state.copyWith(clearSelection: true, isGamePlayEnabled: true);
      }
    } else {
      _stopGameTimer();
      state = state.copyWith(isLoading: true);
      await trackGameProgress(
        GameStageConstant.abort,
        onSuccess: () {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              showResult: true,
              gameStageConstant: GameStageConstant.abort,
            );
          }
        },
      );
    }

    _isProcessingTap = false;
  }

  Future<void> restartGame(int gameId, int levelId) async {
    if (!mounted) return;
    _isProcessingTap = false;
    _stopGameTimer();
    state = state.resetToInitial();
    await fetchGameData(gameId: gameId, levelId: levelId);
  }
}
