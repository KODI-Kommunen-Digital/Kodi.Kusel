import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/sigin/signin_repo_impl.dart';
import 'package:domain/model/request_model/sigin/signin_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response_model/sigin_model/sigin_response_model.dart';
final signInUseCaseProvider = Provider(
    (ref) => SignInUseCase(signInRepo: ref.read(sigInRepositoryProvider)));

class SignInUseCase implements UseCase<BaseModel, SignInRequestModel> {
  SignInRepo signInRepo;

  SignInUseCase({required this.signInRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      SignInRequestModel requestModel, BaseModel responseModel) async {
    final result = await signInRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
