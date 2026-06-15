import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/forgot_password/forgot_password_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forgotPasswordRepositoryProvider = Provider((ref) =>
    ForgotPasswordRepoImpl(
        forgotPasswordService: ref.read(forgotPasswordServiceProvider)));

abstract class ForgotPasswordRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ForgotPasswordRepoImpl implements ForgotPasswordRepo {
  ForgotPasswordService forgotPasswordService;

  ForgotPasswordRepoImpl({required this.forgotPasswordService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await forgotPasswordService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
