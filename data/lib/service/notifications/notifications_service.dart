import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final notificationServiceProvider = Provider((ref) =>
    NotificationService(
      ref: ref,
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    ));

class NotificationService {
  final SharedPreferenceHelper sharedPreferenceHelper;
  final Ref ref;

  NotificationService({
    required this.sharedPreferenceHelper,
    required this.ref,
  });

  Future<Either<Exception, BaseModel>> storeFirebaseUserToken({
    required int userId,
    required String fcmToken,
    required String deviceId,
    required BaseModel responseModel,
  }) async {

    final path =
        "/users/$userId$storeFirebaseUserTokenEndPoint";

    final apiHelper = ref.read(apiHelperProvider);
    final token = sharedPreferenceHelper.getString(tokenKey) ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final body = {
      "token": fcmToken,
      "deviceId": deviceId,
    };

    final result = await apiHelper.postRequest(
      path: path,
      create: () => responseModel,
      body: body,
      headers: headers,
    );

    return result.fold(
          (l) => Left(l),
          (r) => Right(r),
    );
  }

  Future<Either<Exception, BaseModel>> updateNotificationPreference({
    required int userId,
    required bool enabled,
    required BaseModel responseModel,
  }) async {

    final path =
        "/users/$userId/notificationPreference";

    final apiHelper = ref.read(apiHelperProvider);
    final token = sharedPreferenceHelper.getString(tokenKey) ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final body = {
      "enabled": enabled,
    };

    final result = await apiHelper.postRequest(
      path: path,
      create: () => responseModel,
      body: body,
      headers: headers,
    );

    return result.fold(
          (l) => Left(l),
          (r) => Right(r),
    );
  }
}