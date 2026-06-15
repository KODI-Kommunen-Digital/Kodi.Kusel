import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/onboarding/onboarding_user_type_repo_impl.dart';

final onboardingUserTypeUseCaseProvider = Provider((ref) => OnboardingUserTypeUseCase(
    onboardingUserTypeRepoImpl: ref.read(onboardingUserTypeRepositoryProvider)));

class OnboardingUserTypeUseCase
    implements UseCase<BaseModel, OnboardingUserTypeRequestModel> {
  OnboardingUserTypeUseCase({required this.onboardingUserTypeRepoImpl});

  OnboardingUserTypeRepoImpl onboardingUserTypeRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      OnboardingUserTypeRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingUserTypeRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
