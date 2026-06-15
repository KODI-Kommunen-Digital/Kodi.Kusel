import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CustomCacheManager extends CacheManager {
  static const key = "customCache";
  static final CustomCacheManager _instance = CustomCacheManager._();

  // ✅ Track if clearing is in progress
  bool _isClearing = false;

  factory CustomCacheManager() => _instance;

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 150,
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
        );

  // SAFE cache clear - won't interfere with active operations
  Future<void> clearIfExceedsLimit({int limitMB = 20}) async {
    if (_isClearing) {
      return;
    }

    try {
      _isClearing = true;

      final path = await getCachePath();
      final dir = Directory(path);

      if (!await dir.exists()) {
        _isClearing = false;
        return;
      }

      int totalBytes = 0;
      await for (var file in dir.list(recursive: true)) {
        if (file is File) {
          totalBytes += await file.length();
        }
      }

      final sizeMB = totalBytes / (1024 * 1024);
      debugPrint('Cache size: ${sizeMB.toStringAsFixed(2)} MB');

      if (sizeMB > limitMB) {
        debugPrint('Cache exceeds $limitMB MB - will clear old files');

        // SAFEST: Only clear files older than 3 days
        await _clearOldFiles(days: 3);

        debugPrint(' Old cache files cleared');
      }
    } catch (e) {
      debugPrint('Error in cache check: $e');
    } finally {
      _isClearing = false;
    }
  }

  // Clear only OLD files, not recent ones
  Future<void> _clearOldFiles({int days = 3}) async {
    try {
      final path = await getCachePath();
      final dir = Directory(path);

      if (!await dir.exists()) return;

      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      int deletedCount = 0;

      await for (var file in dir.list(recursive: true)) {
        if (file is File) {
          try {
            final stat = await file.stat();
            if (stat.modified.isBefore(cutoffDate)) {
              await file.delete();
              deletedCount++;
            }
          } catch (e) {
            // Skip if file is in use
            continue;
          }
        }
      }

      debugPrint('Deleted $deletedCount old cache files');

      // Clear image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      debugPrint('Error clearing old files: $e');
    }
  }

  Future<String> getCachePath() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$key';
    return path;
  }

  //Manual clear - use this for settings page
  Future<void> clearCacheManually() async {
    if (_isClearing) return;

    try {
      _isClearing = true;

      // Clear cache manager's database first
      await emptyCache();

      // Wait for operations to complete
      await Future.delayed(Duration(milliseconds: 500));

      // Clear Flutter's image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      debugPrint('Cache manually cleared');
    } catch (e) {
      debugPrint('Manual clear error: $e');
    } finally {
      _isClearing = false;
    }
  }
}
