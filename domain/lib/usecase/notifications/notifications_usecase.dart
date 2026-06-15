import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/notifications/notifications_repo_impl.dart';

final notificationUseCaseProvider = Provider(
      (ref) => NotificationUseCase(
    notificationRepository:
    ref.read(notificationRepositoryProvider),
  ),
);

class NotificationUseCase {

  final NotificationRepository notificationRepository;

  NotificationUseCase({
    required this.notificationRepository,
  });

  Future<Either<Exception, BaseModel>> storeFirebaseUserToken({
    required int userId,
    required String fcmToken,
    required String deviceId,
    required BaseModel responseModel,
  }) async {

    final result =
    await notificationRepository.storeFirebaseUserToken(
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

  Future<Either<Exception, BaseModel>> updateNotificationPreference({
    required int userId,
    required bool enabled,
    required BaseModel responseModel,
  }) async {

    final result =
    await notificationRepository.updateNotificationPreference(
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