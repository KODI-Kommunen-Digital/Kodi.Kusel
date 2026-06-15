import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../params/grid_view_params.dart';

enum ArrowDirection {
  up,
  down,
  left,
  right;

  static ArrowDirection? fromString(String value) {
    try {
      return ArrowDirection.values.firstWhere(
        (direction) => direction.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

class ArrowOverlayGame extends FlameGame {
  String direction;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color borderColor;
  final Color arrowColor;
  int durationSeconds;

  ArrowComponent? _currentArrow;

  ArrowOverlayGame({
    required this.direction,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    required this.borderColor,
    required this.arrowColor,
    this.durationSeconds = 3,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    _createArrow(direction);
  }

  void _createArrow(String dir) {
    final arrowDirection = ArrowDirection.fromString(dir);
    if (arrowDirection == null) return;

    _currentArrow = ArrowComponent(
      direction: arrowDirection,
      durationSeconds: durationSeconds,
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

    add(_currentArrow!);
  }

  void updateDirection(String newDirection) {
    direction = newDirection;

    if (_currentArrow != null) {
      remove(_currentArrow!);
      _currentArrow = null;
    }

    removeAll(children);

    Future.microtask(() {
      if (!isMounted) return;
      _createArrow(newDirection);
    });
  }

  void updateDuration(int newDurationSeconds) {
    durationSeconds = newDurationSeconds;
  }
}

class ArrowComponent extends PositionComponent {
  final ArrowDirection direction;
  final GridViewUIParams gridViewUIParams;
  final int durationSeconds;

  double _progress = 0.0;
  double _elapsedTime = 0.0;

  SpriteComponent? _arrowSprite;

  ArrowComponent({
    required this.direction,
    required this.gridViewUIParams,
    this.durationSeconds = 3,
  }) {
    anchor = Anchor.center;
  }

  double _getRotationAngle() {
    switch (direction) {
      case ArrowDirection.right:
        return 0;
      case ArrowDirection.down:
        return pi / 2;
      case ArrowDirection.left:
        return pi;
      case ArrowDirection.up:
        return 3 * pi / 2;
    }
  }

  @override
  Future<void> onLoad() async {
    _progress = 0.0;
    _elapsedTime = 0.0;

    position = Vector2(
      gridViewUIParams.width / 2,
      gridViewUIParams.height / 2,
    );

    final minTileDimension =
        min(gridViewUIParams.tileWidth, gridViewUIParams.tileHeight);
    final componentSize = minTileDimension * 0.75;

    size = Vector2(componentSize, componentSize);

    final sprite = await Sprite.load('assets/png/arrow_right.png');
    _arrowSprite = SpriteComponent(
      sprite: sprite,
      size: Vector2(componentSize * 0.7, componentSize * 0.7),
      anchor: Anchor.center,
      position: Vector2(componentSize / 2, componentSize / 2),
      angle: _getRotationAngle(),
    );

    add(_arrowSprite!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_elapsedTime < durationSeconds) {
      _elapsedTime += dt;
      _progress = (_elapsedTime / durationSeconds).clamp(0.0, 1.0);
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final center = Offset(rect.width / 2, rect.height / 2);
    final radius = rect.width / 2;

    final strokeWidth = radius * 0.14;

    final bgPaint = Paint()
      ..color = gridViewUIParams.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = gridViewUIParams.arrowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * _progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }
}
