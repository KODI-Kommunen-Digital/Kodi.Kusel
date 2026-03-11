import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../params/grid_view_params.dart';

class BoldiOverlayGame extends FlameGame {
  int row;
  int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  BoldiComponent? _currentBoldi;

  BoldiOverlayGame({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    _createBoldi(row, column);
  }

  void _createBoldi(int r, int c) {
    _currentBoldi = BoldiComponent(
      row: r,
      column: c,
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
        borderColor: Colors.transparent,
        steps: [],
        arrowColor: Colors.transparent,
      ),
    );

    add(_currentBoldi!);
  }

  void updatePosition(int newRow, int newCol) {
    row = newRow;
    column = newCol;

    if (_currentBoldi != null) {
      _currentBoldi!.removeFromParent();
      _currentBoldi = null;
    }

    _createBoldi(newRow, newCol);
  }
}

class BoldiComponent extends SpriteComponent {
  final int row;
  final int column;
  final GridViewUIParams gridViewUIParams;

  BoldiComponent({
    required this.row,
    required this.column,
    required this.gridViewUIParams,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('assets/png/grid_boldi.png');

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
