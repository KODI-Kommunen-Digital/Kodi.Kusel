import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/boldi_finder_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:kusel/matomo_api.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';

import '../../../../../locale/localization_manager.dart';
import '../../../../../providers/refresh_token_provider.dart';
import '../../enum/game_session_status.dart';
import 'boldi_finder_state.dart';

final brainTeaserGameBoldiFinderControllerProvider =
    StateNotifierProvider.autoDispose.family<
        BrainTeaserGameBoldiFinderController,
        BrainTeaserGameBoldiFinderState,
        int>(
  (ref, levelId) => BrainTeaserGameBoldiFinderController(
    brainTeaserGameBoldiFinderUseCase:
        ref.read(brainTeaserGamesUseCaseProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenProvider: ref.read(refreshTokenProvider),
    levelId: levelId,
    localeManagerController: ref.read(
      localeManagerProvider.notifier,
    ),
    brainTeaserGameDetailsTrackingUseCase:
        ref.read(brainTeaserGameDetailsTrackingUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class BrainTeaserGameBoldiFinderController
    extends StateNotifier<BrainTeaserGameBoldiFinderState> {
  final BrainTeaserGamesUseCase brainTeaserGameBoldiFinderUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final int levelId;
  final LocaleManagerController localeManagerController;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  bool _isSequencePaused = false;
  bool _shouldStopSequence = false;
  final SharedPreferenceHelper sharedPreferenceHelper;

  BrainTeaserGameBoldiFinderController({
    required this.brainTeaserGameBoldiFinderUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.levelId,
    required this.localeManagerController,
    required this.brainTeaserGameDetailsTrackingUseCase,
    required this.sharedPreferenceHelper
  }) : super(BrainTeaserGameBoldiFinderState.empty());

  Future<void> fetchGameData({
    required int gameId,
    required int levelId,
  }) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true);

    try {
      await _executeWithTokenValidation(
        onExecute: () => _fetchBrainTeaserGameBoldiFinder(gameId, levelId),
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

  void pauseGame() {
    if (!mounted) return;
    _isSequencePaused = true;
    state = state.copyWith(isSequencePaused: true);
  }

  void resumeGame() {
    if (!mounted) return;
    _isSequencePaused = false;
    state = state.copyWith(isSequencePaused: false);
  }

  Future<void> restartGame(int gameId, int levelId) async {
    if (!mounted) return;

    _resetSequenceFlags();
    state = state.resetToInitial();
    await fetchGameData(gameId: gameId, levelId: levelId);
  }

  Future<void> startGame() async {
    if (!mounted || !state.canStartGame) return;

    try {
      _resetSequenceFlags();

      state = state.copyWith(
        gameStage: GameStageConstant.progress,
        isSequencePaused: false,
        isGamePlayEnabled: false,
        showBoldi: false,
        showResult: false,
        clearAnswerResult: true,
      );

      await _waitWithStopCheck(const Duration(seconds: 1));
      if (_shouldStopSequence) return;

      // Show arrow sequence
      await _showArrowSequence();
      if (_shouldStopSequence) return;

      // Show pause icon
      await _showPauseIcon();
      if (_shouldStopSequence) return;

      // Enable gameplay
      _enableGamePlay();
    } catch (e) {
      _handleError('startGame', e);
    }
  }

  Future<void> checkAnswer(int row, int column) async {
    if (!mounted || !state.canPlayGame) return;

    state = state.copyWith(
      isGamePlayEnabled: false,
      isLoading: true,
    );

    final finalPosition = state.gameData?.finalPosition;
    final finalRow = finalPosition?.row ?? -1;
    final finalCol = finalPosition?.col ?? -1;

    final isCorrect = (row == finalRow && column == finalCol);
    final status =
        isCorrect ? GameStageConstant.complete : GameStageConstant.abort;

    try {
      await trackGameProgress(
        status,
        onSuccess: () {
          if (mounted) {
            _showAnswerResult(row, column, finalRow, finalCol, isCorrect);
          }
          MatomoService.trackDigifitGamePlayed(
              userId: sharedPreferenceHelper.getInt(userIdKey).toString());
        },
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          isGamePlayEnabled: true,
          errorMessage: 'Failed to submit answer. Please try again.',
        );
        MatomoService.trackDigifitGamePlayed(
            userId: sharedPreferenceHelper.getInt(userIdKey).toString());
      }
      _handleError('checkAnswer', e);
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
      if (gameStage == GameStageConstant.abort) {
        _stopSequenceImmediately();
        state = state.hideAllOverlays().copyWith(
              isSequencePaused: true,
              gameStage: gameStage,
            );
      } else {
        state = state.copyWith(
          isSequencePaused: true,
          gameStage: gameStage,
          isLoading: true,
        );
      }

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

  Future<void> _fetchBrainTeaserGameBoldiFinder(
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

      final result = await brainTeaserGameBoldiFinderUseCase.call(
        requestModel,
        BoldiFinderResponseModel(),
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

          final data = (response as BoldiFinderResponseModel).data;
          final rows = data?.grid?.row ?? 5;
          final columns = data?.grid?.col ?? 5;

          state = state.copyWith(
            isLoading: false,
            gameData: data,
            gameStage: GameStageConstant.initial,
            rows: rows,
            columns: columns,
            timerSeconds: data?.timer ?? 3,
          );

          await _showBoldiInitial();
        },
      );
    } catch (e) {
      _handleError('_fetchBrainTeaserGameBoldiFinder', e);
    }
  }

  Future<void> _showBoldiInitial() async {
    if (!mounted) return;

    final startPos = state.gameData?.startPosition;
    if (startPos == null) return;

    final row = startPos.row ?? 0;
    final col = startPos.col ?? 0;

    state = state.copyWith(
      showBoldi: true,
      boldiRow: row,
      boldiCol: col,
      gameStage: GameStageConstant.initial,
      isGamePlayEnabled: false,
    );
  }

  Future<void> _showArrowSequence() async {
    if (!mounted) return;

    final steps = state.gameData?.steps ?? [];
    final timerSeconds = state.gameData?.timer ?? 3;

    for (int i = 0; i < steps.length; i++) {
      await _waitWhilePaused();
      if (_shouldStopSequence) return;

      if (i > 0) {
        state = state.copyWith(
          showArrow: false,
          clearArrowDirection: true,
        );

        await _waitWithStopCheck(const Duration(milliseconds: 150));
        if (_shouldStopSequence) return;
      }

      state = state.copyWith(
        showArrow: true,
        currentArrowDirection: steps[i],
        arrowDisplayIndex: i,
      );

      await _waitWithStopCheck(Duration(seconds: timerSeconds));
      if (_shouldStopSequence) return;
    }

    await _waitWhilePaused();
    if (_shouldStopSequence) return;

    state = state.copyWith(
      showArrow: false,
      clearArrowDirection: true,
    );
  }

  Future<void> _showPauseIcon() async {
    if (!mounted) return;

    await _waitWhilePaused();
    if (_shouldStopSequence) return;

    state = state.copyWith(showPause: true);

    await _waitWithStopCheck(const Duration(seconds: 1));
    if (_shouldStopSequence) return;

    state = state.copyWith(showPause: false);
  }

  void _enableGamePlay() {
    if (!mounted) return;

    state = state.copyWith(
      isGamePlayEnabled: true,
      gameStage: GameStageConstant.progress,
    );
  }

  void _showAnswerResult(
    int selectedRow,
    int selectedCol,
    int correctRow,
    int correctCol,
    bool isCorrect,
  ) {
    if (!mounted) return;

    state = state.copyWith(
      isLoading: false,
      showBoldi: false,
      showArrow: false,
      showPause: false,
      showResult: true,
      selectedRow: selectedRow,
      selectedCol: selectedCol,
      correctRow: correctRow,
      correctCol: correctCol,
      isAnswerCorrect: isCorrect,
      gameStage:
          isCorrect ? GameStageConstant.complete : GameStageConstant.abort,
    );
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

  Future<void> _waitWhilePaused() async {
    while (_isSequencePaused && !_shouldStopSequence) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _waitWithStopCheck(Duration duration) async {
    final iterations = duration.inMilliseconds ~/ 100;
    for (int i = 0; i < iterations; i++) {
      await _waitWhilePaused();
      if (_shouldStopSequence) return;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _resetSequenceFlags() {
    _isSequencePaused = false;
    _shouldStopSequence = false;
  }

  void _stopSequenceImmediately() {
    _shouldStopSequence = true;
    _isSequencePaused = true;
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
}
