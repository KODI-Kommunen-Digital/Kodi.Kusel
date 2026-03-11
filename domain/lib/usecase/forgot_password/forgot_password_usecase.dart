import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/forgot_password/forgot_password_repo_impl.dart';
import 'package:domain/model/request_model/forgot_password/forgot_password_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forgotPasswordUseCaseProvider = Provider((ref) => ForgotPasswordUseCase(
    forgotPasswordRepository: ref.read(forgotPasswordRepositoryProvider)));

class ForgotPasswordUseCase
    implements UseCase<BaseModel, ForgotPasswordRequestModel> {
  ForgotPasswordRepo forgotPasswordRepository;

  ForgotPasswordUseCase({required this.forgotPasswordRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      ForgotPasswordRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await forgotPasswordRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
