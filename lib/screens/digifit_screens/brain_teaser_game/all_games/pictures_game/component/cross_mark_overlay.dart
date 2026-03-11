import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CrossMarkOverlayGame extends FlameGame {
  final int wrongRow1;
  final int wrongCol1;
  final int wrongRow2;
  final int wrongCol2;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  CrossMarkOverlayGame({
    required this.wrongRow1,
    required this.wrongCol1,
    required this.wrongRow2,
    required this.wrongCol2,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final component1 = CrossMarkComponent(
      row: wrongRow1,
      column: wrongCol1,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
    );
    add(component1);

    if (wrongRow2 != wrongRow1 || wrongCol2 != wrongCol1) {
      final component2 = CrossMarkComponent(
        row: wrongRow2,
        column: wrongCol2,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
      add(component2);
    }
  }
}

class CrossMarkComponent extends PositionComponent {
  final int row;
  final int column;
  final double tileWidth;
  final double tileHeight;

  CrossMarkComponent({
    required this.row,
    required this.column,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);

    const padding = 3.0;
    size = Vector2(tileWidth - padding, tileHeight - padding);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final backgroundPaint = Paint()
      ..color = const Color(0xFFE01709).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);

    const crossPadding = 44.0;
    final crossPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rect.left + crossPadding, rect.top + crossPadding),
      Offset(rect.right - crossPadding, rect.bottom - crossPadding),
      crossPaint,
    );

    canvas.drawLine(
      Offset(rect.right - crossPadding, rect.top + crossPadding),
      Offset(rect.left + crossPadding, rect.bottom - crossPadding),
      crossPaint,
    );
  }
}
