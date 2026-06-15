import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/utility/image_loader_utility.dart';
import 'custom_cache_manager.dart';

class ImageUtil {
  static Widget loadNetworkImage({
    required String imageUrl,
    String? svgErrorImagePath,
    CustomCacheManager? cacheMemory,
    required BuildContext context,
    double? height,
    double? width,
    int? memCacheHeight,
    int? memCacheWidth,
    BoxFit? fit,

      Function()? onImageTap,
      int? sourceId
      }) {
    return GestureDetector(
      onTap: onImageTap,
      child: CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        height: height,
        filterQuality: FilterQuality.high,
        width: width,
        imageUrl: imageLoaderUtility(image: imageUrl, sourceId: sourceId ?? 3),
        memCacheHeight: memCacheHeight ?? 600,
        memCacheWidth: memCacheWidth ?? 800,
        progressIndicatorBuilder: (context, value, _) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (context, value, _) {
          return (svgErrorImagePath != null)
              ? SvgPicture.asset(svgErrorImagePath)
              : Icon(Icons.broken_image);
        },
      ),
    );
  }

  // ADD THIS NEW METHOD - just returns the processed URL string
  static String getProcessedImageUrl({
    required String imageUrl,
    required int sourceId,
  }) {
    return imageLoaderUtility(image: imageUrl, sourceId: sourceId);
  }


  static Widget loadBase64Image(
      {required Uint8List bytes,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadAssetImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.asset(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadLocalAssetImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.asset(
      imagePath[imageUrl]!,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadSvgImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      Color? color,
      BoxFit? fit}) {
    return SvgPicture.asset(imageUrl,
        color: color, fit: fit ?? BoxFit.cover, height: height, width: width);
  }

  static Widget loadLocalSvgImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      Color? color,
      BoxFit? fit}) {
    return SvgPicture.asset(imagePath[imageUrl]!,
        fit: fit ?? BoxFit.cover, height: height, width: width, color: color);
  }
}

