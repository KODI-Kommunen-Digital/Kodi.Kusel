import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet }

class DeviceHelper {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 599) {
      return DeviceType.mobile;
    } else {
      return DeviceType.tablet;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }
}
