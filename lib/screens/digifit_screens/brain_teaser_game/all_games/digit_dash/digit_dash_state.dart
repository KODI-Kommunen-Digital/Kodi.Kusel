import 'package:domain/model/response_model/digifit/brain_teaser_game/digit_dash_response_model.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/enum/game_session_status.dart';

class BrainTeaserGameDigitDashState {
  final bool isLoading;
  final String? errorMessage;
  final DigitDashData? digitDashData;
  final GameStageConstant gameStageConstant;

  final int timerSecond;
  final bool isGamePlayEnabled;

  final bool showBoldiWithCloud;
  final bool showForbiddenDialog;
  final bool showGrid;
  final bool showResult;

  final List<int?>? gridNumbers;
  final List<double>? gridAngles;
  final List<bool>? markedCorrect;
  final List<bool>? markedWrong;

  final int currentExpectedNumber;
  final int? selectedIndex;
  final bool? isAnswerCorrect;
  final int totalGridSize;

  final bool isTimerPaused;

  final int maxTimerSeconds;

  const BrainTeaserGameDigitDashState(
      {required this.isLoading,
      required this.errorMessage,
      required this.digitDashData,
      required this.gameStageConstant,
      required this.timerSecond,
      required this.isGamePlayEnabled,
      required this.showBoldiWithCloud,
      required this.showForbiddenDialog,
      required this.showGrid,
      required this.showResult,
      this.gridNumbers,
      this.gridAngles,
      this.markedCorrect,
      this.markedWrong,
      required this.currentExpectedNumber,
      this.selectedIndex,
      this.isAnswerCorrect,
      required this.totalGridSize,
      required this.isTimerPaused,
      required this.maxTimerSeconds});

  factory BrainTeaserGameDigitDashState.empty() {
    return const BrainTeaserGameDigitDashState(
      isLoading: false,
      errorMessage: null,
      digitDashData: null,
      timerSecond: 5,
      gameStageConstant: GameStageConstant.initial,
      isGamePlayEnabled: false,
      showBoldiWithCloud: true,
      showForbiddenDialog: false,
      showGrid: false,
      showResult: false,
      gridNumbers: null,
      gridAngles: null,
      markedCorrect: null,
      markedWrong: null,
      currentExpectedNumber: 0,
      selectedIndex: null,
      isAnswerCorrect: null,
      totalGridSize: 0,
      isTimerPaused: false,
      maxTimerSeconds: 5,
    );
  }

  BrainTeaserGameDigitDashState copyWith({
    bool? isLoading,
    String? errorMessage,
    DigitDashData? digitDashData,
    int? timerSecond,
    GameStageConstant? gameStageConstant,
    bool? isGamePlayEnabled,
    bool? showBoldiWithCloud,
    bool? showForbiddenDialog,
    bool? showGrid,
    bool? showResult,
    List<int?>? gridNumbers,
    List<double>? gridAngles,
    List<bool>? markedCorrect,
    List<bool>? markedWrong,
    int? currentExpectedNumber,
    int? selectedIndex,
    bool? isAnswerCorrect,
    int? totalGridSize,
    bool clearSelection = false,
    bool? isTimerPaused,
    int? maxTimerSeconds,
  }) {
    return BrainTeaserGameDigitDashState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      digitDashData: digitDashData ?? this.digitDashData,
      timerSecond: timerSecond ?? this.timerSecond,
      gameStageConstant: gameStageConstant ?? this.gameStageConstant,
      isGamePlayEnabled: isGamePlayEnabled ?? this.isGamePlayEnabled,
      showBoldiWithCloud: showBoldiWithCloud ?? this.showBoldiWithCloud,
      showForbiddenDialog: showForbiddenDialog ?? this.showForbiddenDialog,
      showGrid: showGrid ?? this.showGrid,
      showResult: showResult ?? this.showResult,
      gridNumbers: gridNumbers ?? this.gridNumbers,
      gridAngles: gridAngles ?? this.gridAngles,
      markedCorrect: markedCorrect ?? this.markedCorrect,
      markedWrong: markedWrong ?? this.markedWrong,
      currentExpectedNumber:
          currentExpectedNumber ?? this.currentExpectedNumber,
      selectedIndex:
          clearSelection ? null : (selectedIndex ?? this.selectedIndex),
      isAnswerCorrect:
          clearSelection ? null : (isAnswerCorrect ?? this.isAnswerCorrect),
      totalGridSize: totalGridSize ?? this.totalGridSize,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      maxTimerSeconds: maxTimerSeconds ?? this.maxTimerSeconds,
    );
  }

  bool get hasGameData => digitDashData != null;

  bool get canStartGame =>
      gameStageConstant == GameStageConstant.initial && hasGameData;

  bool get canSelectNumber => showGrid && isGamePlayEnabled;

  int? get sessionId => digitDashData?.sessionId;

  int get rows => digitDashData?.grid.row ?? 0;

  int get cols => digitDashData?.grid.col ?? 0;

  int get initialNumber => digitDashData?.initial ?? 0;

  String? get targetCondition => digitDashData?.targetCondition;

  List<int> get forbiddenNumbers => digitDashData?.forbiddenNumbers ?? [];

  bool get isGameComplete {
    if (markedCorrect == null || markedCorrect!.isEmpty) return false;
    return markedCorrect!.every((marked) => marked == true);
  }

  BrainTeaserGameDigitDashState resetToInitial() {
    return copyWith(
      gameStageConstant: GameStageConstant.initial,
      isGamePlayEnabled: false,
      showBoldiWithCloud: true,
      showForbiddenDialog: false,
      showGrid: false,
      showResult: false,
      clearSelection: true,
      gridNumbers: null,
      gridAngles: null,
      markedCorrect: null,
      markedWrong: null,
      currentExpectedNumber: digitDashData?.initial ?? 0,
      selectedIndex: null,
      isAnswerCorrect: null,
      timerSecond: digitDashData?.timer ?? 5,
      maxTimerSeconds: digitDashData?.timer ?? 5,
    );
  }
}
