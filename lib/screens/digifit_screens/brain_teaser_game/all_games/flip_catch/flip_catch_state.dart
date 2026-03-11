import 'package:domain/model/response_model/digifit/brain_teaser_game/flip_catch_response_model.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/enum/game_session_status.dart';

class BrainTeaserGameFlipCatchState {
  final bool isLoading;
  final String? errorMessage;
  final FlipCatchData? flipCatchData;
  final GameStageConstant gameStageConstant;

  final int timerSecond;
  final bool isGamePlayEnabled;

  final bool showBoldiWithCloud;
  final bool showWordWithTimer;
  final bool showWordList;
  final bool showResult;

  final List<String> currentWord;
  final List<String> wordOptions;
  final int? selectedWordIndex;
  final bool? isAnswerCorrect;
  final int? correctWordIndex;
  final int? currentRound;

  final int? currentTargetIndex;

  final List<int>? completedTargetIndices;

  // Changed from word indices to character ranges
  final int? selectedStartIndex;
  final int? selectedEndIndex;
  final int? correctStartIndex;
  final int? correctEndIndex;

  // Completed ranges instead of word indices
  final List<Map<String, int>>? completedRanges;

  final bool isTimerPaused;

  const BrainTeaserGameFlipCatchState(
      {required this.isLoading,
      required this.errorMessage,
      required this.flipCatchData,
      required this.gameStageConstant,
      required this.timerSecond,
      required this.isGamePlayEnabled,
      required this.showBoldiWithCloud,
      required this.showWordWithTimer,
      required this.showWordList,
      required this.showResult,
      required this.currentWord,
      required this.wordOptions,
      this.selectedWordIndex,
      this.isAnswerCorrect,
      this.correctWordIndex,
      this.currentRound,
      this.currentTargetIndex,
      this.completedTargetIndices,
      this.selectedStartIndex,
      this.selectedEndIndex,
      this.correctStartIndex,
      this.correctEndIndex,
      this.completedRanges,
      required this.isTimerPaused});

  factory BrainTeaserGameFlipCatchState.empty() {
    return const BrainTeaserGameFlipCatchState(
        isLoading: false,
        errorMessage: null,
        flipCatchData: null,
        timerSecond: 5,
        gameStageConstant: GameStageConstant.initial,
        isGamePlayEnabled: false,
        showBoldiWithCloud: true,
        showWordWithTimer: false,
        showWordList: false,
        showResult: false,
        currentWord: [],
        wordOptions: [],
        selectedWordIndex: null,
        isAnswerCorrect: null,
        correctWordIndex: null,
        currentRound: 0,
        currentTargetIndex: 0,
        completedTargetIndices: [],
        selectedStartIndex: null,
        selectedEndIndex: null,
        correctStartIndex: null,
        correctEndIndex: null,
        completedRanges: [],
        isTimerPaused: false);
  }

  BrainTeaserGameFlipCatchState copyWith(
      {bool? isLoading,
      String? errorMessage,
      FlipCatchData? flipCatchData,
      int? timerSecond,
      GameStageConstant? gameStageConstant,
      bool? isGamePlayEnabled,
      bool? showBoldiWithCloud,
      bool? showWordWithTimer,
      bool? showWordList,
      bool? showResult,
      List<String>? currentWord,
      List<String>? wordOptions,
      int? selectedWordIndex,
      bool? isAnswerCorrect,
      int? correctWordIndex,
      bool clearError = false,
      bool clearSelection = false,
      int? currentRound,
      int? currentTargetIndex,
      List<int>? completedTargetIndices,
      int? selectedStartIndex,
      int? selectedEndIndex,
      int? correctStartIndex,
      int? correctEndIndex,
      List<Map<String, int>>? completedRanges,
      bool? isTimerPaused}) {
    return BrainTeaserGameFlipCatchState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        flipCatchData: flipCatchData ?? this.flipCatchData,
        timerSecond: timerSecond ?? this.timerSecond,
        gameStageConstant: gameStageConstant ?? this.gameStageConstant,
        isGamePlayEnabled: isGamePlayEnabled ?? this.isGamePlayEnabled,
        showBoldiWithCloud: showBoldiWithCloud ?? this.showBoldiWithCloud,
        showWordWithTimer: showWordWithTimer ?? this.showWordWithTimer,
        showWordList: showWordList ?? this.showWordList,
        showResult: showResult ?? this.showResult,
        currentWord: currentWord ?? this.currentWord,
        wordOptions: wordOptions ?? this.wordOptions,
        selectedWordIndex: clearSelection
            ? null
            : (selectedWordIndex ?? this.selectedWordIndex),
        isAnswerCorrect:
            clearSelection ? null : (isAnswerCorrect ?? this.isAnswerCorrect),
        correctWordIndex:
            clearSelection ? null : (correctWordIndex ?? this.correctWordIndex),
        currentRound: currentRound ?? this.currentRound,
        currentTargetIndex: currentTargetIndex ?? this.currentTargetIndex,
        completedTargetIndices:
            completedTargetIndices ?? this.completedTargetIndices,
        selectedStartIndex: clearSelection
            ? null
            : (selectedStartIndex ?? this.selectedStartIndex),
        selectedEndIndex:
            clearSelection ? null : (selectedEndIndex ?? this.selectedEndIndex),
        correctStartIndex: clearSelection
            ? null
            : (correctStartIndex ?? this.correctStartIndex),
        correctEndIndex:
            clearSelection ? null : (correctEndIndex ?? this.correctEndIndex),
        completedRanges: completedRanges ?? this.completedRanges,
        isTimerPaused: isTimerPaused ?? this.isTimerPaused);
  }

  bool get hasGameData => flipCatchData != null;

  bool get canStartGame =>
      flipCatchData == GameStageConstant.initial && hasGameData;

  bool get canSelectWord => showWordList && isGamePlayEnabled;

  int? get sessionId => flipCatchData?.sessionId;

  BrainTeaserGameFlipCatchState resetToInitial() {
    return copyWith(
        gameStageConstant: GameStageConstant.initial,
        isGamePlayEnabled: false,
        showBoldiWithCloud: true,
        showWordWithTimer: false,
        showWordList: false,
        showResult: false,
        clearSelection: true,
        currentTargetIndex: 0,
        completedRanges: [],
        completedTargetIndices: [],
        currentRound: 0,
        isAnswerCorrect: null,
        correctWordIndex: null,
        correctStartIndex: null,
        correctEndIndex: null,
        selectedStartIndex: null,
        selectedEndIndex: null,
        selectedWordIndex: null,
        wordOptions: [],
        currentWord: [],
        timerSecond: 5);
  }
}
