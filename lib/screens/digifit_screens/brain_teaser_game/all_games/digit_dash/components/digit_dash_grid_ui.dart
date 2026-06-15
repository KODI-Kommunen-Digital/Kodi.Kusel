import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common_widgets/text_styles.dart';

class DigitDashGridOverlayGame extends FlameGame {
  final DigitDashGridParams gridParams;

  DigitDashGridOverlayGame({required this.gridParams});

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(
        gridParams.width,
        gridParams.height,
      ),
    );

    _buildGridCards();

    add(DigitDashGridLinesComponent(
      gridParams: gridParams,
    ));
  }

  void _buildGridCards() {
    final totalNumbers = gridParams.gridNumbers?.length ?? 0;
    int numberIndex = 0;

    for (int row = 0; row < gridParams.rows; row++) {
      for (int col = 0; col < gridParams.columns; col++) {
        final x = col * gridParams.tileWidth + gridParams.tileWidth / 2;
        final y = row * gridParams.tileHeight + gridParams.tileHeight / 2;

        final number = numberIndex < totalNumbers
            ? gridParams.gridNumbers![numberIndex]
            : null;

        final isMarkedCorrect =
            numberIndex < (gridParams.markedCorrect?.length ?? 0)
                ? gridParams.markedCorrect![numberIndex]
                : false;

        final isMarkedWrong =
            numberIndex < (gridParams.markedWrong?.length ?? 0)
                ? gridParams.markedWrong![numberIndex]
                : false;

        final isSelected = gridParams.selectedIndex == numberIndex;

        final rotation = numberIndex < (gridParams.gridAngles?.length ?? 0)
            ? gridParams.gridAngles![numberIndex]
            : 0.0;

        final card = DigitDashCard(
          position: Vector2(x, y),
          size: Vector2(gridParams.tileWidth, gridParams.tileHeight),
          borderRadius: _getBorderRadius(row, col),
          row: row,
          col: col,
          number: number,
          index: numberIndex,
          isMarkedCorrect: isMarkedCorrect,
          isMarkedWrong: isMarkedWrong,
          isSelected: isSelected,
          isAnswerCorrect: gridParams.isAnswerCorrect,
          textRotation: rotation,
          onTap: gridParams.onNumberTap,
          isEnabled: gridParams.isEnabled,
          levelId: gridParams.levelId,
          targetCondition: gridParams.targetCondition,
          gridParams: gridParams,
        );
        add(card);
        numberIndex++;
      }
    }
  }

  BorderRadius? _getBorderRadius(int row, int col) {
    final radius = 16.r;
    final isTopLeft = row == 0 && col == 0;
    final isTopRight = row == 0 && col == gridParams.columns - 1;
    final isBottomLeft = row == gridParams.rows - 1 && col == 0;
    final isBottomRight =
        row == gridParams.rows - 1 && col == gridParams.columns - 1;

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

class DigitDashCard extends PositionComponent
    with TapCallbacks, HasGameReference<DigitDashGridOverlayGame> {
  BorderRadius? borderRadius;
  int? row;
  int? col;
  int? number;
  int index;
  bool isMarkedCorrect;
  bool isMarkedWrong;
  bool isSelected;
  bool? isAnswerCorrect;
  Function(int)? onTap;
  bool isEnabled;
  double textRotation;
  int? levelId;
  String? targetCondition;
  final DigitDashGridParams gridParams;

  late TextComponent numberText;

  int? _lastNumber;
  bool _lastMarkedCorrect = false;
  bool _lastMarkedWrong = false;
  bool _lastSelected = false;
  bool? _lastAnswerCorrect;

  DigitDashCard({
    required super.position,
    required super.size,
    this.borderRadius,
    this.row,
    this.col,
    this.number,
    required this.index,
    required this.isMarkedCorrect,
    required this.isMarkedWrong,
    required this.isSelected,
    this.isAnswerCorrect,
    required this.textRotation,
    this.onTap,
    required this.isEnabled,
    this.levelId,
    this.targetCondition,
    required this.gridParams,
  }) {
    anchor = Anchor.center;
    _lastNumber = number;
    _lastMarkedCorrect = isMarkedCorrect;
    _lastMarkedWrong = isMarkedWrong;
    _lastSelected = isSelected;
    _lastAnswerCorrect = isAnswerCorrect;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    String displayText = number?.toString() ?? '';
    if (number == 6 || number == 9) {
      displayText = '$displayText.';
    }

    final textWidget = textSemiBoldPoppins(
      text: displayText,
      fontSize: 20,
      color: gridParams.textColor,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    numberText = TextComponent(
      text: displayText,
      textRenderer: TextPaint(style: textStyle),
    );

    numberText.anchor = Anchor.center;
    numberText.position = Vector2(size.x / 2, size.y / 2);
    numberText.angle = textRotation;

    add(numberText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (index < (gridParams.markedCorrect?.length ?? 0)) {
      isMarkedCorrect = gridParams.markedCorrect![index];
    }
    if (index < (gridParams.markedWrong?.length ?? 0)) {
      isMarkedWrong = gridParams.markedWrong![index];
    }
    isSelected = gridParams.selectedIndex == index;
    isAnswerCorrect = gridParams.isAnswerCorrect;
    isEnabled = gridParams.isEnabled;

    final stateChanged = _lastMarkedCorrect != isMarkedCorrect ||
        _lastMarkedWrong != isMarkedWrong ||
        _lastSelected != isSelected ||
        _lastAnswerCorrect != isAnswerCorrect;

    if (stateChanged) {
      _lastMarkedCorrect = isMarkedCorrect;
      _lastMarkedWrong = isMarkedWrong;
      _lastSelected = isSelected;
      _lastAnswerCorrect = isAnswerCorrect;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = size.toRect();

    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (borderRadius != null) {
      canvas.drawRRect(borderRadius!.toRRect(rect), whiteFillPaint);
    } else {
      canvas.drawRect(rect, whiteFillPaint);
    }

    if (isMarkedCorrect) {
      _drawFill(canvas, rect);
    } else if (isMarkedWrong || (isSelected && isAnswerCorrect == false)) {
      _drawRedBorder(canvas, rect);
    } else if (isSelected && isAnswerCorrect == true) {
      _drawFill(canvas, rect);
    }
  }

  void _drawFill(Canvas canvas, Rect rect) {
    const padding = 8.0;
    final paddedRect = Rect.fromLTRB(
      rect.left + padding,
      rect.top + padding,
      rect.right - padding,
      rect.bottom - padding,
    );

    final fillRRect =
        RRect.fromRectAndRadius(paddedRect, const Radius.circular(8.0));

    Color fillColor = const Color(0xFFAADB40).withOpacity(0.75);

    if (levelId == 11) {
      final condition = targetCondition
              ?.toLowerCase()
              .replaceAll(' ', '_')
              .replaceAll('-', '_') ??
          '';
      if (condition.contains('odd')) {
        fillColor = const Color(0xFF4A90E2).withOpacity(0.8);
      } else if (condition.contains('even')) {
        fillColor = const Color(0xFFD0021B).withOpacity(0.8);
      }
    }

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(fillRRect, fillPaint);
  }

  void _drawRedBorder(Canvas canvas, Rect rect) {
    const padding = 8.0;
    final paddedRect = Rect.fromLTRB(
      rect.left + padding,
      rect.top + padding,
      rect.right - padding,
      rect.bottom - padding,
    );

    final fillRRect =
        RRect.fromRectAndRadius(paddedRect, const Radius.circular(8.0));

    final redBorderPaint = Paint()
      ..color = const Color(0xFFC92120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawRRect(fillRRect, redBorderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isEnabled || isMarkedCorrect || isMarkedWrong) return;
    onTap?.call(index);
  }
}

class DigitDashGridLinesComponent extends Component {
  final DigitDashGridParams gridParams;

  DigitDashGridLinesComponent({
    required this.gridParams,
  });

  @override
  void render(Canvas canvas) {
    final radius = 16.r;
    final outerRect = Rect.fromLTWH(0, 0, gridParams.width, gridParams.height);
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    final currentTime = gridParams.currentTime;
    final maxTime = gridParams.maxTime;

    final progress = maxTime > 0 ? currentTime / maxTime : 0.0;

    Color timerColor;
    if (progress > 0.5) {
      timerColor = const Color(0xFF4CAF50);
    } else if (progress > 0.16) {
      timerColor = const Color(0xFFFF9800);
    } else {
      timerColor = const Color(0xFFC92120);
    }

    final greyBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(outerRRect, greyBorderPaint);

    _drawTimerLine(canvas, outerRect, radius, progress, timerColor);

    _drawInnerGridLines(canvas, radius);
  }

  void _drawInnerGridLines(Canvas canvas, double radius) {
    final innerPaint = Paint()
      ..color = gridParams.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int col = 1; col < gridParams.columns; col++) {
      final x = col * gridParams.tileWidth;

      final topStartY =
          (x < radius || x > gridParams.width - radius) ? radius : 0.0;
      final bottomEndY = (x < radius || x > gridParams.width - radius)
          ? gridParams.height - radius
          : gridParams.height;

      canvas.drawLine(
        Offset(x, topStartY),
        Offset(x, bottomEndY),
        innerPaint,
      );
    }

    for (int row = 1; row < gridParams.rows; row++) {
      final y = row * gridParams.tileHeight;

      final leftStartX =
          (y < radius || y > gridParams.height - radius) ? radius : 0.0;
      final rightEndX = (y < radius || y > gridParams.height - radius)
          ? gridParams.width - radius
          : gridParams.width;

      canvas.drawLine(
        Offset(leftStartX, y),
        Offset(rightEndX, y),
        innerPaint,
      );
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

    final traveledDistance = totalPerimeter * (1 - progress);

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

class DigitDashGridParams {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  List<int?>? gridNumbers;
  List<double>? gridAngles;
  List<bool>? markedCorrect;
  List<bool>? markedWrong;
  int? selectedIndex;
  bool? isAnswerCorrect;
  final Function(int) onNumberTap;
  bool isEnabled;
  final Color borderColor;
  final String? targetCondition;
  final int? levelId;
  int currentTime;
  final int maxTime;
  final Color textColor;

  DigitDashGridParams(
      {required this.width,
      required this.height,
      required this.tileHeight,
      required this.tileWidth,
      required this.rows,
      required this.columns,
      this.gridNumbers,
      this.gridAngles,
      this.markedCorrect,
      this.markedWrong,
      this.selectedIndex,
      this.isAnswerCorrect,
      required this.onNumberTap,
      required this.isEnabled,
      required this.borderColor,
      this.targetCondition,
      this.levelId,
      this.currentTime = 60,
      this.maxTime = 60,
      required this.textColor});
}
