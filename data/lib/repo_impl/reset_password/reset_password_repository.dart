import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/reset_password/reset_password_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPasswordRepositoryProvider = Provider(
        (ref) => ResetPasswordRepoImpl(resetPasswordService: ref.read(resetPasswordServiceProvider)));

abstract class ResetPasswordRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ResetPasswordRepoImpl implements ResetPasswordRepo {
  ResetPasswordService resetPasswordService;

  ResetPasswordRepoImpl({required this.resetPasswordService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await resetPasswordService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
