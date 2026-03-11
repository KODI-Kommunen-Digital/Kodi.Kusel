import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/guest_user_login/guest_user_login_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guestUserLoginRepositoryProvider = Provider((ref) =>
    GuestUserLoginRepositoryImpl(
        guestUserLoginService: ref.read(guestUserLoginServiceProvider)));

abstract class GuestUserLoginRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GuestUserLoginRepositoryImpl implements GuestUserLoginRepository {
  GuestUserLoginService guestUserLoginService;

  GuestUserLoginRepositoryImpl({required this.guestUserLoginService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await guestUserLoginService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
