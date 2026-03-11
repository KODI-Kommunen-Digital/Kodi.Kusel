import 'dart:io';

import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/notifications/notifications_usecase.dart';
import 'package:kusel/firebase_api.dart';
import 'package:permission_handler/permission_handler.dart';

final notificationsProvider =
StateNotifierProvider<NotificationsNotifier, bool>(
      (ref) => NotificationsNotifier(
    notificationUseCase: ref.read(notificationUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
    firebaseApiProvider: ref.read(firebaseApiProvider)
  ),
);

class NotificationsNotifier extends StateNotifier<bool> {
  final NotificationUseCase notificationUseCase;
  final SharedPreferenceHelper sharedPreferenceHelper;
  final TokenStatus tokenStatus;
  final RefreshTokenUseCase refreshTokenUseCase;
  final FirebaseApi firebaseApiProvider;

  NotificationsNotifier({
    required this.notificationUseCase,
    required this.sharedPreferenceHelper,
    required this.tokenStatus,
    required this.refreshTokenUseCase,
    required this.firebaseApiProvider
  }) : super(true);


  Future<void> initializeNotificationStatus() async {
      final status = sharedPreferenceHelper.getBool(notificationPermission) ?? false;
      state = status;
  }

  Future<void> storeFirebaseToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    try {
      final userId = sharedPreferenceHelper.getInt(userIdKey);

      if (userId == null) return;

      final isExpired = tokenStatus.isAccessTokenExpired();

      if (isExpired) {
        await _refreshToken();
      }

      final result = await notificationUseCase.storeFirebaseUserToken(
        userId: userId,
        fcmToken: fcmToken,
        deviceId: deviceId,
        responseModel: EmptyRequest(),
      );

      result.fold(
            (l) => debugPrint("store token error: $l"),
            (r) => debugPrint("FCM token stored successfully"),
      );
    } catch (e) {
      debugPrint("storeFirebaseToken exception: $e");
    }
  }

  Future<void> updateNotificationPreference({
    required bool enabled,
    required void Function(String message) onError,
  }) async {
    try {
      final userId = sharedPreferenceHelper.getInt(userIdKey);

      if (userId == null) return;

      final isExpired = tokenStatus.isAccessTokenExpired();

      if (isExpired) {
        await _refreshToken();
      }

      final result = await notificationUseCase.updateNotificationPreference(
        userId: userId,
        enabled: enabled,
        responseModel: EmptyRequest(),
      );

      result.fold(
            (l) {
          debugPrint("update preference error: $l");
          onError(l.toString());
        },
            (r) async {
          state = enabled; // update provider state
          await sharedPreferenceHelper.setBool(notificationPermission, enabled);
            },
      );
    } catch (e) {
      debugPrint("updateNotificationPreference exception: $e");
      onError(e.toString());
    }
  }

  Future<void> _refreshToken() async {
    RefreshTokenRequestModel requestModel =
    RefreshTokenRequestModel();
    RefreshTokenResponseModel responseModel =
    RefreshTokenResponseModel();

    final response =
    await refreshTokenUseCase.call(requestModel, responseModel);

    response.fold(
          (l) => debugPrint("refresh token error: $l"),
          (r) {
        final res = r as RefreshTokenResponseModel;
        sharedPreferenceHelper.setString(
            tokenKey, res.data?.accessToken ?? "");
        sharedPreferenceHelper.setString(
            refreshTokenKey, res.data?.refreshToken ?? "");
      },
    );
  }

  Future<bool> requestOrHandleNotificationPermission(bool value) async {
    try {
      // User turning OFF notifications
      if (!value) {
        await updateNotificationPreference(
          enabled: false,
          onError: (message) {},
        );
        firebaseApiProvider.unsubscribeFromTopic("warnings");

        state = false;
        await sharedPreferenceHelper.setBool(notificationPermission, false);
        return true;
      }

      PermissionStatus status;

      if (Platform.isIOS) {
        status = await Permission.notification.request();
      } else {
        // Android 13+ notification permission
        status = await Permission.notification.request();
      }

      if (status.isGranted) {
        await updateNotificationPreference(
          enabled: true,
          onError: (message) {},
        );
        firebaseApiProvider.subscribeToTopic("warnings");
        state = true;
        await sharedPreferenceHelper.setBool(notificationPermission, true);
        return true;
      }

      // Permission denied or permanently denied
      firebaseApiProvider.unsubscribeFromTopic("warnings");
      state = false;
      await sharedPreferenceHelper.setBool(notificationPermission, false);
      return false;
    } catch (e) {
      debugPrint("requestOrHandleNotificationPermission error: $e");
      return false;
    }
  }}

