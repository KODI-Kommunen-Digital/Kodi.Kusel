import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PlaceholderOverlayGame extends FlameGame {
  final int rows;
  final int columns;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  PlaceholderOverlayGame({
    required this.rows,
    required this.columns,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final component = PlaceholderComponent(
          row: row,
          column: col,
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
        );
        add(component);
      }
    }
  }
}

class PlaceholderComponent extends PositionComponent with HasGameRef {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  Sprite? placeholderSprite;

  PlaceholderComponent({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);
    const scaleFactor = 0.6;

    const padding = 8.0;
    size = Vector2(
      (tileWidth - (padding * 2)) * scaleFactor,
      (tileHeight - (padding * 2)) * scaleFactor,
    );

    anchor = Anchor.center;

    try {
      final placeholderImage = await gameRef.images.load(
        'assets/png/place_holder_image_pictures_game.png',
      );
      placeholderSprite = Sprite(placeholderImage);
    } catch (e) {
      debugPrint('Error loading placeholder image: $e');
      placeholderSprite = null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (placeholderSprite == null) {
      final fallbackPaint = Paint()..color = Colors.grey[300]!;
      canvas.drawRect(size.toRect(), fallbackPaint);
      return;
    }

    final dstRect = Rect.fromLTWH(0, 0, size.x, size.y);
    placeholderSprite!.renderRect(canvas, dstRect);
  }
}
