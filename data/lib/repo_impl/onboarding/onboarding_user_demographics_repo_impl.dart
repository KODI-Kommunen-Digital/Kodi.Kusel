import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/onboarding/onboarding_user_Demographics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingUserDemographicsRepositoryProvider = Provider((ref) => OnboardingUserDemographicsRepoImpl(
    onboardingUserDemographicsService: ref.read(onboardingUserDemographicsServiceProvider)));

abstract class OnboardingUserDemographicsRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OnboardingUserDemographicsRepoImpl implements OnboardingUserDemographicsRepository {
  OnboardingUserDemographicsService onboardingUserDemographicsService;

  OnboardingUserDemographicsRepoImpl({required this.onboardingUserDemographicsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingUserDemographicsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
