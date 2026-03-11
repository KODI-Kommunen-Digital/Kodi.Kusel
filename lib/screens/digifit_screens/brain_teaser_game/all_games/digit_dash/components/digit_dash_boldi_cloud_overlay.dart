import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../../../../../common_widgets/text_styles.dart';

class DigitDashBoldiCloudOverlayGame extends FlameGame {
  final double width;
  final double height;
  final String? cloudText;
  final Color? textColor;

  DigitDashBoldiCloudOverlayGame({
    required this.width,
    required this.height,
    this.cloudText,
    required this.textColor,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(width, height),
    );

    final overlayCard = BoldiWithSpeechCard(
      width: width,
      height: height,
      text: cloudText ?? '',
      textColor: textColor ?? Colors.black,
    );
    await add(overlayCard);
  }
}

class BoldiWithSpeechCard extends PositionComponent with HasGameRef {
  final double width;
  final double height;
  final String text;
  final Color textColor;

  Sprite? boldiSprite;
  Sprite? bubbleSprite;

  BoldiWithSpeechCard({
    required this.width,
    required this.height,
    required this.text,
    required this.textColor,
  });

  @override
  Future<void> onLoad() async {
    const double horizontalPadding = 14.0;
    const double topMargin = 10.0;
    final double cardWidth = width - (horizontalPadding * 2);
    final double cardHeight = height * 0.8;

    size = Vector2(cardWidth, cardHeight);
    position = Vector2(width / 2 - 14, topMargin);
    anchor = Anchor.topCenter;

    final boldiImage =
        await gameRef.images.load('assets/png/boldi_digit_dash.png');
    boldiSprite = Sprite(boldiImage);

    final bubbleImage =
        await gameRef.images.load('assets/png/cloud_digit_dash_image.png');
    bubbleSprite = Sprite(bubbleImage);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(24),
    );

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRRect(rRect, bgPaint);

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rRect, borderPaint);

    canvas.save();
    canvas.clipRRect(rRect);

    if (boldiSprite != null) {
      canvas.save();

      final boldiWidth = (size.x * 0.45) * 1.11;

      final boldiX = size.x - boldiWidth;

      final spriteAspectRatio = boldiSprite!.srcSize.x / boldiSprite!.srcSize.y;
      final boldiHeight = (boldiWidth / spriteAspectRatio) * 1.2;

      final boldiY = size.y - boldiHeight;

      canvas.translate(boldiX, boldiY);
      boldiSprite!.render(
        canvas,
        size: Vector2(boldiWidth, boldiHeight),
      );
      canvas.restore();
    }

    if (bubbleSprite != null) {
      canvas.save();

      final bubbleX = 26.0;
      final bubbleY = 26.0;
      final bubbleWidth = 160.0;

      final spriteAspectRatio =
          bubbleSprite!.srcSize.x / bubbleSprite!.srcSize.y;
      final bubbleHeight = bubbleWidth / spriteAspectRatio;

      canvas.translate(bubbleX, bubbleY);
      bubbleSprite!.render(
        canvas,
        size: Vector2(bubbleWidth, bubbleHeight),
      );
      canvas.restore();

      final textWidget = textSemiBoldMontserrat(
        text: text,
        fontSize: 16,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

      final textStyle = textWidget.style!;
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: bubbleWidth - 32);
      final offset = Offset(
        bubbleX + (bubbleWidth - textPainter.width) / 2,
        bubbleY + (bubbleHeight - textPainter.height) / 2 - 4,
      );
      textPainter.paint(canvas, offset);
    }

    canvas.restore();
  }
}
