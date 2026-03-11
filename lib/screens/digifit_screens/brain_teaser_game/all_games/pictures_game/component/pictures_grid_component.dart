import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicturesGridWidget extends FlameGame {
  final PicturesGridParams params;

  PicturesGridWidget({required this.params});

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(
        params.width,
        params.height,
      ),
    );

    _buildGridCells();

    add(PicturesGridLinesComponent(
      params: params,
    ));
  }

  void _buildGridCells() {
    for (int row = 0; row < params.rows; row++) {
      for (int col = 0; col < params.columns; col++) {
        final x = col * params.tileWidth + params.tileWidth / 2;
        final y = row * params.tileHeight + params.tileHeight / 2;

        final cell = PicturesGridCell(
          position: Vector2(x, y),
          size: Vector2(params.tileWidth, params.tileHeight),
          borderRadius: _getBorderRadius(row, col),
          row: row,
          col: col,
          onTap: params.onCellTapped,
          params: params,
        );
        add(cell);
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

class PicturesGridCell extends PositionComponent
    with TapCallbacks, HasGameReference<PicturesGridWidget> {
  BorderRadius? borderRadius;
  int row;
  int col;
  Function(int, int)? onTap;
  final PicturesGridParams params;

  double _loaderRotation = 0.0;

  PicturesGridCell({
    required super.position,
    required super.size,
    this.borderRadius,
    required this.row,
    required this.col,
    this.onTap,
    required this.params,
  }) {
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (params.isImageLoading) {
      _loaderRotation += dt * 3.0;
      if (_loaderRotation > 2 * pi) {
        _loaderRotation -= 2 * pi;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = size.toRect();

    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    RRect? rRect;

    if (borderRadius != null) {
      rRect = borderRadius!.toRRect(rect);
      canvas.drawRRect(rRect, whiteFillPaint);
    } else {
      canvas.drawRect(rect, whiteFillPaint);
    }

    if (params.isImageLoading) {
      _drawLoader(canvas, rect);
    }
  }

  void _drawLoader(Canvas canvas, Rect rect) {
    final centerX = rect.width / 2;
    final centerY = rect.height / 2;

    final loaderRadius = min(rect.width, rect.height) * 0.15;

    canvas.save();

    canvas.translate(centerX, centerY);
    canvas.rotate(_loaderRotation);

    final loaderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final loaderRect = Rect.fromCircle(
      center: Offset.zero,
      radius: loaderRadius,
    );

    canvas.drawArc(
      loaderRect,
      0,
      3 * pi / 2,
      false,
      loaderPaint,
    );

    final dotAngle = 3 * pi / 2;
    final dotX = loaderRadius * cos(dotAngle);
    final dotY = loaderRadius * sin(dotAngle);

    final dotPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(dotX, dotY),
      3.0,
      dotPaint,
    );

    canvas.restore();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap?.call(row, col);
  }
}

class PicturesGridLinesComponent extends Component {
  final PicturesGridParams params;

  PicturesGridLinesComponent({
    required this.params,
  });

  @override
  void render(Canvas canvas) {
    final radius = 16.r;
    final outerRect = Rect.fromLTWH(0, 0, params.width, params.height);
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    final greyBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(outerRRect, greyBorderPaint);

    if (params.showTimer) {
      final currentTime = params.currentTime;
      final maxTime = params.maxTime;

      final progress =
          maxTime > 0 ? (currentTime / maxTime).clamp(0.0, 1.0) : 0.0;

      Color timerColor;
      if (progress > 0.5) {
        timerColor = const Color(0xFF4CAF50);
      } else if (progress > 0.16) {
        timerColor = const Color(0xFFFF9800);
      } else {
        timerColor = const Color(0xFFC92120);
      }

      _drawTimerLine(canvas, outerRect, radius, progress, timerColor);
    }

    final innerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int col = 1; col < params.columns; col++) {
      final x = col * params.tileWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, params.height), innerPaint);
    }

    for (int row = 1; row < params.rows; row++) {
      final y = row * params.tileHeight;
      canvas.drawLine(Offset(0, y), Offset(params.width, y), innerPaint);
    }
  }

  void _drawTimerLine(
      Canvas canvas, Rect rect, double radius, double progress, Color color) {
    final width = rect.width;
    final height = rect.height;

    final cornerCircumference = 2 * pi * radius;
    final totalPerimeter = (width - 2 * radius) * 2 +
        (height - 2 * radius) * 2 +
        cornerCircumference;

    final traveledDistance = totalPerimeter * (1.0 - progress);

    final timerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.butt;

    if (progress <= 0.001) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        timerPaint,
      );
      return;
    }

    final path = Path();
    path.moveTo(radius, 0);

    double accumulatedDistance = 0;

    final topEdgeLength = width - 2 * radius;
    if (traveledDistance <= accumulatedDistance + topEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(radius + lineEnd, 0);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(width - radius, 0);
    accumulatedDistance += topEdgeLength;

    final topRightArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + topRightArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / topRightArcLength;
      path.arcTo(
        Rect.fromLTWH(width - 2 * radius, 0, 2 * radius, 2 * radius),
        -pi / 2,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(width - 2 * radius, 0, 2 * radius, 2 * radius),
      -pi / 2,
      pi / 2,
      false,
    );
    accumulatedDistance += topRightArcLength;

    final rightEdgeLength = height - 2 * radius;
    if (traveledDistance <= accumulatedDistance + rightEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(width, radius + lineEnd);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(width, height - radius);
    accumulatedDistance += rightEdgeLength;

    final bottomRightArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + bottomRightArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / bottomRightArcLength;
      path.arcTo(
        Rect.fromLTWH(
            width - 2 * radius, height - 2 * radius, 2 * radius, 2 * radius),
        0,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(
          width - 2 * radius, height - 2 * radius, 2 * radius, 2 * radius),
      0,
      pi / 2,
      false,
    );
    accumulatedDistance += bottomRightArcLength;

    final bottomEdgeLength = width - 2 * radius;
    if (traveledDistance <= accumulatedDistance + bottomEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(width - radius - lineEnd, height);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(radius, height);
    accumulatedDistance += bottomEdgeLength;

    final bottomLeftArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + bottomLeftArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / bottomLeftArcLength;
      path.arcTo(
        Rect.fromLTWH(0, height - 2 * radius, 2 * radius, 2 * radius),
        pi / 2,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(0, height - 2 * radius, 2 * radius, 2 * radius),
      pi / 2,
      pi / 2,
      false,
    );
    accumulatedDistance += bottomLeftArcLength;

    final leftEdgeLength = height - 2 * radius;
    if (traveledDistance <= accumulatedDistance + leftEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(0, height - radius - lineEnd);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(0, radius);
    accumulatedDistance += leftEdgeLength;

    final topLeftArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + topLeftArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / topLeftArcLength;
      path.arcTo(
        Rect.fromLTWH(0, 0, 2 * radius, 2 * radius),
        pi,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }

    path.arcTo(
      Rect.fromLTWH(0, 0, 2 * radius, 2 * radius),
      pi,
      pi / 2,
      false,
    );
    path.lineTo(radius, 0);

    canvas.drawPath(path, timerPaint);
  }
}

class PicturesGridParams {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  final Function(int, int) onCellTapped;
  final Color borderColor;
  final bool useInnerPadding;
  int currentTime;
  final int maxTime;
  final bool showTimer;
  final bool isImageLoading;

  PicturesGridParams({
    required this.width,
    required this.height,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.onCellTapped,
    required this.borderColor,
    this.useInnerPadding = true,
    this.currentTime = 60,
    this.maxTime = 60,
    this.showTimer = true,
    this.isImageLoading = false,
  });
}
