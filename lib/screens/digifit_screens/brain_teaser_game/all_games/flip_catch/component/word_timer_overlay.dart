import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../../../../common_widgets/text_styles.dart';

class WordTimerOverlayGame extends FlameGame {
  final List<String> targetWords;
  final int durationSeconds;
  final double width;
  final double height;
  final Color timerColor;
  final Color? textColor;

  WordTimerComponent? _wordTimer;

  WordTimerOverlayGame({
    required this.targetWords,
    required this.durationSeconds,
    required this.width,
    required this.height,
    required this.timerColor,
    required this.textColor,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(width, height),
    );

    _wordTimer = WordTimerComponent(
        targetWords: targetWords,
        durationSeconds: durationSeconds,
        timerColor: timerColor,
        width: width,
        height: height,
        textColor: textColor);
    add(_wordTimer!);
  }

  void pauseTimer() => _wordTimer?.pauseTimer();

  void resumeTimer() => _wordTimer?.resumeTimer();

  void stopTimer() {
    _wordTimer?.stopTimer();
    _wordTimer = null;
  }
}

class WordTimerComponent extends PositionComponent with HasGameRef {
  final List<String> targetWords;
  final int durationSeconds;
  final Color timerColor;
  final double width;
  final double height;
  final Color? textColor;

  double _progress = 0.0;
  double _elapsed = 0.0;
  double _pausedAt = 0.0;
  double _totalPausedDuration = 0.0;
  bool _isStopped = false;
  bool _isPaused = false;

  WordTimerComponent({
    required this.targetWords,
    required this.durationSeconds,
    required this.timerColor,
    required this.width,
    required this.height,
    required this.textColor,
  });

  late RRect _containerRect;

  @override
  Future<void> onLoad() async {
    const horizontalPaddingInside = 20.0;
    const verticalPaddingTop = 60.0;
    const verticalPaddingBottom = 60.0;
    const topMargin = 9.0;
    const circleRadius = 35.0;
    const horizontalScreenPadding = 14.0;
    const extraCardHeight = 20.0;

    final cardWidth = width - (horizontalScreenPadding * 2);

    final combinedText = targetWords.join('   ');

    final textWidget = textSemiBoldPoppins(
      text: combinedText,
      fontSize: 20,
      color: textColor,
      fontWeight: FontWeight.w500,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: combinedText, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: cardWidth - horizontalPaddingInside * 2);

    final cardHeight = verticalPaddingTop +
        textPainter.height +
        (circleRadius * 2) +
        verticalPaddingBottom +
        extraCardHeight;

    size = Vector2(cardWidth, cardHeight);
    position = Vector2(width / 2, topMargin);
    anchor = Anchor.topCenter;

    _containerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(24),
    );
  }

  void pauseTimer() {
    if (_isStopped || _isPaused) return;
    _isPaused = true;
    _pausedAt = _elapsed;
  }

  void resumeTimer() {
    if (_isStopped || !_isPaused) return;
    _isPaused = false;

    final pauseDuration = _elapsed - _pausedAt;
    _totalPausedDuration += pauseDuration;
  }

  void stopTimer() {
    _isStopped = true;
    removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isStopped || _isPaused) return;

    _elapsed += dt;

    final effectiveDuration = durationSeconds + _totalPausedDuration;

    if (_elapsed > effectiveDuration) {
      _elapsed = effectiveDuration;
    }

    _progress =
        ((_elapsed - _totalPausedDuration) / durationSeconds).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    if (_isStopped) return;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(_containerRect, bgPaint);

    const double horizontalPaddingInside = 20.0;
    const double circleRadius = 35.0;
    const double spaceBetweenTextAndCircle = 30.0;

    final textWidget = textSemiBoldPoppins(
      text: targetWords.join('   '),
      fontSize: 22,
      color: textColor,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: targetWords.join('   '), style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.x - horizontalPaddingInside * 2);

    final totalContentHeight =
        textPainter.height + spaceBetweenTextAndCircle + (circleRadius * 2);

    final topOffset = (size.y - totalContentHeight) / 2 + 10;

    final textOffset = Offset((size.x - textPainter.width) / 2, topOffset);
    textPainter.paint(canvas, textOffset);

    final double circleTop =
        textOffset.dy + textPainter.height + spaceBetweenTextAndCircle;
    final center = Offset(size.x / 2, circleTop + circleRadius);

    final circleBgPaint = Paint()
      ..color = const Color(0xFFEAEBF3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    canvas.drawCircle(center, circleRadius, circleBgPaint);

    final progressPaint = Paint()
      ..color = timerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: circleRadius),
      -pi / 2,
      2 * pi * _progress,
      false,
      progressPaint,
    );
  }
}
