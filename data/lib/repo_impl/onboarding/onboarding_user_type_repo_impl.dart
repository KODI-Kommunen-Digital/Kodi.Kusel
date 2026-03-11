import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/onboarding/onboarding_user_type_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingUserTypeRepositoryProvider = Provider((ref) => OnboardingUserTypeRepoImpl(
    onboardingUserTypeService: ref.read(onboardingUserTypeServiceProvider)));

abstract class OnboardingUserTypeRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OnboardingUserTypeRepoImpl implements OnboardingUserTypeRepository {
  OnboardingUserTypeService onboardingUserTypeService;

  OnboardingUserTypeRepoImpl({required this.onboardingUserTypeService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await onboardingUserTypeService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
