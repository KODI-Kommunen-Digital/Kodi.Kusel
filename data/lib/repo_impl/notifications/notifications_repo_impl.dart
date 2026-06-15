import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/notifications/notifications_service.dart';

final notificationRepositoryProvider = Provider(
      (ref) => NotificationRepoImpl(
    notificationService: ref.read(notificationServiceProvider),
  ),
);

abstract class NotificationRepository {

  /// Store Firebase Token
  Future<Either<Exception, BaseModel>> storeFirebaseUserToken({
    required int userId,
    required String fcmToken,
    required String deviceId,
    required BaseModel responseModel,
  });

  /// Update Global Notification Preference
  Future<Either<Exception, BaseModel>> updateNotificationPreference({
    required int userId,
    required bool enabled,
    required BaseModel responseModel,
  });
}

class NotificationRepoImpl implements NotificationRepository {
  final NotificationService notificationService;

  NotificationRepoImpl({
    required this.notificationService,
  });

  @override
  Future<Either<Exception, BaseModel>> storeFirebaseUserToken({
    required int userId,
    required String fcmToken,
    required String deviceId,
    required BaseModel responseModel,
  }) async {

    final result =
    await notificationService.storeFirebaseUserToken(
      userId: userId,
      fcmToken: fcmToken,
      deviceId: deviceId,
      responseModel: responseModel,
    );

    return result.fold(
          (l) => Left(l),
          (r) => Right(r),
    );
  }

  @override
  Future<Either<Exception, BaseModel>> updateNotificationPreference({
    required int userId,
    required bool enabled,
    required BaseModel responseModel,
  }) async {

    final result =
    await notificationService.updateNotificationPreference(
      userId: userId,
      enabled: enabled,
      responseModel: responseModel,
    );

    return result.fold(
          (l) => Left(l),
          (r) => Right(r),
    );
  }
}