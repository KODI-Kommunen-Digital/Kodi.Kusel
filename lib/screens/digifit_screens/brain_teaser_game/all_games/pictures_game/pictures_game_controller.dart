import 'dart:async';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/pictures_game_response_model.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../../common_widgets/image_utility.dart';
import '../../../../../locale/localization_manager.dart';
import '../../../../../providers/refresh_token_provider.dart';
import '../../enum/game_session_status.dart';
import 'pictures_game_state.dart';

final picturesGameControllerProvider = StateNotifierProvider.autoDispose
    .family<PicturesGameController, PicturesGameState, int>(
  (ref, levelId) => PicturesGameController(
    brainTeaserGamesUseCase: ref.read(brainTeaserGamesUseCaseProvider),
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

class PicturesGameController extends StateNotifier<PicturesGameState> {
  final BrainTeaserGamesUseCase brainTeaserGamesUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final int levelId;
  final LocaleManagerController localeManagerController;
  final BrainTeaserGameDetailsTrackingUseCase
  brainTeaserGameDetailsTrackingUseCase;

  Timer? _memorizePairTimer;
  Timer? _level3Timer;
  Timer? _gameTimer;

  final Set<String> _preloadedUrls = {};
  bool _isPreloadingInBackground = false;

  PicturesGameController({
    required this.brainTeaserGamesUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.levelId,
    required this.localeManagerController,
    required this.brainTeaserGameDetailsTrackingUseCase,
  }) : super(PicturesGameState.empty());

  @override
  void dispose() {
    _memorizePairTimer?.cancel();
    _level3Timer?.cancel();
    _gameTimer?.cancel();
    _preloadedUrls.clear();
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

      final newTime = state.timerSeconds - 1;

      if (newTime <= 0) {
        timer.cancel();

        state = state.copyWith(
          timerSeconds: 0,
          isGamePlayEnabled: false,
        );

        trackGameProgress(
          GameStageConstant.abort,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                isLoading: false,
                showResult: true,
                gameStage: GameStageConstant.abort,
                timerSeconds: 0,
              );
            }
          },
        );
      } else {
        state = state.copyWith(timerSeconds: newTime);
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
        onExecute: () => _fetchPicturesGame(gameId, levelId),
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

  Future<void> restartGame(int gameId, int levelId) async {
    if (!mounted) return;

    _memorizePairTimer?.cancel();
    _level3Timer?.cancel();
    _stopGameTimer();
    state = state.resetToInitial();
    await fetchGameData(gameId: gameId, levelId: levelId);
  }

  Future<void> startGame() async {
    if (!mounted) return;

    if (state.isLevel3) {
      state = state.copyWith(
        gameStage: GameStageConstant.progress,
        isGamePlayEnabled: true,
        showLevel3Dialog: false,
        level3TimerComplete: false,
      );

      _level3Timer?.cancel();
    } else if (state.isLevel2) {
      if (!state.memorizationComplete) {
        return;
      }

      _memorizePairTimer?.cancel();
      _startGameTimer();
      _startCheckPhase();
    } else {
      if (!state.canStartGame) return;

      state = state.copyWith(
        gameStage: GameStageConstant.progress,
        isGamePlayEnabled: true,
        revealedCells: [],
        showResult: false,
        clearFirstSelection: true,
        clearResult: true,
      );

      _startGameTimer();
    }
  }


  Future<void> handleLevel3GridTap() async {
    if (!mounted || !state.isLevel3 || !state.isGameInProgress) return;

    state = state.copyWith(
      showLevel3Dialog: true,
      level3TimerComplete: true,
      isLoading: false,
    );
  }


  Future<void> handleLevel3ImageSelection(int selectedImageId) async {
    if (!mounted || !state.isLevel3) return;

    final missingImageList = state.gameData?.missingImageList ?? [];
    if (missingImageList.isEmpty) return;

    final missingImageId = missingImageList.first.id;

    state = state.copyWith(
      selectedImageId: selectedImageId,
      showLevel3Dialog: false,
    );

    final isMatch = selectedImageId.toString() == missingImageId.toString();

    final missingRow = state.missingImageRow;
    final missingCol = state.missingImageCol;

    if (isMatch) {
      if (missingRow != null && missingCol != null) {
        final displayList = state.gameData?.displayImagesList ?? [];
        final List<RevealedCell> allRevealedCells = [];

        for (int i = 0; i < displayList.length; i++) {
          final displayImage = displayList[i];
          final row = i ~/ state.columns;
          final col = i % state.columns;

          if (row == missingRow && col == missingCol) {
            continue;
          }

          if (displayImage.image != null &&
              displayImage.image!.isNotEmpty &&
              displayImage.image != 'admin/games/picturegame/empty.png') {
            allRevealedCells.add(
              RevealedCell(
                row: row,
                col: col,
                imageId: displayImage.id.toString(),
              ),
            );
          }
        }

        allRevealedCells.add(
          RevealedCell(
            row: missingRow,
            col: missingCol,
            imageId: selectedImageId.toString(),
          ),
        );

        state = state.copyWith(
          revealedCells: allRevealedCells,
          level3Completed: true,
          isLoading: false,
          showResult: false,
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          state = state.copyWith(
            showResult: true,
            isAnswerCorrect: true,
            gameStage: GameStageConstant.complete,
          );
        }

        if (mounted) {
          _trackLevel3SuccessBackground();
        }
      }
    } else {
      final displayList = state.gameData?.displayImagesList ?? [];
      final List<RevealedCell> displayRevealedCells = [];

      for (int i = 0; i < displayList.length; i++) {
        final displayImage = displayList[i];
        final row = i ~/ state.columns;
        final col = i % state.columns;

        if (row == missingRow && col == missingCol) {
          continue;
        }

        if (displayImage.image != null &&
            displayImage.image!.isNotEmpty &&
            displayImage.image != 'admin/games/picturegame/empty.png') {
          displayRevealedCells.add(
            RevealedCell(
              row: row,
              col: col,
              imageId: displayImage.id.toString(),
            ),
          );
        }
      }

      state = state.copyWith(
        revealedCells: displayRevealedCells,
        isAnswerCorrect: false,
        wrongRow: missingRow,
        wrongCol: missingCol,
        isLoading: false,
        showResult: false,
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        state = state.copyWith(
          showResult: true,
          gameStage: GameStageConstant.abort,
          isLoading: false,
        );
      }

      if (mounted) {
        _trackLevel3WrongAnswerBackground();
      }
    }
  }

  Future<void> _trackLevel3SuccessBackground() async {
    if (!mounted) return;

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    try {
      await _executeWithTokenValidation(
        onExecute: () =>
            _trackGameDetailsQuiet(
              sessionId,
              GameStageConstant.complete,
            ),
        onError: () {
          debugPrint('Background tracking error');
        },
      );
    } catch (e) {
      debugPrint('Error in _trackLevel3SuccessBackground: $e');
    }
  }

  Future<void> _trackLevel3WrongAnswerBackground() async {
    if (!mounted) return;

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    try {
      await _executeWithTokenValidation(
        onExecute: () =>
            _trackGameDetailsQuiet(
              sessionId,
              GameStageConstant.abort,
            ),
        onError: () {
          debugPrint('Background tracking error');
        },
      );
    } catch (e) {
      debugPrint('Error in _trackLevel3WrongAnswerBackground: $e');
    }
  }

  Future<void> _trackGameDetailsQuiet(int sessionId,
      GameStageConstant gameStage,) async {
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
          debugPrint('Tracking error: $error');
        },
            (response) {
          debugPrint('Tracking success');
        },
      );
    } catch (e) {
      debugPrint('Error in _trackGameDetailsQuiet: $e');
    }
  }


  Future<void> _preloadAllPairImages() async {
    final memorizePairs = state.gameData?.memorizePairs ?? [];
    final checkPairs = state.gameData?.checkPairs ?? [];
    final cacheManager = DefaultCacheManager();

    if (memorizePairs.isEmpty) return;

    try {
      state = state.copyWith(isLoading: true);

      final initialPairsToLoad = memorizePairs.take(2).toList();

      for (var pair in initialPairsToLoad) {
        await _preloadPairImages(pair, cacheManager);
      }

      state = state.copyWith(isLoading: false);

      if (memorizePairs.length > 2 || checkPairs.isNotEmpty) {
        _preloadRemainingImagesInBackground(
          memorizePairs,
          checkPairs,
          cacheManager,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _preloadPairImages(
    dynamic pair,
    DefaultCacheManager cacheManager,
  ) async {
    try {
      if (pair.image1 != null && pair.image1!.isNotEmpty) {
        final url1 = ImageUtil.getProcessedImageUrl(
          imageUrl: pair.image1!,
          sourceId: 1,
        );

        if (!_preloadedUrls.contains(url1)) {
          await cacheManager.getSingleFile(url1);
          _preloadedUrls.add(url1);
        }
      }

      if (pair.image2 != null && pair.image2!.isNotEmpty) {
        final url2 = ImageUtil.getProcessedImageUrl(
          imageUrl: pair.image2!,
          sourceId: 1,
        );

        if (!_preloadedUrls.contains(url2)) {
          await cacheManager.getSingleFile(url2);
          _preloadedUrls.add(url2);
        }
      }
    } catch (e) {
      debugPrint('Error loading pair: $e');
    }
  }

  void _preloadRemainingImagesInBackground(
    List<dynamic> memorizePairs,
    List<dynamic> checkPairs,
    DefaultCacheManager cacheManager,
  ) {
    if (_isPreloadingInBackground) return;

    _isPreloadingInBackground = true;

    Future.microtask(() async {
      try {
        if (memorizePairs.length > 2) {
          final remainingMemorizePairs = memorizePairs.skip(2).toList();

          for (var pair in remainingMemorizePairs) {
            if (!mounted) break;
            await _preloadPairImages(pair, cacheManager);
          }
        }

        if (checkPairs.isNotEmpty) {
          for (var pair in checkPairs) {
            if (!mounted) break;
            await _preloadPairImages(pair, cacheManager);
          }
        }
      } catch (e) {
        debugPrint('Error in background preloading: $e');
      } finally {
        _isPreloadingInBackground = false;
      }
    });
  }

  Future<void> _startMemorizePhase() async {
    if (!mounted) return;

    final memorizePairs = state.gameData?.memorizePairs ?? [];
    if (memorizePairs.isEmpty) return;

    state = state.copyWith(
      gameStage: GameStageConstant.initial,
      gamePhase: GamePhase.memorize,
      currentPairIndex: 0,
      showMemorizePair: true,
      showCheckPair: false,
      isGamePlayEnabled: false,
    );

    _showNextMemorizePair();
  }

  void _showNextMemorizePair() {
    if (!mounted) return;

    final memorizePairs = state.gameData?.memorizePairs ?? [];
    final currentIndex = state.currentPairIndex;

    if (currentIndex >= memorizePairs.length) {
      _memorizePairTimer?.cancel();
      state = state.copyWith(
        showMemorizePair: true,
        currentPairIndex: memorizePairs.length - 1,
        memorizationComplete: true,
      );
      return;
    }

    state = state.copyWith(
      showMemorizePair: true,
      currentPairIndex: currentIndex,
    );

    _memorizePairTimer?.cancel();
    _memorizePairTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      state = state.copyWith(
        currentPairIndex: currentIndex + 1,
      );

      _showNextMemorizePair();
    });
  }

  void _startCheckPhase() {
    if (!mounted) return;

    state = state.copyWith(
      gameStage: GameStageConstant.progress,
      gamePhase: GamePhase.check,
      currentPairIndex: 0,
      showMemorizePair: false,
      showCheckPair: true,
      isGamePlayEnabled: true,
    );
  }

  Future<void> handleUserAnswer(bool userAnswer) async {
    if (!mounted || !state.canPlayGame || !state.isCheckPhase) return;

    final checkPairs = state.gameData?.checkPairs ?? [];
    final currentIndex = state.currentPairIndex;

    if (currentIndex >= checkPairs.length) return;

    final currentPair = checkPairs[currentIndex];
    final isCorrect = currentPair.isCorrect ?? false;

    state = state.copyWith(isGamePlayEnabled: false);

    if (userAnswer == isCorrect) {
      final nextIndex = currentIndex + 1;

      if (nextIndex >= checkPairs.length) {
        _stopGameTimer();

        await trackGameProgress(
          GameStageConstant.complete,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                showResult: true,
                isAnswerCorrect: true,
                gameStage: GameStageConstant.complete,
                showCheckPair: true,
              );
            }
          },
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          state = state.copyWith(
            currentPairIndex: nextIndex,
            isGamePlayEnabled: true,
          );
        }
      }
    } else {
      _stopGameTimer();

      await trackGameProgress(
        GameStageConstant.abort,
        onSuccess: () {
          if (mounted) {
            state = state.copyWith(
              showResult: true,
              isAnswerCorrect: false,
              gameStage: GameStageConstant.abort,
            );
          }
        },
      );
    }
  }

  Future<void> handleCellTap(int row, int col) async {
    if (!mounted) {
      return;
    }

    if (state.isLevel3) {
      final missingRow = state.missingImageRow;
      final missingCol = state.missingImageCol;

      if (row == missingRow && col == missingCol) {
        await handleLevel3GridTap();
      }
      return;
    }

    if (state.isLevel2) {
      return;
    }

    if (!state.canPlayGame) {
      return;
    }

    if (state.isCellRevealed(row, col)) {
      return;
    }

    final pictureGrid = state.gameData?.pictureGrid ?? [];
    if (pictureGrid.isEmpty) return;

    final index = row * state.columns + col;
    if (index >= pictureGrid.length) return;

    final tappedImageId = pictureGrid[index].id?.toString() ?? '';

    if (!state.hasFirstSelection) {
      final updatedRevealed = List<RevealedCell>.from(state.revealedCells);
      updatedRevealed.add(RevealedCell(
        row: row,
        col: col,
        imageId: tappedImageId,
      ));

      state = state.copyWith(
        firstSelectedRow: row,
        firstSelectedCol: col,
        firstSelectedImageId: tappedImageId,
        revealedCells: updatedRevealed,
      );
      return;
    }

    final firstImageId = state.firstSelectedImageId ?? '';
    final isMatch = firstImageId == tappedImageId;

    if (isMatch) {
      final updatedRevealed = List<RevealedCell>.from(state.revealedCells);
      updatedRevealed.add(RevealedCell(
        row: row,
        col: col,
        imageId: tappedImageId,
      ));

      state = state.copyWith(
        revealedCells: updatedRevealed,
        clearFirstSelection: true,
      );

      final totalCells = state.rows * state.columns;
      if (updatedRevealed.length == totalCells) {
        _stopGameTimer();

        await trackGameProgress(
          GameStageConstant.complete,
          onSuccess: () {
            if (mounted) {
              state = state.copyWith(
                showResult: true,
                isAnswerCorrect: true,
                gameStage: GameStageConstant.complete,
                isGamePlayEnabled: false,
              );
            }
          },
        );
      }
    } else {
      final updatedRevealed = List<RevealedCell>.from(state.revealedCells);
      updatedRevealed.add(RevealedCell(
        row: row,
        col: col,
        imageId: tappedImageId,
      ));

      state = state.copyWith(
        revealedCells: updatedRevealed,
        isGamePlayEnabled: false,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      _stopGameTimer();
      state = state.copyWith(isLoading: true);

      await trackGameProgress(
        GameStageConstant.abort,
        onSuccess: () {
          if (mounted) {
            state = state.copyWith(
              showResult: true,
              isAnswerCorrect: false,
              wrongRow: state.firstSelectedRow,
              wrongCol: state.firstSelectedCol,
              wrongRow2: row,
              wrongCol2: col,
              gameStage: GameStageConstant.abort,
              isLoading: false,
            );
          }
        },
      );
    }
  }

  Future<void> trackGameProgress(
    GameStageConstant gameStage, {
    VoidCallback? onSuccess,
  }) async {
    if (!mounted) return;

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    try {
      state = state.copyWith(isLoading: true);

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

  Future<void> _fetchPicturesGame(int gameId, int levelId) async {
    if (!mounted) return;

    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final requestModel = AllGamesRequestModel(
          gameId: gameId,
          levelId: levelId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final result = await brainTeaserGamesUseCase.call(
        requestModel,
        PicturesGameResponseModel(),
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

          final data = (response as PicturesGameResponseModel).data;

          final isLevel3 = data?.allImagesList != null &&
              data!.allImagesList!.isNotEmpty &&
              data.displayImagesList != null &&
              data.displayImagesList!.isNotEmpty &&
              data.missingImageList != null &&
              data.missingImageList!.isNotEmpty;

          final isLevel2 =
              data?.memorizePairs != null && data!.memorizePairs!.isNotEmpty;

          final timerValue = data?.timer ?? 60;

          int? cachedRow;
          int? cachedCol;
          if (isLevel3 && data.displayImagesList != null) {
            final displayList = data.displayImagesList!;
            final gridRows = data.grid?.row ?? 0;
            final gridCols = data.grid?.col ?? 0;

            for (int i = 0; i < displayList.length; i++) {
              final img = displayList[i].image;
              if (img == null ||
                  img.isEmpty ||
                  img == 'admin/games/picturegame/empty.png') {
                cachedRow = i ~/ gridCols;
                cachedCol = i % gridCols;
                break;
              }
            }
          }

          state = state.copyWith(
            isLoading: false,
            gameData: data,
            gameStage: GameStageConstant.initial,
            rows: data?.grid?.row,
            columns: data?.grid?.col,
            timerSeconds: timerValue,
            maxTimerSeconds: timerValue,
            gamePhase: GamePhase.memorize,
            currentPairIndex: 0,
            showMemorizePair: isLevel2 ? true : false,
            showCheckPair: false,
            showLevel3Dialog: false,
            level3TimerComplete: false,
            level3Completed: false,
            cachedMissingRow: cachedRow,
            cachedMissingCol: cachedCol,
          );

          if (isLevel2) {
            await _preloadAllPairImages();

            await Future.delayed(const Duration(milliseconds: 300));

            if (mounted) {
              _startMemorizePhase();
            }
          }
        },
      );
    } catch (e) {
      _handleError('_fetchPicturesGame', e);
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

  void _handleError(String methodName, dynamic error) {
    if (!mounted) return;

    debugPrint('Error in $methodName: $error');
    state = state.copyWith(
      isLoading: false,
      errorMessage: error.toString(),
    );
  }
}
