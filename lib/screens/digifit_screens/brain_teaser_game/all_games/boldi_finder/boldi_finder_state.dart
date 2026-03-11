import 'package:domain/model/response_model/digifit/brain_teaser_game/boldi_finder_response_model.dart';
import '../../enum/game_session_status.dart';

class BrainTeaserGameBoldiFinderState {
  final bool isLoading;
  final String? errorMessage;

  final BoldFinderDataModel? gameData;
  final int rows;
  final int columns;
  final int timerSeconds;

  final GameStageConstant gameStage;
  final bool isGamePlayEnabled;
  final bool isSequencePaused;

  final bool showBoldi;
  final bool showArrow;
  final bool showPause;
  final bool showResult;

  final int? boldiRow;
  final int? boldiCol;
  final String? currentArrowDirection;
  final int arrowDisplayIndex;

  final int? selectedRow;
  final int? selectedCol;
  final int? correctRow;
  final int? correctCol;
  final bool? isAnswerCorrect;

  const BrainTeaserGameBoldiFinderState({
    required this.isLoading,
    this.errorMessage,
    this.gameData,
    required this.rows,
    required this.columns,
    required this.timerSeconds,
    required this.gameStage,
    required this.isGamePlayEnabled,
    required this.isSequencePaused,
    required this.showBoldi,
    required this.showArrow,
    required this.showPause,
    required this.showResult,
    this.boldiRow,
    this.boldiCol,
    this.currentArrowDirection,
    required this.arrowDisplayIndex,
    this.selectedRow,
    this.selectedCol,
    this.correctRow,
    this.correctCol,
    this.isAnswerCorrect,
  });

  factory BrainTeaserGameBoldiFinderState.empty() {
    return const BrainTeaserGameBoldiFinderState(
      isLoading: false,
      errorMessage: null,
      gameData: null,
      rows: 3,
      columns: 3,
      timerSeconds: 3,
      gameStage: GameStageConstant.initial,
      isGamePlayEnabled: false,
      isSequencePaused: false,
      showBoldi: false,
      showArrow: false,
      showPause: false,
      showResult: false,
      boldiRow: null,
      boldiCol: null,
      currentArrowDirection: null,
      arrowDisplayIndex: 0,
      selectedRow: null,
      selectedCol: null,
      correctRow: null,
      correctCol: null,
      isAnswerCorrect: null,
    );
  }

  BrainTeaserGameBoldiFinderState copyWith({
    bool? isLoading,
    String? errorMessage,
    BoldFinderDataModel? gameData,
    int? rows,
    int? columns,
    int? timerSeconds,
    GameStageConstant? gameStage,
    bool? isGamePlayEnabled,
    bool? isSequencePaused,
    bool? showBoldi,
    bool? showArrow,
    bool? showPause,
    bool? showResult,
    int? boldiRow,
    int? boldiCol,
    String? currentArrowDirection,
    int? arrowDisplayIndex,
    int? selectedRow,
    int? selectedCol,
    int? correctRow,
    int? correctCol,
    bool? isAnswerCorrect,
    bool clearError = false,
    bool clearBoldiPosition = false,
    bool clearArrowDirection = false,
    bool clearAnswerResult = false,
  }) {
    return BrainTeaserGameBoldiFinderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      gameData: gameData ?? this.gameData,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      gameStage: gameStage ?? this.gameStage,
      isGamePlayEnabled: isGamePlayEnabled ?? this.isGamePlayEnabled,
      isSequencePaused: isSequencePaused ?? this.isSequencePaused,
      showBoldi: showBoldi ?? this.showBoldi,
      showArrow: showArrow ?? this.showArrow,
      showPause: showPause ?? this.showPause,
      showResult: showResult ?? this.showResult,
      boldiRow: clearBoldiPosition ? null : (boldiRow ?? this.boldiRow),
      boldiCol: clearBoldiPosition ? null : (boldiCol ?? this.boldiCol),
      currentArrowDirection: clearArrowDirection
          ? null
          : (currentArrowDirection ?? this.currentArrowDirection),
      arrowDisplayIndex: arrowDisplayIndex ?? this.arrowDisplayIndex,
      selectedRow: clearAnswerResult ? null : (selectedRow ?? this.selectedRow),
      selectedCol: clearAnswerResult ? null : (selectedCol ?? this.selectedCol),
      correctRow: clearAnswerResult ? null : (correctRow ?? this.correctRow),
      correctCol: clearAnswerResult ? null : (correctCol ?? this.correctCol),
      isAnswerCorrect:
          clearAnswerResult ? null : (isAnswerCorrect ?? this.isAnswerCorrect),
    );
  }

  bool get canPlayGame => isGamePlayEnabled && !isSequencePaused;

  bool get isGameInProgress => gameStage == GameStageConstant.progress;

  bool get isGameCompleted => gameStage == GameStageConstant.complete;

  bool get isGameAborted => gameStage == GameStageConstant.abort;

  bool get isInitialStage => gameStage == GameStageConstant.initial;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  bool get hasBoldiPosition => boldiRow != null && boldiCol != null;

  bool get hasArrowDirection =>
      showArrow &&
      currentArrowDirection != null &&
      currentArrowDirection!.isNotEmpty;

  bool get hasAnswerResult =>
      selectedRow != null && selectedCol != null && isAnswerCorrect != null;

  bool get canStartGame => isInitialStage && !isLoading && gameData != null;

  int? get sessionId => gameData?.sessionId;

  /// Helper to hide all visual overlays
  BrainTeaserGameBoldiFinderState hideAllOverlays() {
    return copyWith(
      showBoldi: false,
      showArrow: false,
      showPause: false,
      showResult: false,
      clearArrowDirection: true,
      clearAnswerResult: true,
    );
  }

  /// Helper to reset game to initial state
  BrainTeaserGameBoldiFinderState resetToInitial() {
    return copyWith(
      isSequencePaused: false,
      showBoldi: false,
      showArrow: false,
      showPause: false,
      showResult: false,
      isGamePlayEnabled: false,
      arrowDisplayIndex: 0,
      gameStage: GameStageConstant.initial,
      clearAnswerResult: true,
      clearArrowDirection: true,
    );
  }
}
