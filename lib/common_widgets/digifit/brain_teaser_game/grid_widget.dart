import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGridWidget extends FlameGame {
  final CommonGridParams params;

  CommonGridWidget({required this.params});

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(params.width, params.height),
    );

    _buildGridCards();

    // Add grid lines on top
    final gridLines = GridLinesComponent(params: params);
    add(gridLines);
  }

  void _buildGridCards() {
    for (int row = 0; row < params.rows; row++) {
      for (int column = 0; column < params.columns; column++) {
        final x = column * params.tileWidth + params.tileWidth / 2;
        final y = row * params.tileHeight + params.tileHeight / 2;

        final card = GridCardComponent(
          params: params,
          position: Vector2(x, y),
          size: Vector2(params.tileWidth, params.tileHeight),
          borderRadius: _getBorderRadius(row, column),
          row: row,
          column: column,
        );
        add(card);
      }
    }
  }

  BorderRadius? _getBorderRadius(int row, int col) {
    final radius = 16.r;

    final isTopLeft = row == 0 && col == 0;
    final isTopRight = row == 0 && col == params.columns - 1;
    final isBottomLeft = row == params.rows - 1 && col == 0;
    final isBottomRight = row == params.rows - 1 && col == params.columns - 1;

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

class GridCardComponent extends PositionComponent
    with TapCallbacks, HasGameReference<CommonGridWidget> {
  final CommonGridParams params;
  final BorderRadius? borderRadius;
  final int row;
  final int column;

  bool isFlipped = false;
  bool _isCorrect = true;

  GridCardComponent({
    required this.params,
    required super.position,
    required super.size,
    required this.row,
    required this.column,
    required this.borderRadius,
  }) {
    anchor = Anchor.center;
  }

  final borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (borderRadius != null) {
      final rrect = borderRadius!.toRRect(rect);
      canvas.drawRRect(rrect, whiteFillPaint);
    } else {
      canvas.drawRect(rect, whiteFillPaint);
    }

    if (isFlipped) {
      _drawFlippedState(canvas, rect);
    }

    // Draw border
    if (borderRadius != null) {
      final borderRRect = borderRadius!.toRRect(rect);
      canvas.drawRRect(borderRRect, borderPaint);
    } else {
      canvas.drawRect(rect, borderPaint);
    }
  }

  void _drawFlippedState(Canvas canvas, Rect rect) {
    RRect fillRRect;

    if (!_isCorrect) {
      const padding = 8.0;
      final paddedRect = Rect.fromLTRB(
        rect.left + padding,
        rect.top + padding,
        rect.right - padding,
        rect.bottom - padding,
      );
      fillRRect = RRect.fromRectAndRadius(
        paddedRect,
        const Radius.circular(8.0),
      );

      final redStrokePaint = Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(fillRRect, redStrokePaint);
    } else {
      if (params.useInnerPadding) {
        const padding = 8.0;
        final paddedRect = Rect.fromLTRB(
          rect.left + padding,
          rect.top + padding,
          rect.right - padding,
          rect.bottom - padding,
        );
        fillRRect = RRect.fromRectAndRadius(
          paddedRect,
          const Radius.circular(8.0),
        );
      } else {
        fillRRect = borderRadius != null
            ? borderRadius!.toRRect(rect)
            : RRect.fromRectAndRadius(rect, Radius.zero);
      }

      final greenFillPaint = Paint()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(fillRRect, greenFillPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint('inside this tapDown');
    params.onCellTapped?.call(row, column);
  }
}

class GridLinesComponent extends Component {
  final CommonGridParams params;

  GridLinesComponent({required this.params});

  @override
  void render(Canvas canvas) {
    final outerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final innerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = 16.r;

    final outerRect = Rect.fromLTWH(0, 0, params.width, params.height);
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));
    canvas.drawRRect(outerRRect, outerPaint);

    for (int col = 1; col < params.columns; col++) {
      final x = col * params.tileWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, params.height),
        innerPaint,
      );
    }

    for (int row = 1; row < params.rows; row++) {
      final y = row * params.tileHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(params.width, y),
        innerPaint,
      );
    }
  }
}

class CommonGridParams {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  final Color borderColor;

  /// Whether to use inner padding for success state (game mode specific)
  final bool useInnerPadding;
  final Function(int row, int column)? onCellTapped;

  CommonGridParams({
    required this.width,
    required this.height,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.borderColor,
    this.useInnerPadding = false,
    this.onCellTapped,
  });
}
