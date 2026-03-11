import 'dart:async';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/providers/extract_deviceId/extract_deviceId_provider.dart';
import 'package:kusel/providers/notifications_provider.dart';

import 'main_dev.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("Background message: ${message.messageId}");
}

final firebaseApiProvider = Provider<FirebaseApi>((ref) {
  return FirebaseApi(navigatorKey, ref);
});

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> globalNavKey;
  final Ref ref;

  FirebaseApi(this.globalNavKey, this.ref);

  /// ==============================
  /// INITIALIZATION
  /// ==============================

  Future<void> initNotifications() async {
    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Notification permission: ${settings.authorizationStatus}");

    if(settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      SharedPreferenceHelper sharedPreferenceHelper = ref.read(sharedPreferenceHelperProvider);
      await sharedPreferenceHelper.setBool(notificationPermission,
          sharedPreferenceHelper.getBool(notificationPermission) ?? true);
      await uploadFcmAfterLogin();
    }

    // Always try to get token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _saveTokenLocally(token);
    }

    // Listen for refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveTokenLocally(newToken);
    });
  }

  Future<void> _saveTokenLocally(String token) async {
    SharedPreferenceHelper sharedPreferenceHelper = ref.read(sharedPreferenceHelperProvider);
    await sharedPreferenceHelper.setString(fcmToken, token);
  }

  Future<void> uploadFcmAfterLogin() async {
    SharedPreferenceHelper sharedPreferenceHelper = await ref.read(sharedPreferenceHelperProvider);
    String? token = sharedPreferenceHelper.getString(fcmToken);
    if (token == null) {
      // Always try to get token
      token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveTokenLocally(token);
      } else {
        return;
      }
    }
    await _uploadTokenToBackend(token);
  }

  /// ==============================
  /// FOREGROUND HANDLER
  /// ==============================
  Future<void> _handleForegroundNotification(RemoteMessage message) async {
    debugPrint("Foreground notification: ${message.notification?.title}");
  }

  /// ==============================
  /// CLICK HANDLER
  /// ==============================
  Future<void> _handleNotificationClick(RemoteMessage message) async {
    final type = message.data['type'];

    if (type == "order") {
      final orderId = message.data['orderId'];
      globalNavKey.currentState?.pushNamed(
        "/orderDetail",
        arguments: orderId,
      );
    }

    if (type == "offer") {
      globalNavKey.currentState?.pushNamed("/offers");
    }
  }

  /// ==============================
  /// TOKEN UPLOAD
  /// ==============================
  Future<void> _uploadTokenToBackend(String token) async {
    try {
      final deviceId =
      await ref.read(extractDeviceIdProvider).extractDeviceId();

      await ref.read(notificationsProvider.notifier).storeFirebaseToken(
        fcmToken: token,
        deviceId: deviceId ?? "",
      );

      final settings = await FirebaseMessaging.instance.getNotificationSettings();

      final isPermissionGranted =
          (settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional);

      SharedPreferenceHelper sharedPreferenceHelper = ref.read(sharedPreferenceHelperProvider);

      final isLocalNotificationPermissionAvailable = sharedPreferenceHelper.getBool(notificationPermission) ?? false;

      if (isPermissionGranted && isLocalNotificationPermissionAvailable) {
        await subscribeToTopic("warnings");
      }

      await updateNotificationPreference(isPermissionGranted && isLocalNotificationPermissionAvailable);

      debugPrint("FCM token uploaded successfully");
    } catch (e) {
      debugPrint("FCM token upload failed: $e");
    }
  }

  /// ==============================
  /// TOPICS
  /// ==============================
  Future<void> subscribeToTopic(String topic) async {
    debugPrint("Subscribing to topic: $topic");
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint("Unsubscribing from topic: $topic");
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> updateNotificationPreference(bool enabled) async {
    await ref.read(notificationsProvider.notifier).updateNotificationPreference(
      enabled: enabled,
      onError: (String message) {},
    );
  }
}