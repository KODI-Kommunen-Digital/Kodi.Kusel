import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/signup/signup_repo_impl.dart';
import 'package:domain/model/request_model/signup/singup_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpUseCaseProvider = Provider(
    (ref) => SignUpUseCase(signUpRepo: ref.read(signUpRepositoryProvider)));

class SignUpUseCase implements UseCase<BaseModel, SignUpRequestModel> {
  SignUpRepoImpl signUpRepo;

  SignUpUseCase({required this.signUpRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      SignUpRequestModel requestModel, BaseModel responseModel) async {
    final result = await signUpRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
