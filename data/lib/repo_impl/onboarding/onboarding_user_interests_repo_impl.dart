import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/onboarding/onboarding_user_interests_service.dart';

final onboardingUserInterestsRepositoryProvider = Provider((ref) => OnboardingUserInterestsRepoImpl(
    onboardingUserInterestsService: ref.read(onboardingUserInterestsServiceProvider)));

abstract class OnboardingUserInterestsRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OnboardingUserInterestsRepoImpl implements OnboardingUserInterestsRepository {
  OnboardingUserInterestsService onboardingUserInterestsService;

  OnboardingUserInterestsRepoImpl({required this.onboardingUserInterestsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingUserInterestsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
