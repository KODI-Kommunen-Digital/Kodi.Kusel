import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/math_hunt_response_model.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../locale/localization_manager.dart';
import '../../../../../providers/refresh_token_provider.dart';
import '../../enum/game_session_status.dart';
import 'math_hunt_state.dart';

final brainTeaserGameMathHuntControllerProvider =
    StateNotifierProvider.autoDispose.family<BrainTeaserGameMathHuntController,
            BrainTeaserGameMathHuntState, int>(
        (ref, levelId) => BrainTeaserGameMathHuntController(
            brainTeaserGameMathHuntUseCase:
                ref.read(brainTeaserGamesUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            levelId: levelId,
            localeManagerController: ref.read(
              localeManagerProvider.notifier,
            ),
            brainTeaserGameDetailsTrackingUseCase:
                ref.read(brainTeaserGameDetailsTrackingUseCaseProvider)));

class BrainTeaserGameMathHuntController
    extends StateNotifier<BrainTeaserGameMathHuntState> {
  final BrainTeaserGamesUseCase brainTeaserGameMathHuntUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  int levelId;
  final LocaleManagerController localeManagerController;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  bool _shouldStopSequence = false;
  bool _isSequencePaused = false;

  BrainTeaserGameMathHuntController({
    required this.brainTeaserGameMathHuntUseCase,
    required this.refreshTokenProvider,
    required this.tokenStatus,
    required this.levelId,
    required this.localeManagerController,
    required this.brainTeaserGameDetailsTrackingUseCase,
  }) : super(BrainTeaserGameMathHuntState.empty());

  @override
  void dispose() {
    _stopSequence();
    super.dispose();
  }

  Future<void> fetchBrainTeaserGameMathHunt({
    required int gameId,
    required int levelId,
    VoidCallback? onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await _executeWithTokenValidation(
        onExecute: () =>
            _fetchBrainTeaserGameMathHunt(gameId, levelId, onSuccess),
        onError: () {
          if (mounted) state = state.copyWith(isLoading: false);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[MathHuntController] Fetch Exception: $e');
    }
  }

  Future<void> _fetchBrainTeaserGameMathHunt(
    int gameId,
    int levelId,
    VoidCallback? onSuccess,
  ) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final requestModel = AllGamesRequestModel(
          gameId: gameId,
          levelId: levelId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      final responseModel = MathHuntResponseModel();

      final result = await brainTeaserGameMathHuntUseCase.call(
          requestModel, responseModel);

      result.fold(
        (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          );
        },
        (response) {
          var data = (response as MathHuntResponseModel).data;
          state = state.copyWith(
            isLoading: false,
            mathHuntDataModel: data,
            gameStage: GameStageConstant.initial,
            currentProblem: '',
            showProblem: true,
            showOptions: false,
            showTimer: false,
            sessionId: data?.sessionId ?? 0,
            currentPhase: -1,
            isAnswerCorrect: null,
            showResult: false,
            selectedAnswerIndex: null,
          );

          onSuccess?.call();
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[MathHuntController] Fetch Error: $e');
    }
  }

  bool get canStartGame => state.gameStage == GameStageConstant.initial;

  Future<void> startGame() async {
    if (!mounted || !canStartGame) return;

    try {
      _resetSequenceFlags();

      final problems = state.mathHuntDataModel?.problem ?? [];
      if (problems.isEmpty) return;

      state = state.copyWith(
        gameStage: GameStageConstant.progress,
        isSequencePaused: false,
        showResult: false,
        isAnswerCorrect: null,
        selectedAnswerIndex: null,
        currentPhase: 0,
        currentProblem: problems[0],
        showOptions: false,
        showProblem: true,
        showTimer: true,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      if (_shouldStopSequence) return;

      await _showProblemSequence();
      if (_shouldStopSequence) return;

      _showOptions();
    } catch (e) {
      _handleError('startGame', e);
    }
  }

  Future<void> _showProblemSequence() async {
    if (!mounted) return;

    final problems = state.mathHuntDataModel?.problem ?? [];
    final timerSeconds = state.mathHuntDataModel?.timer ?? 4;

    for (int i = 0; i < problems.length; i++) {
      if (_shouldStopSequence) {
        return;
      }

      await _waitWhilePaused();
      if (_shouldStopSequence) return;

      state = state.copyWith(
        currentPhase: i,
        currentProblem: problems[i],
        showProblem: true,
        showTimer: true,
      );

      await _waitWithStopCheck(Duration(seconds: timerSeconds));

      if (_shouldStopSequence) {
        return;
      }
    }

    await _waitWhilePaused();
    if (_shouldStopSequence) return;

    state = state.copyWith(
      showProblem: false,
      showTimer: false,
    );
  }

  void _showOptions() {
    if (!mounted) return;

    state = state.copyWith(
      showOptions: true,
      showProblem: false,
      showTimer: false,
      gameStage: GameStageConstant.progress,
      isAnswerCorrect: null,
      selectedAnswerIndex: null,
    );
  }

  Future<void> handleOptionSelected(int selectedOptionIndex) async {
    if (!mounted || state.gameStage != GameStageConstant.progress) return;

    final options = state.mathHuntDataModel?.options ?? [];
    if (selectedOptionIndex < 0 || selectedOptionIndex >= options.length) {
      return;
    }

    final selectedOption = options[selectedOptionIndex];
    final correctAnswerRaw = state.mathHuntDataModel?.correctAnswer;
    final String correctAnswer = _convertToString(correctAnswerRaw);
    final isCorrect = selectedOption.trim() == correctAnswer.trim();
    final status =
        isCorrect ? GameStageConstant.complete : GameStageConstant.abort;

    state = state.copyWith(
      isAnswerCorrect: isCorrect,
      selectedAnswerIndex: selectedOptionIndex,
      correctAnswer: correctAnswer,
    );

    try {
      await trackGameProgress(
        status,
        onSuccess: () {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              showResult: true,
              gameStage: status,
            );
          }
        },
      );
    } catch (e) {
      _handleError('handleOptionSelected', e);
    }
  }

  String _convertToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  void pauseSequence() {
    if (_isSequencePaused) return;
    _isSequencePaused = true;
    state = state.copyWith(isSequencePaused: true);
  }

  void resumeSequence() {
    if (!_isSequencePaused) return;
    _isSequencePaused = false;
    state = state.copyWith(isSequencePaused: false);
  }

  void _stopSequence() {
    _shouldStopSequence = true;
    _isSequencePaused = false;
  }

  void _resetSequenceFlags() {
    _shouldStopSequence = false;
    _isSequencePaused = false;
  }

  Future<void> _waitWithStopCheck(Duration duration) async {
    final endTime = DateTime.now().add(duration);

    while (DateTime.now().isBefore(endTime)) {
      if (_shouldStopSequence) return;
      await _waitWhilePaused();
      if (_shouldStopSequence) return;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _waitWhilePaused() async {
    while (_isSequencePaused && !_shouldStopSequence) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _handleError(String method, Object error) {
    debugPrint('[MathHuntController] Error in $method: $error');
    if (mounted) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
        gameStage: GameStageConstant.abort,
      );
    }
  }

  Future<void> restartGameWithRefetch({
    required int gameId,
    required int levelId,
    VoidCallback? onSuccess,
  }) async {
    _stopSequence();
    state = BrainTeaserGameMathHuntState.empty();

    await Future.delayed(const Duration(milliseconds: 100));
    await fetchBrainTeaserGameMathHunt(
      gameId: gameId,
      levelId: levelId,
      onSuccess: onSuccess,
    );
  }

  Future<void> trackGameProgress(
    GameStageConstant gameStage, {
    VoidCallback? onSuccess,
  }) async {
    if (!mounted) return;

    final sessionId = state.sessionId;
    if (sessionId == 0) return;

    try {
      if (gameStage == GameStageConstant.abort) {
        _stopSequence();
      }

      state = state.copyWith(isLoading: true);

      await _executeWithTokenValidation(
        onExecute: () => _trackGameDetails(sessionId, gameStage, onSuccess),
        onError: () {
          if (mounted) state = state.copyWith(isLoading: false);
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

  Future<void> _trackGameDetails(
    int sessionId,
    GameStageConstant gameStage,
    VoidCallback? onSuccess,
  ) async {
    if (!mounted) return;

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
}
