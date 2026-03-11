import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/digifit/brain_teaser_game/common_component/success_overlay_component.dart';

import '../../../../screens/digifit_screens/brain_teaser_game/all_games/params/grid_view_params.dart';

class ErrorOverlayGame extends FlameGame {
  final int wrongRow;
  final int wrongColumn;
  final int correctRow;
  final int correctColumn;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color errorColor;
  final Color correctColor;

  ErrorOverlayGame({
    required this.wrongRow,
    required this.wrongColumn,
    required this.correctRow,
    required this.correctColumn,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.errorColor = Colors.red,
    this.correctColor = Colors.green,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final errorComponent = ErrorCrossComponent(
      row: wrongRow,
      column: wrongColumn,
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
        isError: true,
        borderColor: errorColor,
        steps: [],
        arrowColor: errorColor,
      ),
    );

    final correctPosComponent = CorrectPositionComponent(
      row: correctRow,
      column: correctColumn,
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
        borderColor: correctColor,
        steps: [],
        arrowColor: correctColor,
      ),
    );

    add(errorComponent);
    add(correctPosComponent);
  }
}

class ErrorCrossComponent extends PositionComponent {
  final int row;
  final int column;
  final GridViewUIParams gridViewUIParams;

  ErrorCrossComponent({
    required this.row,
    required this.column,
    required this.gridViewUIParams,
  }) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    final x =
        column * gridViewUIParams.tileWidth + gridViewUIParams.tileWidth / 2;
    final y =
        row * gridViewUIParams.tileHeight + gridViewUIParams.tileHeight / 2;

    position = Vector2(x, y);
    size = Vector2(
      gridViewUIParams.tileWidth,
      gridViewUIParams.tileHeight,
    );
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final cellSize = min(rect.width, rect.height);

    final borderPaint = Paint()
      ..color = gridViewUIParams.borderColor
      ..strokeWidth = cellSize * 0.04
      ..style = PaintingStyle.stroke;

    final borderRadius = cellSize * 0.1;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(rect.width / 2, rect.height / 2),
        width: cellSize * 0.80,
        height: cellSize * 0.80,
      ),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, borderPaint);
  }
}
