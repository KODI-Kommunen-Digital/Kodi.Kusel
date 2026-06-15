import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../../screens/digifit_screens/brain_teaser_game/all_games/params/grid_view_params.dart';

class SuccessOverlayGame extends FlameGame {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color successColor;

  SuccessOverlayGame({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.successColor = Colors.green,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final successComponent = CorrectPositionComponent(
      row: row,
      column: column,
      gridViewUIParams: GridViewUIParams(
        width: gridWidth,
        height: gridHeight,
        tileHeight: tileHeight,
        tileWidth: tileWidth,
        rows: 0,
        columns: 0,
        startPositionRow: 0,
        startPositionCol: 0,
        finalPositionRow: 0,
        finalPositionCol: 0,
        gameId: 0,
        isError: false,
        borderColor: successColor,
        steps: [],
        arrowColor: successColor,
      ),
    );

    add(successComponent);
  }
}

class CorrectPositionComponent extends SpriteComponent {
  final int row;
  final int column;
  final GridViewUIParams gridViewUIParams;

  CorrectPositionComponent({
    required this.row,
    required this.column,
    required this.gridViewUIParams,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('assets/png/boldi_successor.png');


    final x =
        column * gridViewUIParams.tileWidth + gridViewUIParams.tileWidth / 2;
    final y =
        row * gridViewUIParams.tileHeight + gridViewUIParams.tileHeight / 2;

    position = Vector2(x, y);
    size = Vector2(
      gridViewUIParams.tileWidth,
      gridViewUIParams.tileHeight,
    );

    anchor = Anchor.center;
  }
}
