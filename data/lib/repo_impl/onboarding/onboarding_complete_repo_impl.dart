import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/onboarding/onboarding_complete_service.dart';

final onboardingCompleteRepositoryProvider = Provider((ref) => OnboardingCompleteRepoImpl(
    onboardingCompleteService: ref.read(onboardingCompleteServiceProvider)));

abstract class OnboardingCompleteRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OnboardingCompleteRepoImpl implements OnboardingCompleteRepository {
  OnboardingCompleteService onboardingCompleteService;

  OnboardingCompleteRepoImpl({required this.onboardingCompleteService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await onboardingCompleteService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
