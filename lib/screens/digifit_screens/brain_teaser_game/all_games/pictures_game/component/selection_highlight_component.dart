import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SelectionHighlightGame extends FlameGame {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color highlightColor;

  SelectionHighlightGame({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.highlightColor = Colors.blue,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final component = SelectionHighlightComponent(
      row: row,
      column: column,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      highlightColor: highlightColor,
    );
    add(component);
  }
}

class SelectionHighlightComponent extends PositionComponent {
  final int row;
  final int column;
  final double tileWidth;
  final double tileHeight;
  final Color highlightColor;

  SelectionHighlightComponent({
    required this.row,
    required this.column,
    required this.tileWidth,
    required this.tileHeight,
    required this.highlightColor,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);
    size = Vector2(tileWidth, tileHeight);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final fillPaint = Paint()
      ..color = highlightColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const padding = 8.0;
    final paddedRect = Rect.fromLTRB(
      rect.left + padding,
      rect.top + padding,
      rect.right - padding,
      rect.bottom - padding,
    );

    final rrect = RRect.fromRectAndRadius(
      paddedRect,
      const Radius.circular(8.0),
    );

    canvas.drawRRect(rrect, fillPaint);

    final borderPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(rrect, borderPaint);
  }
}
