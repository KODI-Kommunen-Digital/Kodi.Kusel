import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../params/grid_view_params.dart';

class PauseOverlayGame extends FlameGame {
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color borderColor;
  final Color arrowColor;

  PauseOverlayGame({
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    required this.borderColor,
    required this.arrowColor,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final pauseComponent = PauseIconComponent(
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
        borderColor: borderColor,
        steps: [],
        arrowColor: arrowColor,
      ),
    );

    add(pauseComponent);
  }
}

class PauseIconComponent extends PositionComponent {
  final GridViewUIParams gridViewUIParams;

  PauseIconComponent({required this.gridViewUIParams}) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(
      gridViewUIParams.width / 2,
      gridViewUIParams.height / 2,
    );

    final minTileDimension =
        min(gridViewUIParams.tileWidth, gridViewUIParams.tileHeight);
    final componentSize = minTileDimension * 0.8;

    size = Vector2(componentSize, componentSize);
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final center = Offset(rect.width / 2, rect.height / 2);
    final radius = rect.width / 2;

    final outerStrokeWidth = radius * 0.12;
    final innerStrokeWidth = radius * 0.10;

    final outerCirclePaint = Paint()
      ..color = gridViewUIParams.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerStrokeWidth;
    canvas.drawCircle(
        center, radius - (outerStrokeWidth / 2), outerCirclePaint);

    final innerCirclePaint = Paint()
      ..color = gridViewUIParams.arrowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStrokeWidth;
    canvas.drawCircle(center, radius * 0.65, innerCirclePaint);

    final playPaint = Paint()
      ..color = gridViewUIParams.arrowColor
      ..style = PaintingStyle.fill;

    final triangleSize = radius * 0.35;
    final trianglePath = Path();

    trianglePath.moveTo(
      center.dx - triangleSize * 0.4,
      center.dy - triangleSize * 0.8,
    );
    trianglePath.lineTo(
      center.dx + triangleSize * 0.6,
      center.dy,
    );
    trianglePath.lineTo(
      center.dx - triangleSize * 0.4,
      center.dy + triangleSize * 0.8,
    );
    trianglePath.close();

    canvas.drawPath(trianglePath, playPaint);
  }
}
