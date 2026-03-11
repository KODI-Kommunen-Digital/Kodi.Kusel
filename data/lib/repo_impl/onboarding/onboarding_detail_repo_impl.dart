import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/onboarding/onboarding_details_service.dart';

final onboardingDetailsRepositoryProvider = Provider((ref) =>
    OnboardingDetailsRepoImpl(
        onboardingDetailsService: ref.read(onboardingDetailsServiceProvider)));

abstract class OnboardingDetailsRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OnboardingDetailsRepoImpl implements OnboardingDetailsRepository {
  OnboardingDetailsService onboardingDetailsService;

  OnboardingDetailsRepoImpl({required this.onboardingDetailsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await onboardingDetailsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
