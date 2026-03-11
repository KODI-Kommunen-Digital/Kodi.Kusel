import 'package:flutter/material.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/math_hunt/math_hunt_screen.dart';

import '../all_games/boldi_finder/boldi_finder_screen.dart';
import '../all_games/digit_dash/digit_dash_screen.dart';
import '../all_games/flip_catch/flip_catch_screen.dart';
import '../all_games/params/all_game_params.dart';
import '../all_games/pictures_game/pictures_game_screen.dart';
import 'enum/game_type.dart';

class GameRegistry {
  GameRegistry._();

  static final Map<GameType, Widget Function(AllGameParams?)> _screenBuilders =
      {
    GameType.boldiFinder: (params) =>
        BoldiFinderScreen(boldiFinderParams: params),
    GameType.flipCatch: (params) => FlipCatchScreen(flipCatchParams: params),
    GameType.matheJagd: (params) => MathHuntScreen(
          mathHuntGameParams: params,
        ),
    GameType.digitDash: (params) => DigitDashScreen(digitDashParams: params),
    GameType.bilderSpiel: (params) =>
        PicturesGameScreen(picturesGameParams: params),
  };

  static String getGameRoutePath(int gameId) {
    final gameType = GameType.fromId(gameId);
    if (gameType == null) {
      debugPrint(
          'GameRegistry: Unknown gameId $gameId, defaulting to BoldiFinder');
      return GameType.boldiFinder.routePath;
    }
    return gameType.routePath;
  }

  static bool isValidGameId(int gameId) {
    return GameType.fromId(gameId) != null;
  }

  static Widget getGameScreen(int gameId, AllGameParams? params) {
    final gameType = GameType.fromId(gameId);

    if (gameType == null) {
      debugPrint(
          'GameRegistry: Unknown gameId $gameId, returning default screen');
      return _screenBuilders[GameType.boldiFinder]!(params);
    }

    final builder = _screenBuilders[gameType];
    return builder?.call(params) ?? _buildErrorScreen(gameId);
  }

  static Widget _buildPlaceholder(GameType gameType, AllGameParams? params) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videogame_asset_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "Kommt bald!",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildErrorScreen(int gameId) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Game Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Game ID: $gameId is not registered',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
