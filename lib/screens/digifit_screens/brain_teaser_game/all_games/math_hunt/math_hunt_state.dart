import 'package:domain/model/response_model/digifit/brain_teaser_game/math_hunt_response_model.dart';
import '../../enum/game_session_status.dart';

class BrainTeaserGameMathHuntState {
  final bool isLoading;
  final String? errorMessage;
  final MathHuntDataModel? mathHuntDataModel;
  final GameStageConstant gameStage;
  final bool showTimer;
  final int currentPhase;
  final String currentProblem;
  final bool showProblem;
  final bool showOptions;
  final bool showResult;
  final bool? isAnswerCorrect;
  final int? selectedAnswerIndex;
  final String? correctAnswer;
  final int sessionId;
  final bool isSequencePaused;

  const BrainTeaserGameMathHuntState({
    required this.isLoading,
    this.errorMessage,
    this.mathHuntDataModel,
    required this.gameStage,
    required this.currentPhase,
    required this.currentProblem,
    required this.showProblem,
    required this.showOptions,
    required this.showResult,
    this.isAnswerCorrect,
    this.selectedAnswerIndex,
    this.correctAnswer,
    required this.isSequencePaused,
    this.showTimer = false,
    required this.sessionId,
  });

  factory BrainTeaserGameMathHuntState.empty() {
    return const BrainTeaserGameMathHuntState(
      isLoading: false,
      errorMessage: null,
      mathHuntDataModel: null,
      gameStage: GameStageConstant.initial,
      currentPhase: 0,
      currentProblem: '',
      showProblem: true,
      showOptions: false,
      showResult: false,
      isAnswerCorrect: null,
      selectedAnswerIndex: null,
      correctAnswer: null,
      isSequencePaused: false,
      showTimer: false,
      sessionId: 0,
    );
  }

  BrainTeaserGameMathHuntState copyWith({
    bool? isLoading,
    String? errorMessage,
    MathHuntDataModel? mathHuntDataModel,
    GameStageConstant? gameStage,
    int? currentPhase,
    String? currentProblem,
    bool? showProblem,
    bool? showOptions,
    bool? showResult,
    bool? isAnswerCorrect,
    int? selectedAnswerIndex,
    String? correctAnswer,
    bool? isSequencePaused,
    bool? showTimer,
    int? sessionId,
  }) {
    return BrainTeaserGameMathHuntState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      mathHuntDataModel: mathHuntDataModel ?? this.mathHuntDataModel,
      gameStage: gameStage ?? this.gameStage,
      currentPhase: currentPhase ?? this.currentPhase,
      currentProblem: currentProblem ?? this.currentProblem,
      showProblem: showProblem ?? this.showProblem,
      showOptions: showOptions ?? this.showOptions,
      showResult: showResult ?? this.showResult,
      isAnswerCorrect: isAnswerCorrect ?? this.isAnswerCorrect,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isSequencePaused: isSequencePaused ?? this.isSequencePaused,
      showTimer: showTimer ?? this.showTimer,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}
