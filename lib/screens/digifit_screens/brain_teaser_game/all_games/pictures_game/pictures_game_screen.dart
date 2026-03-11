import 'dart:async';

import 'package:domain/model/response_model/digifit/brain_teaser_game/pictures_game_response_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/digifit/brain_teaser_game/blur_dialog_wrapper.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/pictures_game/screen_component/level_2_timer_widget.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/pictures_game/screen_component/level_3_dialog_widget.dart';

import '../../../../../app_router.dart';
import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../../common_widgets/common_html_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import '../../../../../common_widgets/feedback_card_widget.dart';
import '../../../../../common_widgets/text_styles.dart';
import '../../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../../images_path.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../navigation/navigation.dart';
import '../../../digifit_start/digifit_information_controller.dart';
import '../../enum/game_session_status.dart';
import '../../game_details/details_controller.dart';
import '../params/all_game_params.dart';
import 'component/picture_overlay_component.dart';
import 'component/cross_mark_overlay.dart';
import 'component/pictures_grid_component.dart';
import 'component/pair_display_overlay.dart';
import 'component/placeholder_component.dart';
import 'pictures_game_controller.dart';
import 'pictures_game_state.dart';

class PicturesGameScreen extends ConsumerStatefulWidget {
  final AllGameParams? picturesGameParams;

  const PicturesGameScreen({super.key, required this.picturesGameParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PicturesGameScreenState();
}

class _PicturesGameScreenState extends ConsumerState<PicturesGameScreen> {
  PicturesGridWidget? _gridGame;
  final GlobalKey _gridKey = GlobalKey();

  // Pre-loaded game instances for Level 2
  final List<PairDisplayGame> _memorizeGames = [];
  final List<PairDisplayGame> _checkGames = [];
  bool _gamesInitialized = false;

  PictureOverlayGame? _level3OverlayGame;
  PictureOverlayGame? _initialPicturesGame;
  PlaceholderOverlayGame? _placeholderGame;
  final Map<String, PictureOverlayGame> _revealedCellGames = {};
  CrossMarkOverlayGame? _crossMarkGame;

  int? _lastRows;
  int? _lastCols;
  int? _lastLevelId;

  @override
  void initState() {
    super.initState();
    _fetchGameData();
  }

  @override
  void dispose() {
    _cleanupGameResources();
    super.dispose();
  }

  void _fetchGameData() {
    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        picturesGameControllerProvider(
          widget.picturesGameParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchGameData(
        gameId: widget.picturesGameParams?.gameId ?? 1,
        levelId: widget.picturesGameParams?.levelId ?? 1,
      );
    });
  }

  void _initializeGames(PicturesGameState state, double imageHeight) {
    if (_gamesInitialized) return;

    final memorizePairs = state.gameData?.memorizePairs ?? [];
    final checkPairs = state.gameData?.checkPairs ?? [];
    final sourceId = state.gameData?.sourceId ?? 1;

    if (memorizePairs.isEmpty && checkPairs.isEmpty) return;

    const imageSpacing = 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 40 - 40;

    _memorizeGames.clear();
    for (var pair in memorizePairs) {
      _memorizeGames.add(
        PairDisplayGame(
          image1Url: pair.image1 ?? '',
          image2Url: pair.image2 ?? '',
          width: cardWidth,
          height: imageHeight,
          sourceId: sourceId,
          showButtons: false,
        ),
      );
    }

    _checkGames.clear();
    for (var pair in checkPairs) {
      _checkGames.add(
        PairDisplayGame(
          image1Url: pair.image1 ?? '',
          image2Url: pair.image2 ?? '',
          width: cardWidth,
          height: imageHeight,
          sourceId: sourceId,
          showButtons: true,
        ),
      );
    }

    _gamesInitialized = true;
  }

  void _cleanupGameResources() {
    _revealedCellGames.clear();
    _memorizeGames.clear();
    _checkGames.clear();
  }

  void _updateGridGame(PicturesGameState state) {
    final levelId = widget.picturesGameParams?.levelId ?? 1;
    final rows = state.rows;
    final columns = state.columns;

    if (state.showLevel3Dialog) {
      return;
    }

    final shouldRecreateGrid = _gridGame == null ||
        _lastRows != rows ||
        _lastCols != columns ||
        _lastLevelId != levelId ||
        (_lastLevelId == 3 && !state.isLevel3) ||
        (_lastLevelId != 3 && state.isLevel3);

    if (shouldRecreateGrid) {
      _recreateGrid(state, levelId, rows, columns);
    } else {
      _updateGridTimer(state);
    }
  }

  void _recreateGrid(
      PicturesGameState state, int levelId, int rows, int columns) {
    final gridWidth = 330.w;
    final tileWidth = gridWidth / columns;
    final tileHeight = tileWidth;
    final gridHeight = rows * tileHeight;

    _gridGame = PicturesGridWidget(
      params: PicturesGridParams(
        width: gridWidth,
        height: gridHeight,
        tileHeight: tileHeight,
        tileWidth: tileWidth,
        rows: rows,
        columns: columns,
        borderColor: Theme.of(context).dividerColor,
        useInnerPadding: true,
        onCellTapped: _handleCellTap,
        currentTime: state.maxTimerSeconds,
        maxTime: state.maxTimerSeconds,
        showTimer: !state.isLevel3,
      ),
    );

    _lastRows = rows;
    _lastCols = columns;
    _lastLevelId = levelId;

    _clearOverlayGames();
  }

  void _updateGridTimer(PicturesGameState state) {
    if (_gridGame != null) {
      if (state.isGameInProgress && !state.isLevel2 && !state.isLevel3) {
        _gridGame!.params.currentTime = state.timerSeconds;
      } else {
        _gridGame!.params.currentTime = state.maxTimerSeconds;
      }
    }
  }

  void _clearOverlayGames() {
    _level3OverlayGame = null;
    _initialPicturesGame = null;
    _placeholderGame = null;
    _revealedCellGames.clear();
    _crossMarkGame = null;
  }

  void _updateOverlayGames(PicturesGameState state) {
    if (state.showLevel3Dialog) {
      return;
    }

    final gridWidth = 330.w;
    final rows = state.rows;
    final columns = state.columns;
    final tileWidth = gridWidth / columns;
    final tileHeight = tileWidth;
    final gridHeight = rows * tileHeight;

    _updateLevel3Overlay(
        state, gridWidth, gridHeight, tileWidth, tileHeight, rows, columns);
    _updateInitialPicturesOverlay(
        state, gridWidth, gridHeight, tileWidth, tileHeight, rows, columns);
    _updatePlaceholderOverlay(
        state, gridWidth, gridHeight, tileWidth, tileHeight, rows, columns);
    _updateRevealedCellsOverlay(
        state, gridWidth, gridHeight, tileWidth, tileHeight, rows, columns);
    _updateCrossMarkOverlay(
        state, gridWidth, gridHeight, tileWidth, tileHeight);
  }

  void _updateLevel3Overlay(
      PicturesGameState state,
      double gridWidth,
      double gridHeight,
      double tileWidth,
      double tileHeight,
      int rows,
      int columns) {
    if (state.isLevel3) {
      final shouldRecreateLevel3 = _level3OverlayGame == null ||
          (_lastLevelId == 3 &&
              state.isGameInProgress &&
              _level3OverlayGame != null);

      if (shouldRecreateLevel3) {
        _level3OverlayGame = PictureOverlayGame(
          pictures: _getPicturePositionsLevel3(state),
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          gridRows: rows,
          gridColumns: columns,
        );
      }
    } else {
      _level3OverlayGame = null;
    }
  }

  void _updateInitialPicturesOverlay(
      PicturesGameState state,
      double gridWidth,
      double gridHeight,
      double tileWidth,
      double tileHeight,
      int rows,
      int columns) {
    if (!state.isLevel3 &&
        state.isInitialStage &&
        state.gameData?.pictureGrid != null &&
        _initialPicturesGame == null) {
      _initialPicturesGame = PictureOverlayGame(
        pictures: _getPicturePositions(state),
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        gridRows: rows,
        gridColumns: columns,
      );
    } else if (!state.isInitialStage) {
      _initialPicturesGame = null;
    }
  }

  void _updatePlaceholderOverlay(
      PicturesGameState state,
      double gridWidth,
      double gridHeight,
      double tileWidth,
      double tileHeight,
      int rows,
      int columns) {
    if (!state.isLevel3 &&
        !state.isLevel2 &&
        state.isGameInProgress &&
        _placeholderGame == null) {
      _placeholderGame = PlaceholderOverlayGame(
        rows: state.rows,
        columns: state.columns,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
    } else if (state.isLevel2 || state.isLevel3 || state.isInitialStage) {
      _placeholderGame = null;
    }
  }

  void _updateRevealedCellsOverlay(
      PicturesGameState state,
      double gridWidth,
      double gridHeight,
      double tileWidth,
      double tileHeight,
      int rows,
      int columns) {
    final currentRevealedKeys = state.revealedCells
        .map((cell) => 'revealed_${cell.row}_${cell.col}')
        .toSet();

    _revealedCellGames
        .removeWhere((key, _) => !currentRevealedKeys.contains(key));

    for (var cell in state.revealedCells) {
      final key = 'revealed_${cell.row}_${cell.col}';
      if (!_revealedCellGames.containsKey(key)) {
        String imageUrl = _getRevealedCellImageUrl(state, cell);

        _revealedCellGames[key] = PictureOverlayGame(
          pictures: [
            PicturePosition(
              row: cell.row,
              col: cell.col,
              imageUrl: imageUrl,
            ),
          ],
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          gridRows: rows,
          gridColumns: columns,
        );
      }
    }
  }

  void _updateCrossMarkOverlay(PicturesGameState state, double gridWidth,
      double gridHeight, double tileWidth, double tileHeight) {
    if (state.showResult &&
        state.isAnswerCorrect == false &&
        state.wrongRow != null) {
      _crossMarkGame ??= CrossMarkOverlayGame(
        wrongRow1: state.wrongRow!,
        wrongCol1: state.wrongCol!,
        wrongRow2: state.wrongRow2 ?? state.wrongRow!,
        wrongCol2: state.wrongCol2 ?? state.wrongCol!,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
    } else {
      _crossMarkGame = null;
    }
  }

  String _getRevealedCellImageUrl(PicturesGameState state, RevealedCell cell) {
    if (state.isLevel3) {
      final allImages = state.gameData?.allImagesList ?? [];
      ImageWithId? selectedImage;
      try {
        selectedImage = allImages.firstWhere(
          (img) => img.id.toString() == cell.imageId,
        );
      } catch (_) {
        selectedImage = null;
      }
      return selectedImage?.image ?? 'admin/games/picturegame/empty.png';
    } else {
      return _getImageUrlForCell(state, cell.row, cell.col);
    }
  }

  List<PicturePosition> _getPicturePositions(PicturesGameState state) {
    final pictures = <PicturePosition>[];
    final pictureGrid = state.gameData?.pictureGrid ?? [];
    for (int i = 0; i < pictureGrid.length; i++) {
      final row = i ~/ state.columns;
      final col = i % state.columns;
      pictures.add(PicturePosition(
          row: row, col: col, imageUrl: pictureGrid[i].image1 ?? ''));
    }
    return pictures;
  }

  List<PicturePosition> _getPicturePositionsLevel3(PicturesGameState state) {
    final pictures = <PicturePosition>[];

    if (state.isInitialStage) {
      final allImagesList = state.gameData?.allImagesList ?? [];
      for (int i = 0; i < allImagesList.length; i++) {
        final row = i ~/ state.columns;
        final col = i % state.columns;
        pictures.add(PicturePosition(
          row: row,
          col: col,
          imageUrl: allImagesList[i].image ?? '',
        ));
      }
    } else if (state.isGameInProgress) {
      final displayImagesList = state.gameData?.displayImagesList ?? [];
      for (int i = 0; i < displayImagesList.length; i++) {
        final row = i ~/ state.columns;
        final col = i % state.columns;
        final imageUrl = displayImagesList[i].image ?? '';

        if (imageUrl.isNotEmpty) {
          pictures.add(PicturePosition(
            row: row,
            col: col,
            imageUrl: imageUrl,
          ));
        }
      }
    }

    return pictures;
  }

  String _getImageUrlForCell(PicturesGameState state, int row, int col) {
    final pictureGrid = state.gameData?.pictureGrid ?? [];
    final index = row * state.columns + col;
    return index < pictureGrid.length ? pictureGrid[index].image1 ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1,
      ),
    );

    _handleLevel3DialogDisplay(state);

    // Dialog show karte time grid ko mat recreate karo
    if (!state.showLevel3Dialog) {
      _updateGridGame(state);
      _updateOverlayGames(state);
    } else {
      // Sirf timer update karo, grid mat touch karo
      _updateGridTimer(state);
    }

    return _buildScaffold(state);
  }

  void _handleLevel3DialogDisplay(PicturesGameState state) {
    if (state.showLevel3Dialog && !state.level3Completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showLevel3ImageSelectionDialog(context, state);
        }
      });
    }
  }

  Widget _buildScaffold(PicturesGameState state) {
    final headingText = widget.picturesGameParams?.title ?? '';
    final levelId = widget.picturesGameParams?.levelId ?? 1;
    final shouldShowLevel2 =
        state.isLevel2 && !state.isLevel3 || (state.isLoading && levelId == 2);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop == false) {
          await _handleBackNavigation(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              _buildScrollableContent(state, headingText, shouldShowLevel2),
              _buildBottomNavigation(state),
              if (state.showResult) _buildGameStatusCard(state),
            ],
          ),
        ).loaderDialog(context, state.isLoading),
      ),
    );
  }

  Widget _buildScrollableContent(
      PicturesGameState state, String headingText, bool shouldShowLevel2) {
    final gridWidth = 330.w;
    final rows = state.rows;
    final columns = state.columns;
    final tileWidth = gridWidth / columns;
    final tileHeight = tileWidth;
    final gridHeight = rows * tileHeight;

    return Positioned.fill(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            _buildBackground(),
            _buildHeader(headingText),
            Column(
              children: [
                130.verticalSpace,
                if (shouldShowLevel2)
                  _buildLevel2Content(state, gridWidth, context)
                else
                  _buildGameGrid(state, gridWidth, gridHeight, tileWidth,
                      tileHeight, rows, columns),
                10.verticalSpace,
                _buildDescription(state),
                10.verticalSpace,
                if (!state.isLoading) _buildFeedbackCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return CommonBackgroundClipperWidget(
      height: 145.h,
      clipperType: UpstreamWaveClipper(),
      imageUrl: imagePath['home_screen_background'] ?? '',
      isStaticImage: true,
    );
  }

  Widget _buildHeader(String headingText) {
    return Positioned(
      top: 50.h,
      left: 10.r,
      child: Row(
        children: [
          IconButton(
            onPressed: () async => await _handleBackNavigation(context),
            icon: Icon(
              Icons.arrow_back,
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              color: Theme.of(context).primaryColor,
            ),
          ),
          2.horizontalSpace,
          textSemiBoldPoppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: headingText,
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid(
      PicturesGameState state,
      double gridWidth,
      double gridHeight,
      double tileWidth,
      double tileHeight,
      int rows,
      int columns) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: gridHeight,
        width: gridWidth,
        child: _buildGameStack(
          state: state,
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          context: context,
          rows: rows,
          col: columns,
        ),
      ),
    );
  }

  Widget _buildDescription(PicturesGameState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: CommonHtmlWidget(
        fontSize: 16,
        data: state.gameData?.subDescription ?? '',
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return FeedbackCardWidget(
      height: 270.h,
      onTap: () {
        ref
            .read(navigationProvider)
            .navigateUsingPath(path: feedbackScreenPath, context: context);
      },
    );
  }

  Widget _buildBottomNavigation(PicturesGameState state) {
    return Positioned(
      bottom: 20.h,
      left: 16.w,
      right: 16.w,
      child: CommonBottomNavCard(
        onBackPress: () async {
          await _handleBackNavigation(context);
        },
        isFavVisible: false,
        isFav: false,
        onGameStageConstantTap: _handleBottomNavTap,
        gameDetailsStageConstant: state.gameStage,
      ),
    );
  }

  Widget _buildGameStatusCard(PicturesGameState state) {
    return Positioned(
      bottom: 80.h,
      left: 0,
      right: 0,
      child: GameStatusCardWidget(
        isStatus: state.isAnswerCorrect ?? false,
        description: _getGameStatusDescription(state),
      ),
    );
  }

  String _getGameStatusDescription(PicturesGameState state) {
    switch (widget.picturesGameParams?.levelId ?? 1) {
      case 13:
        return AppLocalizations.of(context).successful_game_desc_for_level_1;
      case 14:
        return AppLocalizations.of(context).successful_game_desc_for_level_2;
      case 15:
        return AppLocalizations.of(context).successful_game_desc_for_level_3;
      default:
        return "Great effort! Keep pushing your limits.";
    }
  }

  Widget _buildGameStack({
    required PicturesGameState state,
    required double gridWidth,
    required double gridHeight,
    required double tileWidth,
    required double tileHeight,
    required BuildContext context,
    required int rows,
    required int col,
  }) {
    return Stack(
      children: [
        if (_gridGame != null) GameWidget(key: _gridKey, game: _gridGame!),
        if (_level3OverlayGame != null)
          IgnorePointer(
            child: GameWidget(
              key: ValueKey('level3_${state.gameStage.name}'),
              game: _level3OverlayGame!,
            ),
          ),
        if (_initialPicturesGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('initial_pictures'),
              game: _initialPicturesGame!,
            ),
          ),
        if (_placeholderGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('placeholders'),
              game: _placeholderGame!,
            ),
          ),
        ..._revealedCellGames.entries.map((entry) {
          return IgnorePointer(
            child: GameWidget(
              key: ValueKey(entry.key),
              game: entry.value,
            ),
          );
        }).toList(),
        if (_crossMarkGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('cross_mark'),
              game: _crossMarkGame!,
            ),
          ),
      ],
    );
  }

  Widget _buildLevel2Content(
    PicturesGameState state,
    double width,
    BuildContext context,
  ) {
    const cardPadding = 20.0;
    const imageSpacing = 10.0;
    const buttonHeight = 50.0;
    const buttonSpacing = 8.0;

    final imageWidth = (width - cardPadding * 2 - imageSpacing) / 2;
    final imageHeight = imageWidth * 1.2;
    final cardHeight =
        cardPadding + imageHeight + buttonSpacing + buttonHeight + cardPadding;
    final screenWidth = MediaQuery.of(context).size.width;

    if (state.gameData != null && !_gamesInitialized) {
      _initializeGames(state, imageHeight);
    }

    if (state.isLoading || state.gameData == null || !_gamesInitialized) {
      return _buildLevel2LoadingCard(screenWidth, cardHeight);
    }

    if (state.isMemorizePhase && state.showMemorizePair) {
      return _buildMemorizePhaseCard(
          state, cardHeight, imageHeight, screenWidth);
    }

    if (state.showCheckPair && state.currentPairIndex < _checkGames.length) {
      return _buildCheckPhaseCard(
          state, cardHeight, imageHeight, screenWidth, buttonHeight);
    }

    if (state.isMemorizePhase &&
        !state.showMemorizePair &&
        state.memorizationComplete) {
      return _buildLevel2LoadingCard(screenWidth, cardHeight);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLevel2LoadingCard(double screenWidth, double cardHeight) {
    return Container(
      width: screenWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  Widget _buildMemorizePhaseCard(PicturesGameState state, double cardHeight,
      double imageHeight, double screenWidth) {
    final memorizePairs = state.gameData?.memorizePairs ?? [];

    if (state.currentPairIndex >= _memorizeGames.length) {
      return const SizedBox.shrink();
    }

    final game = _memorizeGames[state.currentPairIndex];

    return Column(
      children: [
        if (state.isGameInProgress && state.timerSeconds > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Level2TimerWidget(seconds: state.timerSeconds),
          ),
        Container(
          width: screenWidth,
          height: cardHeight,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 40.0),
            child: Column(
              children: [
                SizedBox(
                  height: imageHeight,
                  child: _buildAnimatedGameWidget(
                    key: 'memorize_${state.currentPairIndex}',
                    game: game,
                  ),
                ),
              ],
            ),
          ),
        ),
        16.verticalSpace,
        _buildProgressIndicator(state.currentPairIndex, memorizePairs.length),
      ],
    );
  }

  Widget _buildCheckPhaseCard(PicturesGameState state, double cardHeight,
      double imageHeight, double screenWidth, double buttonHeight) {
    if (state.currentPairIndex >= _checkGames.length) {
      return const SizedBox.shrink();
    }

    final game = _checkGames[state.currentPairIndex];
    final bool shouldDisableButtons = state.showResult ||
        !state.canPlayGame ||
        state.gameStage == GameStageConstant.complete ||
        state.gameStage == GameStageConstant.abort;

    return Column(
      children: [
        if (state.timerSeconds > 0 && !state.showResult)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Level2TimerWidget(seconds: state.timerSeconds),
          ),
        Container(
          width: screenWidth,
          height: cardHeight,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: imageHeight,
                  child: _buildAnimatedGameWidget(
                    key: 'check_${state.currentPairIndex}',
                    game: game,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAnswerButtons(shouldDisableButtons, buttonHeight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedGameWidget(
      {required String key, required PairDisplayGame game}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: GameWidget(
        key: ValueKey(key),
        game: game,
      ),
    );
  }

  Widget _buildProgressIndicator(int currentIndex, int totalCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          textSemiBoldPoppins(
            text: '${currentIndex + 1}/$totalCount',
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
          8.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / totalCount,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButtons(bool shouldDisableButtons, double buttonHeight) {
    const imageSpacing = 10.0;

    return Row(
      children: [
        Expanded(
          child: _buildAnswerButton(
            isCorrect: true,
            isDisabled: shouldDisableButtons,
            buttonHeight: buttonHeight,
            onTap: () {
              final controller = ref.read(
                picturesGameControllerProvider(
                  widget.picturesGameParams?.levelId ?? 1,
                ).notifier,
              );
              controller.handleUserAnswer(true);
            },
          ),
        ),
        const SizedBox(width: imageSpacing),
        Expanded(
          child: _buildAnswerButton(
            isCorrect: false,
            isDisabled: shouldDisableButtons,
            buttonHeight: buttonHeight,
            onTap: () {
              final controller = ref.read(
                picturesGameControllerProvider(
                  widget.picturesGameParams?.levelId ?? 1,
                ).notifier,
              );
              controller.handleUserAnswer(false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerButton({
    required bool isCorrect,
    required bool isDisabled,
    required double buttonHeight,
    required VoidCallback onTap,
  }) {
    final color = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final text = isCorrect
        ? AppLocalizations.of(context).correct_answer
        : AppLocalizations.of(context).wrong_answer;
    final marginLeft = isCorrect ? 0.0 : 12.0;
    final marginRight = isCorrect ? 16.0 : 10.0;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          margin: EdgeInsets.only(left: marginLeft, right: marginRight),
          height: buttonHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: textSemiBoldMontserrat(
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handleCellTap(int row, int column) {
    debugPrint('Cell tapped: row=$row, col=$column');
    if (!mounted) return;

    ref
        .read(picturesGameControllerProvider(
                widget.picturesGameParams?.levelId ?? 1)
            .notifier)
        .handleCellTap(row, column);
  }

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;

    final controller = ref.read(
      picturesGameControllerProvider(widget.picturesGameParams?.levelId ?? 1)
          .notifier,
    );
    final state = ref.read(
      picturesGameControllerProvider(widget.picturesGameParams?.levelId ?? 1),
    );

    switch (state.gameStage) {
      case GameStageConstant.initial:
        await controller.startGame();
        break;
      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;
      case GameStageConstant.abort:
        _gamesInitialized = false;
        _memorizeGames.clear();
        _checkGames.clear();
        await controller.restartGame(
          widget.picturesGameParams?.gameId ?? 1,
          widget.picturesGameParams?.levelId ?? 1,
        );
        break;
      case GameStageConstant.complete:
        await _handleBackNavigation(context);
        break;
    }
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    if (!mounted) return;

    final state = ref.read(
      picturesGameControllerProvider(widget.picturesGameParams?.levelId ?? 1),
    );

    switch (state.gameStage) {
      case GameStageConstant.progress:
        await _showAbortDialog(context);
        break;
      case GameStageConstant.complete:
        await _showCompletionDialog(context);
        break;
      default:
        if (mounted) {
          ref.read(navigationProvider).removeTopPage(context: context);
        }
    }
  }

  Future<void> _showAbortDialog(BuildContext context) async {
    if (!mounted) return;

    final controller = ref.read(
      picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1,
      ).notifier,
    );

    controller.pauseGameTimer();

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).abort_pictures_game,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
            text: AppLocalizations.of(context).abort_game_desc,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.visible,
            fontSize: 12,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (!mounted) return;
              controller.resumeGameTimer();
              ref.read(navigationProvider).removeDialog(context: context);
            },
            isDefaultAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).digifit_continue,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;
              final controller = ref.read(
                picturesGameControllerProvider(
                  widget.picturesGameParams?.levelId ?? 1,
                ).notifier,
              );
              await ref.read(navigationProvider).removeDialog(context: context);
              if (!mounted) return;
              await controller.trackGameProgress(
                GameStageConstant.abort,
                onSuccess: () {
                  if (mounted) {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  }
                },
              );
            },
            child: textBoldPoppins(
              text: AppLocalizations.of(context).digifit_end_game,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompletionDialog(BuildContext context) async {
    if (!mounted) return;

    final levelId = widget.picturesGameParams?.levelId ?? 13;
    String text =
        ((levelId) == 13 || (widget.picturesGameParams?.levelId ?? 1) == 14)
            ? AppLocalizations.of(context).level_complete_desc
            : AppLocalizations.of(context).all_level_complete;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
          text: AppLocalizations.of(context).level_complete,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
            text: text,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.visible,
            fontSize: 12,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;
              ref.read(navigationProvider).removeDialog(context: context);
              if (!mounted) return;
              ref.read(navigationProvider).removeTopPage(context: context);
              Future.microtask(() async {
                await ref
                    .read(brainTeaserGameDetailsControllerProvider(
                            widget.picturesGameParams?.gameId ?? 1)
                        .notifier)
                    .fetchBrainTeaserGameDetails(
                        gameId: widget.picturesGameParams?.gameId ?? 1);
                ref
                    .read(digifitInformationControllerProvider.notifier)
                    .fetchDigifitInformation();
              });
            },
            isDefaultAction: true,
            child: textBoldPoppins(
              text: AppLocalizations.of(context).ok,
              textOverflow: TextOverflow.visible,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLevel3ImageSelectionDialog(
    BuildContext context,
    PicturesGameState state,
  ) async {
    if (!mounted) return;

    final allImages = state.gameData?.allImagesList ?? [];
    if (allImages.isEmpty) return;

    bool wasTimeout = false;
    bool dialogClosed = false;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BlurDialogWrapper(
        child: Level3DialogWithTimer(
          allImages: allImages,
          initialSeconds: state.timerSeconds,
          onImageSelected: (selectedImageId) {
            if (!mounted || dialogClosed) return;
            dialogClosed = true;

            final controller = ref.read(
              picturesGameControllerProvider(
                widget.picturesGameParams?.levelId ?? 1,
              ).notifier,
            );

            ref.read(navigationProvider).removePictureDialog(context: context);

            controller.state = controller.state.copyWith(
                showLevel3Dialog: false,
                level3TimerComplete: false,
                isLoading: false);

            controller.handleLevel3ImageSelection(selectedImageId);
          },
          onTimeout: () {
            wasTimeout = true;
          },
          onCloseDialog: () {
            if (!mounted || dialogClosed) return;
            dialogClosed = true;

            final controller = ref.read(
              picturesGameControllerProvider(
                widget.picturesGameParams?.levelId ?? 1,
              ).notifier,
            );

            controller.state = controller.state.copyWith(
              showLevel3Dialog: false,
              level3TimerComplete: false,
            );

            ref.read(navigationProvider).removePictureDialog(context: context);
          },
        ),
      ),
    );

    if (mounted && wasTimeout) {
      final controller = ref.read(
        picturesGameControllerProvider(
          widget.picturesGameParams?.levelId ?? 1,
        ).notifier,
      );

      controller.state = controller.state.copyWith(
          showLevel3Dialog: false,
          level3TimerComplete: false,
          isLoading: false);

      final displayList = state.gameData?.displayImagesList ?? [];
      final missingRow = state.missingImageRow;
      final missingCol = state.missingImageCol;
      final List<RevealedCell> displayRevealedCells = [];

      for (int i = 0; i < displayList.length; i++) {
        final displayImage = displayList[i];
        final row = i ~/ state.columns;
        final col = i % state.columns;

        if (row == missingRow && col == missingCol) continue;

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

      controller.state = controller.state.copyWith(
        revealedCells: displayRevealedCells,
        wrongRow: missingRow,
        wrongCol: missingCol,
        isLoading: false,
        showResult: false,
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        controller.state = controller.state.copyWith(
          showResult: true,
          isAnswerCorrect: false,
          gameStage: GameStageConstant.abort,
        );
      }

      await controller.trackGameProgress(
        GameStageConstant.abort,
        onSuccess: () {
          if (mounted) {
            controller.state = controller.state.copyWith(isLoading: false);
          }
        },
      );
    }
  }
}
