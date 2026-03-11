import 'package:flutter/cupertino.dart';

import '../../../../../app_router.dart';

enum GameType {
  boldiFinder(1, boldiFinderScreenPath),
  flipCatch(2, flipCatchScreenPath),
  matheJagd(3, matheJagdScreenPath),
  digitDash(4, digitDashScreenPath),
  bilderSpiel(5, bilderSpielScreenPath);

  final int id;
  final String routePath;

  const GameType(this.id, this.routePath);

  static GameType? fromId(int id) {
    try {
      return GameType.values.firstWhere((type) => type.id == id);
    } catch (_) {
      return null;
    }
  }
}
