import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../navigation/navigation.dart';
import '../all_games/params/all_game_params.dart';
import 'game_registry.dart';

final gameNavigationProvider = Provider((ref) => GameNavigationService(ref));

class GameNavigationService {
  final Ref _ref;

  GameNavigationService(this._ref);

  Future<void> navigateToGame(
      {required BuildContext context,
      required int gameId,
      int? levelId,
      String? description,
      String? title}) async {
    if (!GameRegistry.isValidGameId(gameId)) {
      debugPrint('Invalid gameId: $gameId');
      return;
    }

    final routePath = GameRegistry.getGameRoutePath(gameId);

    final params = AllGameParams(
      gameId: gameId,
      levelId: levelId,
      desc: description,
      title: title,
    );

    try {
      _ref.read(navigationProvider).navigateUsingPath(
            path: routePath,
            context: context,
            params: params,
          );
    } catch (e) {
      debugPrint('Navigation Exception error: $e');
    }
  }
}
