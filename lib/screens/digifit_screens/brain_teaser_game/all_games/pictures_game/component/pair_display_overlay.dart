import 'dart:async';
import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kusel/common_widgets/image_utility.dart';

class PairDisplayGame extends FlameGame {
  final String image1Url;
  final String image2Url;
  final double width;
  final double height;
  final int sourceId;
  final BaseCacheManager? cacheManager;
  final bool showButtons;

  PairDisplayGame({
    required this.image1Url,
    required this.image2Url,
    required this.width,
    required this.height,
    this.sourceId = 1,
    this.cacheManager,
    this.showButtons = false,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(width, height),
    );

    final component = PairDisplayComponent(
      image1Url: image1Url,
      image2Url: image2Url,
      width: width,
      height: height,
      sourceId: sourceId,
      cacheManager: cacheManager,
    );
    add(component);
  }
}

class PairDisplayComponent extends PositionComponent with HasGameRef {
  final String image1Url;
  final String image2Url;
  final double width;
  final double height;
  final int sourceId;
  final BaseCacheManager? cacheManager;

  ui.Image? _image1;
  ui.Image? _image2;
  bool _isLoading = true;
  bool _hasError = false;

  static const double imageSpacing = 16.0;

  PairDisplayComponent({
    required this.image1Url,
    required this.image2Url,
    required this.width,
    required this.height,
    this.sourceId = 1,
    this.cacheManager,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2(width, height);
    position = Vector2(0, 0);
    anchor = Anchor.topLeft;

    await _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      if (image1Url.isEmpty || image2Url.isEmpty) {
        _isLoading = false;
        _hasError = true;
        return;
      }

      final processedUrl1 = ImageUtil.getProcessedImageUrl(
        imageUrl: image1Url,
        sourceId: sourceId,
      );
      final processedUrl2 = ImageUtil.getProcessedImageUrl(
        imageUrl: image2Url,
        sourceId: sourceId,
      );

      final cacheManagerInstance = cacheManager ?? DefaultCacheManager();

      // Load image 1
      final file1 = await cacheManagerInstance.getSingleFile(processedUrl1);
      final bytes1 = await file1.readAsBytes();
      final codec1 = await ui.instantiateImageCodec(bytes1);
      final frame1 = await codec1.getNextFrame();
      _image1 = frame1.image;

      // Load image 2
      final file2 = await cacheManagerInstance.getSingleFile(processedUrl2);
      final bytes2 = await file2.readAsBytes();
      final codec2 = await ui.instantiateImageCodec(bytes2);
      final frame2 = await codec2.getNextFrame();
      _image2 = frame2.image;

      _isLoading = false;
      _hasError = false;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isLoading) {
      _renderLoading(canvas);
      return;
    }

    if (_hasError || _image1 == null || _image2 == null) {
      _renderError(canvas);
      return;
    }

    _renderImages(canvas);
  }

  void _renderLoading(Canvas canvas) {
    final center = Offset(size.x / 2 - 10, size.y / 2);
    final circlePaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, 20, circlePaint);
  }

  void _renderError(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Error loading images',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy),
    );
  }

  void _renderImages(Canvas canvas) {
    final imageWidth = (size.x - imageSpacing) / 2 + 10;
    final imageHeight = size.y;

    // Left image
    final rect1 = Rect.fromLTWH(-10, 0, imageWidth, imageHeight);
    final rrect1 = RRect.fromRectAndRadius(rect1, const Radius.circular(12));
    canvas.save();
    canvas.clipRRect(rrect1);
    canvas.drawImageRect(
      _image1!,
      Rect.fromLTWH(
          0, 0, _image1!.width.toDouble(), _image1!.height.toDouble()),
      rect1,
      Paint()..filterQuality = FilterQuality.low,
    );
    canvas.restore();

    // Right image
    final rect2 = Rect.fromLTWH(
      imageWidth + imageSpacing,
      0,
      imageWidth,
      imageHeight,
    );
    final rrect2 = RRect.fromRectAndRadius(rect2, const Radius.circular(12));
    canvas.save();
    canvas.clipRRect(rrect2);
    canvas.drawImageRect(
      _image2!,
      Rect.fromLTWH(
          0, 0, _image2!.width.toDouble(), _image2!.height.toDouble()),
      rect2,
      Paint()..filterQuality = FilterQuality.low,
    );
    canvas.restore();
  }

  @override
  void onRemove() {
    _image1?.dispose();
    _image2?.dispose();
    super.onRemove();
  }
}
