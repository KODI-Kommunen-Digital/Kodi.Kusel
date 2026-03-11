import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SuccessBorderOverlayGame extends FlameGame {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color borderColor;

  SuccessBorderOverlayGame({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.borderColor = const Color(0xFF8BC34A),
  });

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.visibleGameSize = Vector2(gridWidth, gridHeight);
    camera.viewfinder.position = Vector2(gridWidth / 2, gridHeight / 2);

    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    add(
      SuccessBorderOverlayComponent(
        position: Vector2(x, y),
        size: Vector2(tileWidth, tileHeight),
        borderColor: borderColor,
        row: row,
        column: column,
        gridRows: (gridHeight / tileHeight).round(),
        gridColumns: (gridWidth / tileWidth).round(),
      ),
    );
  }
}

class SuccessBorderOverlayComponent extends PositionComponent {
  final Color borderColor;
  final int row;
  final int column;
  final int gridRows;
  final int gridColumns;

  SuccessBorderOverlayComponent({
    required super.position,
    required super.size,
    required this.borderColor,
    required this.row,
    required this.column,
    required this.gridRows,
    required this.gridColumns,
  }) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = size.toRect();

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final borderRadius = _getBorderRadius();

    if (borderRadius != null) {
      final borderRRect = borderRadius.toRRect(rect);
      canvas.drawRRect(borderRRect, borderPaint);
    } else {
      canvas.drawRect(rect, borderPaint);
    }
  }

  BorderRadius? _getBorderRadius() {
    final radius = 10.0;

    final isTopLeft = row == 0 && column == 0;
    final isTopRight = row == 0 && column == gridColumns - 1;
    final isBottomLeft = row == gridRows - 1 && column == 0;
    final isBottomRight = row == gridRows - 1 && column == gridColumns - 1;

    if (isTopLeft || isTopRight || isBottomLeft || isBottomRight) {
      return BorderRadius.only(
        topLeft: isTopLeft ? Radius.circular(radius) : Radius.zero,
        topRight: isTopRight ? Radius.circular(radius) : Radius.zero,
        bottomLeft: isBottomLeft ? Radius.circular(radius) : Radius.zero,
        bottomRight: isBottomRight ? Radius.circular(radius) : Radius.zero,
      );
    }

    return null;
  }
}
