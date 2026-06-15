import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../../../common_widgets/text_styles.dart';
import '../../../../../l10n/app_localizations.dart';

class MathGameUI extends FlameGame with TapCallbacks {
  late SpriteComponent characterSprite;
  CloudTextComponent? cloudText;
  final BuildContext context;

  final VoidCallback onGameStart;
  final Function(int) onOptionSelected;

  MathGameUI(
      {required this.onGameStart,
      required this.onOptionSelected,
      required this.context});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await _initializeCharacter();
    await _initializeCloudText();
  }

  Future<void> _initializeCharacter() async {
    final characterImage = await images.load("assets/png/math_hunt_boldi.png");
    characterSprite = SpriteComponent.fromImage(
      characterImage,
      position: Vector2(size.x * 0.74, size.y * 0.38),
      size: Vector2(size.x * 0.58, size.y * 0.96),
    );
    characterSprite.anchor = Anchor.center;
    await add(characterSprite);
  }

  Future<void> _initializeCloudText() async {
    cloudText = CloudTextComponent(context: context);
    cloudText!.position = Vector2(size.x * 0.50, size.y * 0.45);
    cloudText!.size = Vector2(size.x * 0.50, size.y * 0.20);
    cloudText!.cloudSize = Vector2(size.x * 0.50, size.y * 0.41);
    cloudText!.anchor = Anchor.center;
    cloudText!.currentText = AppLocalizations.of(context).math_hunt_game_desc;
    await add(cloudText!);
  }

  void updateGameState({
    required String problem,
    required bool showProblem,
    required bool showOptions,
    required List<String> options,
    bool showTimer = false,
    bool? isAnswerCorrect,
    int? selectedAnswerIndex,
    double? timerDuration,
  }) {
    if (cloudText == null) return;

    if (showOptions) {
      cloudText!.showOptions(
        options,
        onOptionSelected,
        isAnswerCorrect,
        selectedAnswerIndex,
      );
    } else if (showProblem && showTimer) {
      if (cloudText!.currentDisplayedProblem != problem) {
        cloudText!.showCircularProgress(
          problem,
          showTimer: true,
          duration: timerDuration,
        );
      }
    } else if (showProblem && !showTimer) {
      cloudText!.showWelcomeMessage(problem);
    }
  }

  void pauseTimer() {
    cloudText?.pauseTimer();
  }

  void resumeTimer() {
    cloudText?.resumeTimer();
  }

  @override
  bool onTapDown(TapDownEvent event) {
    return true;
  }
}

class CloudTextComponent extends PositionComponent with HasGameRef<MathGameUI> {
  late Vector2 cloudSize;
  String currentText = "";
  String currentDisplayedProblem = "";
  late Sprite speechBubbleSprite;
  bool _isInitialized = false;
  final BuildContext context;

  CircularProgressArrowComponent? circularProgressArrowComponent;
  List<OptionButtonComponent> optionButtons = [];

  double scaleAnimation = 1.0;
  bool isAnimating = false;
  double pulseAnimation = 0.0;

  CloudTextComponent({required this.context});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final speechBubbleImage =
        await gameRef.images.load("assets/png/cloud_image_math_hunt.png");
    speechBubbleSprite = Sprite(speechBubbleImage);
    _isInitialized = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAnimating) {
      scaleAnimation += dt * 6;
      if (scaleAnimation >= 1.15) {
        scaleAnimation = 1.0;
        isAnimating = false;
      }
    }

    pulseAnimation += dt * 2;
    if (pulseAnimation > 6.28) pulseAnimation = 0;
  }

  @override
  void render(Canvas canvas) {
    if (!_isInitialized) return;

    super.render(canvas);

    canvas.save();
    final pulseScale = 1.0 + (math.sin(pulseAnimation) * 0.01);
    canvas.scale(pulseScale, pulseScale);
    speechBubbleSprite.render(canvas, size: cloudSize, anchor: Anchor.center);
    canvas.restore();

    canvas.save();
    canvas.scale(scaleAnimation, scaleAnimation);

    if (circularProgressArrowComponent == null && optionButtons.isEmpty) {
      _drawText(canvas);
    }
    canvas.restore();
  }

  void showWelcomeMessage(String text) {
    clearContent();
    _resetToWelcomeSize();
    currentText = text;
    currentDisplayedProblem = "";
    isAnimating = false;
    scaleAnimation = 1.0;
  }

  void showCircularProgress(String textPhase,
      {bool showTimer = false, double? duration}) {
    if (circularProgressArrowComponent != null) {
      circularProgressArrowComponent!.removeFromParent();
      circularProgressArrowComponent = null;
    }

    currentText = "";
    currentDisplayedProblem = textPhase;

    if (showTimer) {
      _resizeForTimer();

      circularProgressArrowComponent = CircularProgressArrowComponent(
          radius: 40,
          displayText: textPhase,
          duration: duration ?? 4.0,
          context: context);
      circularProgressArrowComponent!.position = Vector2(-5, -5);
      circularProgressArrowComponent!.anchor = Anchor.center;
      add(circularProgressArrowComponent!);
    }
  }

  void _resetToWelcomeSize() {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    size = Vector2(200, 80);
    cloudSize = Vector2(160, 140);

    position = Vector2(screenWidth * 0.50, screenHeight * 0.54);
  }

  void _resizeForTimer() {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    size = Vector2(200, 80);
    cloudSize = Vector2(168, 163);

    position = Vector2(screenWidth * 0.54, screenHeight * 0.52);
  }

  void _resizeForOptions() {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    size = Vector2(200, 80);
    cloudSize = Vector2(164, 211);

    position = Vector2(screenWidth * 0.54, screenHeight * 0.60);
  }

  void clearContent() {
    if (circularProgressArrowComponent != null) {
      circularProgressArrowComponent!.removeFromParent();
      circularProgressArrowComponent = null;
    }

    for (var button in optionButtons) {
      button.removeFromParent();
    }
    optionButtons.clear();

    currentText = "";
    currentDisplayedProblem = "";
  }

  void _drawText(Canvas canvas) {
    if (currentText.isEmpty) return;

    final textWidget = textSemiBoldPoppins(
      text: currentText,
      fontSize: 16,
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: currentText, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: cloudSize.x * 0.9);
    final textOffset = Offset(
      -textPainter.width / 2 - 5,
      -textPainter.height / 2 - 5,
    );
    textPainter.paint(canvas, textOffset);
  }

  void pauseTimer() {
    if (circularProgressArrowComponent != null) {
      circularProgressArrowComponent!.pause();
    } else {}
  }

  void resumeTimer() {
    if (circularProgressArrowComponent != null) {
      circularProgressArrowComponent!.resume();
    } else {}
  }

  void showOptions(
    List<String> options,
    Function(int) onOptionSelected,
    bool? isAnswerCorrect,
    int? selectedAnswerIndex,
  ) {
    clearContent();
    currentText = "";
    _resizeForOptions();

    double buttonWidth = cloudSize.x * 0.54;
    double buttonHeight = 42;
    double spacing = 15;
    double topPadding = 2;
    double startY = -cloudSize.y / 2 + topPadding + buttonHeight / 2;

    for (int i = 0; i < options.length; i++) {
      bool? buttonCorrectness;
      if (selectedAnswerIndex != null && isAnswerCorrect != null) {
        if (i == selectedAnswerIndex) {
          buttonCorrectness = isAnswerCorrect;
        }
      }

      final button = OptionButtonComponent(
        label: options[i],
        position: Vector2(
          -buttonWidth / 2 - 8,
          startY + (i * (buttonHeight + spacing)),
        ),
        width: buttonWidth,
        height: buttonHeight,
        isCorrect: buttonCorrectness,
        context: context,
        onTap: () {
          if (selectedAnswerIndex == null) {
            onOptionSelected(i);
          }
        },
      );
      optionButtons.add(button);
      add(button);
    }
  }
}

class OptionButtonComponent extends PositionComponent with TapCallbacks {
  final String label;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double cornerRadius;
  final Paint _bgPaint;
  bool? isCorrect;
  final BuildContext context;

  OptionButtonComponent({
    required this.label,
    required Vector2 position,
    required this.onTap,
    required this.context,
    this.width = 150,
    this.height = 50,
    this.cornerRadius = 50,
    this.isCorrect,
  })  : _bgPaint = Paint()..color = Theme.of(context).primaryColor,
        super(
          position: position,
          size: Vector2(width, height),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    Color bgColor = const Color(0xFF27348B);
    if (isCorrect != null) {
      bgColor = isCorrect! ? const Color(0xFFAADB40) : const Color(0xFFC92120);
    }
    _bgPaint.color = bgColor;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius));
    canvas.drawRRect(rrect, _bgPaint);

    final icon =
        isCorrect == null ? null : (isCorrect! ? Icons.check : Icons.close);

    final textColor =
        isCorrect == true ? Theme.of(context).primaryColor : Colors.white;

    final textWidget = textSemiBoldPoppins(
      text: label,
      fontSize: 16,
      color: textColor,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    TextPainter? iconPainter;
    if (icon != null) {
      final iconColor =
          isCorrect! ? Theme.of(context).primaryColor : Colors.white;

      iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 20,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: iconColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
    }

    final double spacing = iconPainter != null ? 8.0 : 0.0;
    final double totalWidth =
        (iconPainter?.width ?? 0) + spacing + textPainter.width;

    double startX = (size.x - totalWidth) / 2;
    final centerY = size.y / 2;

    if (iconPainter != null) {
      final iconY = centerY - iconPainter.height / 2;
      iconPainter.paint(canvas, Offset(startX, iconY));
      startX += iconPainter.width + spacing;
    }

    final textY = centerY - textPainter.height / 2;
    textPainter.paint(canvas, Offset(startX, textY));

    super.render(canvas);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onTap();
    return true;
  }
}

class CircularProgressArrowComponent extends PositionComponent {
  final double radius;
  String displayText;
  double progress = 0;
  final double duration;
  double _elapsed = 0;
  bool _isPaused = false;
  final BuildContext context;

  CircularProgressArrowComponent(
      {required this.radius,
      required this.displayText,
      this.duration = 4.0,
      required this.context})
      : super(size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  void onMount() {
    super.onMount();
  }

  void pause() {
    if (_isPaused) return;
    _isPaused = true;
  }

  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (duration > 0 && !_isPaused) {
      _elapsed += dt;
      progress = (_elapsed / duration).clamp(0.0, 1.0);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius, bgPaint);

    if (duration > 0 && progress > 0) {
      final progressPaint = Paint()
        ..color = Theme.of(context).primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    final textWidget = textSemiBoldPoppins(
      text: displayText,
      fontSize: 56,
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
      fontWeight: FontWeight.w500,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: displayText, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset =
        center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
