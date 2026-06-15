import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kusel/common_widgets/image_utility.dart';

enum CornerRadius {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class PictureOverlayGame extends FlameGame {
  final List<PicturePosition> pictures;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final int sourceId;
  final BaseCacheManager? cacheManager;

  final int gridRows;
  final int gridColumns;

  int _loadedCount = 0;

  int get totalImages => pictures.length;

  bool get allImagesLoaded => _loadedCount >= totalImages;

  PictureOverlayGame({
    required this.pictures,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    required this.gridRows,
    required this.gridColumns,
    this.sourceId = 3,
    this.cacheManager,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    for (final picture in pictures) {
      CornerRadius cornerToRound = CornerRadius.none;

      // Determine which specific corner to round
      if (picture.row == 0 && picture.col == 0) {
        cornerToRound = CornerRadius.topLeft;
      } else if (picture.row == 0 && picture.col == gridColumns - 1) {
        cornerToRound = CornerRadius.topRight;
      } else if (picture.row == gridRows - 1 && picture.col == 0) {
        cornerToRound = CornerRadius.bottomLeft;
      } else if (picture.row == gridRows - 1 &&
          picture.col == gridColumns - 1) {
        cornerToRound = CornerRadius.bottomRight;
      }

      final component = PictureComponent(
        row: picture.row,
        column: picture.col,
        imageUrl: picture.imageUrl,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        sourceId: sourceId,
        cacheManager: cacheManager,
        cornerToRound: cornerToRound,
        onImageLoaded: _onImageLoaded,
      );
      add(component);
    }
  }

  void _onImageLoaded() {
    _loadedCount++;
  }
}

class PictureComponent extends PositionComponent {
  final int row;
  final int column;
  final String imageUrl;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final int sourceId;
  final BaseCacheManager? cacheManager;
  final CornerRadius cornerToRound;
  final VoidCallback? onImageLoaded;

  ui.Image? _loadedImage;
  bool _isLoading = true;
  bool _hasError = false;

  double _loaderRotation = 0.0;

  PictureComponent({
    required this.row,
    required this.column,
    required this.imageUrl,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.sourceId = 3,
    this.cacheManager,
    this.cornerToRound = CornerRadius.none,
    this.onImageLoaded,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);

    const padding = 3.0;
    size = Vector2(tileWidth - padding, tileHeight - padding);

    anchor = Anchor.center;

    _loadCachedNetworkImage();
  }

  Future<void> _loadCachedNetworkImage() async {
    try {
      if (imageUrl.isEmpty) {
        _isLoading = false;
        _hasError = true;
        return;
      }

      final processedUrl = ImageUtil.getProcessedImageUrl(
        imageUrl: imageUrl,
        sourceId: 1,
      );

      final cacheManagerInstance = cacheManager ?? DefaultCacheManager();
      final file = await cacheManagerInstance.getSingleFile(processedUrl);
      final bytes = await file.readAsBytes();

      final targetSize = (tileWidth * 2).toInt();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetSize,
        targetHeight: targetSize,
      );
      final frameInfo = await codec.getNextFrame();
      _loadedImage = frameInfo.image;
      _isLoading = false;
      _hasError = false;

      onImageLoaded?.call();
    } catch (e) {
      debugPrint('Error loading cached image: $e');
      _isLoading = false;
      _hasError = true;
      _loadedImage = null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isLoading) {
      _loaderRotation += dt * 3.0;
      if (_loaderRotation > 2 * pi) {
        _loaderRotation -= 2 * pi;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isLoading) {
      _renderLoader(canvas);
      return;
    }

    if (_hasError || _loadedImage == null) {
      _renderError(canvas);
      return;
    }

    _renderImage(canvas);
  }

  void _renderLoader(Canvas canvas) {
    final rect = size.toRect();

    final basePaint = Paint()..color = Colors.grey[200]!;
    canvas.drawRect(rect, basePaint);

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

    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, borderPaint);
  }

  void _renderError(Canvas canvas) {
    final errorPaint = Paint()..color = Colors.grey[300]!;
    canvas.drawRect(size.toRect(), errorPaint);

    final iconSize = 24.0;
    final iconRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: iconSize,
      height: iconSize,
    );

    final iconPaint = Paint()..color = Colors.grey[600]!;
    canvas.drawRect(iconRect, iconPaint);
  }

  void _renderImage(Canvas canvas) {
    final srcRect = Rect.fromLTWH(
      0,
      0,
      _loadedImage!.width.toDouble(),
      _loadedImage!.height.toDouble(),
    );

    final dstRect = size.toRect();

    RRect rrect;
    const radius = 16.0;

    if (cornerToRound == CornerRadius.none) {
      rrect = RRect.fromRectAndRadius(dstRect, Radius.zero);
    } else {
      rrect = RRect.fromRectAndCorners(
        dstRect,
        topLeft: cornerToRound == CornerRadius.topLeft
            ? Radius.circular(radius)
            : Radius.zero,
        topRight: cornerToRound == CornerRadius.topRight
            ? Radius.circular(radius)
            : Radius.zero,
        bottomLeft: cornerToRound == CornerRadius.bottomLeft
            ? Radius.circular(radius)
            : Radius.zero,
        bottomRight: cornerToRound == CornerRadius.bottomRight
            ? Radius.circular(radius)
            : Radius.zero,
      );
    }

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawImageRect(
      _loadedImage!,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
  }

  @override
  void onRemove() {
    _loadedImage?.dispose();
    super.onRemove();
  }
}

class PicturePosition {
  final int row;
  final int col;
  final String imageUrl;

  const PicturePosition({
    required this.row,
    required this.col,
    required this.imageUrl,
  });
}
