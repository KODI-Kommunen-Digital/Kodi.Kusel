import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/onboarding/onboarding_user_Demographics_repo_impl.dart';

final onboardingUserDemographicsUseCaseProvider = Provider((ref) => OnboardingUserDemographicsUseCase(
    onboardingUserDemographicsRepoImpl: ref.read(onboardingUserDemographicsRepositoryProvider)));

class OnboardingUserDemographicsUseCase
    implements UseCase<BaseModel, OnboardingUserDemographicsRequestModel> {
  OnboardingUserDemographicsUseCase({required this.onboardingUserDemographicsRepoImpl});

  OnboardingUserDemographicsRepoImpl onboardingUserDemographicsRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      OnboardingUserDemographicsRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingUserDemographicsRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
