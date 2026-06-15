import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../../../../common_widgets/text_styles.dart';

class FlipCatchBoldiCloudOverlayGame extends FlameGame {
  final double width;
  final double height;
  final String? cloudText;
  final Color? textColor;

  FlipCatchBoldiCloudOverlayGame(
      {required this.width,
      required this.height,
      this.cloudText,
      required this.textColor});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(width, height),
    );

    final boldi = BoldiSpriteComponent();
    await add(boldi);

    final cloud = CloudComponent(color: textColor);
    if (cloudText != null && cloudText!.isNotEmpty) {
      cloud.displayText = cloudText!;
    }
    await add(cloud);
  }
}

class CloudComponent extends PositionComponent with HasGameRef {
  late Sprite _cloudSprite;
  String displayText = "";
  bool _isInitialized = false;
  Color? textColor;

  CloudComponent({Color? color}) {
    anchor = Anchor.center;
    textColor = color;
  }

  @override
  Future<void> onLoad() async {
    final cloudImage =
        await gameRef.images.load('assets/png/cloud_image_math_hunt.png');
    _cloudSprite = Sprite(cloudImage);

    final gameSize = gameRef.size;
    position = Vector2(
      gameSize.x * 0.50,
      gameSize.y * 0.50,
    );

    size = Vector2(158, 124);

    _isInitialized = true;
  }

  @override
  void render(Canvas canvas) {
    if (!_isInitialized) return;

    super.render(canvas);

    _cloudSprite.render(canvas, size: size, anchor: Anchor.center);

    if (displayText.isNotEmpty) {
      _drawText(canvas);
    }
  }

  void _drawText(Canvas canvas) {
    final textWidget = textSemiBoldPoppins(
      text: displayText,
      fontSize: 16,
      color: textColor,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    final textPainter = TextPainter(
      text: TextSpan(text: displayText, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.x * 0.85);

    final textOffset = Offset(
      -textPainter.width / 2 - 8,
      -textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }
}

class BoldiSpriteComponent extends SpriteComponent with HasGameRef {
  BoldiSpriteComponent() {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("assets/png/math_hunt_boldi.png");

    final gameSize = gameRef.size;
    position = Vector2(
      gameSize.x * 0.74,
      gameSize.y * 0.38,
    );

    size = Vector2(
      gameSize.x * 0.58,
      gameSize.y * 0.78,
    );
  }
}
