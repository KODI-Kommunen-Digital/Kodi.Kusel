import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'extract_deviceId_state.dart';

final extractDeviceIdProvider =
   Provider((ref)=>ExtractDeviceIdProvider());

class ExtractDeviceIdProvider  {

  Future<String?> extractDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final androidId = androidInfo.id;
        return androidId;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final iosId = iosInfo.identifierForVendor;
        return iosId;
      }
    } catch (e) {
      debugPrint('Error in extracting the deviceID $e');
    }

    return null;
  }
}
