import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/reset_password/reset_password_repository.dart';
import 'package:domain/model/request_model/reset_password/reset_password_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response_model/sigin_model/sigin_response_model.dart';

final resetPasswordUseCaseProvider = Provider(
        (ref) => ResetPasswordUseCase(resetPasswordRepository: ref.read(resetPasswordRepositoryProvider)));

class ResetPasswordUseCase implements UseCase<BaseModel, ResetPasswordRequestModel> {
  ResetPasswordRepo resetPasswordRepository;

  ResetPasswordUseCase({required this.resetPasswordRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      ResetPasswordRequestModel requestModel, BaseModel responseModel) async {
    final result = await resetPasswordRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
