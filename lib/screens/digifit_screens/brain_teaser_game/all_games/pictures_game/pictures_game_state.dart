import 'package:domain/model/response_model/digifit/brain_teaser_game/pictures_game_response_model.dart';
import '../../enum/game_session_status.dart';

class PicturesGameState {
  final bool isLoading;
  final PicturesGameData? gameData;
  final GameStageConstant gameStage;
  final int rows;
  final int columns;
  final int timerSeconds;
  final String? errorMessage;

  final bool isGamePlayEnabled;
  final List<RevealedCell> revealedCells;

  // Selection state (Level 1)
  final int? firstSelectedRow;
  final int? firstSelectedCol;
  final String? firstSelectedImageId;

  // Level 2 specific states
  final GamePhase gamePhase;
  final int currentPairIndex;
  final bool showMemorizePair;
  final bool showCheckPair;
  final bool memorizationComplete;
  final int? userAnswer;

  // Level 3 specific states
  final bool showLevel3Dialog;
  final bool level3TimerComplete;
  final int? selectedImageId;
  final bool level3Completed;

  // Store the missing cell position when game loads
  final int? cachedMissingRow;
  final int? cachedMissingCol;

  final bool showResult;
  final bool? isAnswerCorrect;
  final int? wrongRow;
  final int? wrongCol;
  final int? wrongRow2;
  final int? wrongCol2;

  final int maxTimerSeconds;
  final bool isTimerPaused;

  final bool isImageLoading;

  PicturesGameState({
    required this.isLoading,
    required this.gameData,
    required this.gameStage,
    required this.rows,
    required this.columns,
    required this.timerSeconds,
    this.errorMessage,
    required this.isGamePlayEnabled,
    required this.revealedCells,
    this.firstSelectedRow,
    this.firstSelectedCol,
    this.firstSelectedImageId,
    required this.gamePhase,
    required this.currentPairIndex,
    required this.showMemorizePair,
    required this.showCheckPair,
    required this.memorizationComplete,
    this.userAnswer,
    required this.showLevel3Dialog,
    required this.level3TimerComplete,
    this.selectedImageId,
    required this.level3Completed,
    this.cachedMissingRow,
    this.cachedMissingCol,
    required this.showResult,
    this.isAnswerCorrect,
    this.wrongRow,
    this.wrongCol,
    this.wrongRow2,
    this.wrongCol2,
    required this.maxTimerSeconds,
    required this.isTimerPaused,
    required this.isImageLoading,
  });

  factory PicturesGameState.empty() {
    return PicturesGameState(
      isLoading: false,
      gameData: null,
      gameStage: GameStageConstant.initial,
      rows: 4,
      columns: 4,
      timerSeconds: 5,
      isGamePlayEnabled: false,
      revealedCells: [],
      gamePhase: GamePhase.memorize,
      currentPairIndex: 0,
      showMemorizePair: false,
      showCheckPair: false,
      memorizationComplete: false,
      showLevel3Dialog: false,
      level3TimerComplete: false,
      level3Completed: false,
      showResult: false,
      maxTimerSeconds: 60,
      isTimerPaused: false,
      isImageLoading: false,
    );
  }

  int? get sessionId => gameData?.sessionId;

  bool get isInitialStage => gameStage == GameStageConstant.initial;

  bool get isGameInProgress => gameStage == GameStageConstant.progress;

  bool get canStartGame {
    if (isLevel2) {
      return gameStage == GameStageConstant.initial &&
          !isLoading &&
          memorizationComplete;
    }
    return gameStage == GameStageConstant.initial && !isLoading;
  }

  bool get canPlayGame => isGamePlayEnabled && !isLoading;

  bool get hasFirstSelection =>
      firstSelectedRow != null && firstSelectedCol != null;

  bool get isLevel2 =>
      gameData?.memorizePairs != null && gameData!.memorizePairs!.isNotEmpty;

  bool get isLevel3 =>
      gameData?.allImagesList != null &&
      gameData!.allImagesList!.isNotEmpty &&
      gameData?.displayImagesList != null &&
      gameData!.displayImagesList!.isNotEmpty &&
      gameData?.missingImageList != null &&
      gameData!.missingImageList!.isNotEmpty;

  int? get missingImageRow {
    if (cachedMissingRow != null) return cachedMissingRow;

    if (!isLevel3 || gameData?.displayImagesList == null || columns == 0) {
      return null;
    }

    final displayList = gameData!.displayImagesList!;
    for (int i = 0; i < displayList.length; i++) {
      final img = displayList[i].image;
      if (img == null ||
          img.isEmpty ||
          img == 'admin/games/picturegame/empty.png') {
        return i ~/ columns;
      }
    }
    return null;
  }

  int? get missingImageCol {
    if (cachedMissingCol != null) return cachedMissingCol;

    if (!isLevel3 || gameData?.displayImagesList == null || columns == 0) {
      return null;
    }

    final displayList = gameData!.displayImagesList!;
    for (int i = 0; i < displayList.length; i++) {
      final img = displayList[i].image;
      if (img == null ||
          img.isEmpty ||
          img == 'admin/games/picturegame/empty.png') {
        return i % columns;
      }
    }
    return null;
  }

  bool get isMemorizePhase => gamePhase == GamePhase.memorize;

  bool get isCheckPhase => gamePhase == GamePhase.check;

  bool isCellRevealed(int row, int col) {
    return revealedCells.any((cell) => cell.row == row && cell.col == col);
  }

  PicturesGameState copyWith({
    bool? isLoading,
    PicturesGameData? gameData,
    GameStageConstant? gameStage,
    int? rows,
    int? columns,
    int? timerSeconds,
    String? errorMessage,
    bool? isGamePlayEnabled,
    List<RevealedCell>? revealedCells,
    int? firstSelectedRow,
    int? firstSelectedCol,
    String? firstSelectedImageId,
    GamePhase? gamePhase,
    int? currentPairIndex,
    bool? showMemorizePair,
    bool? showCheckPair,
    bool? memorizationComplete,
    int? userAnswer,
    bool? showLevel3Dialog,
    bool? level3TimerComplete,
    int? selectedImageId,
    bool? level3Completed,
    int? cachedMissingRow,
    int? cachedMissingCol,
    bool? showResult,
    bool? isAnswerCorrect,
    int? wrongRow,
    int? wrongCol,
    int? wrongRow2,
    int? wrongCol2,
    bool clearFirstSelection = false,
    bool clearResult = false,
    bool clearUserAnswer = false,
    int? maxTimerSeconds,
    bool? isTimerPaused,
    bool? isImageLoading,
  }) {
    return PicturesGameState(
      isLoading: isLoading ?? this.isLoading,
      gameData: gameData ?? this.gameData,
      gameStage: gameStage ?? this.gameStage,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
      isGamePlayEnabled: isGamePlayEnabled ?? this.isGamePlayEnabled,
      revealedCells: revealedCells ?? this.revealedCells,
      firstSelectedRow: clearFirstSelection
          ? null
          : (firstSelectedRow ?? this.firstSelectedRow),
      firstSelectedCol: clearFirstSelection
          ? null
          : (firstSelectedCol ?? this.firstSelectedCol),
      firstSelectedImageId: clearFirstSelection
          ? null
          : (firstSelectedImageId ?? this.firstSelectedImageId),
      gamePhase: gamePhase ?? this.gamePhase,
      currentPairIndex: currentPairIndex ?? this.currentPairIndex,
      showMemorizePair: showMemorizePair ?? this.showMemorizePair,
      showCheckPair: showCheckPair ?? this.showCheckPair,
      memorizationComplete: memorizationComplete ?? this.memorizationComplete,
      userAnswer: clearUserAnswer ? null : (userAnswer ?? this.userAnswer),
      showLevel3Dialog: showLevel3Dialog ?? this.showLevel3Dialog,
      level3TimerComplete: level3TimerComplete ?? this.level3TimerComplete,
      selectedImageId: selectedImageId ?? this.selectedImageId,
      level3Completed: level3Completed ?? this.level3Completed,
      cachedMissingRow: cachedMissingRow ?? this.cachedMissingRow,
      cachedMissingCol: cachedMissingCol ?? this.cachedMissingCol,
      showResult: showResult ?? this.showResult,
      isAnswerCorrect:
          clearResult ? null : (isAnswerCorrect ?? this.isAnswerCorrect),
      wrongRow: clearResult ? null : (wrongRow ?? this.wrongRow),
      wrongCol: clearResult ? null : (wrongCol ?? this.wrongCol),
      wrongRow2: clearResult ? null : (wrongRow2 ?? this.wrongRow2),
      wrongCol2: clearResult ? null : (wrongCol2 ?? this.wrongCol2),
      maxTimerSeconds: maxTimerSeconds ?? this.maxTimerSeconds,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      isImageLoading: isImageLoading ?? this.isImageLoading,
    );
  }

  PicturesGameState resetToInitial() {
    return PicturesGameState(
      isLoading: true,
      gameData: null,
      gameStage: GameStageConstant.initial,
      rows: rows,
      columns: columns,
      timerSeconds: timerSeconds,
      isGamePlayEnabled: false,
      revealedCells: [],
      gamePhase: GamePhase.memorize,
      currentPairIndex: 0,
      showMemorizePair: false,
      showCheckPair: false,
      memorizationComplete: false,
      showLevel3Dialog: false,
      level3TimerComplete: false,
      level3Completed: false,
      showResult: false,
      maxTimerSeconds: maxTimerSeconds,
      isTimerPaused: false,
      isImageLoading: false,
    );
  }
}

enum GamePhase {
  memorize,
  check,
}

class RevealedCell {
  final int row;
  final int col;
  final String imageId;

  RevealedCell({
    required this.row,
    required this.col,
    required this.imageId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RevealedCell && other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
