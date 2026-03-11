import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/onboarding/onboarding_user_Interests_repo_impl.dart';

final onboardingUserInterestsUseCaseProvider = Provider((ref) => OnboardingUserInterestsUseCase(
    onboardingUserInterestsRepoImpl: ref.read(onboardingUserInterestsRepositoryProvider)));

class OnboardingUserInterestsUseCase
    implements UseCase<BaseModel, OnboardingUserInterestsRequestModel> {
  OnboardingUserInterestsUseCase({required this.onboardingUserInterestsRepoImpl});

  OnboardingUserInterestsRepoImpl onboardingUserInterestsRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      OnboardingUserInterestsRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingUserInterestsRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
