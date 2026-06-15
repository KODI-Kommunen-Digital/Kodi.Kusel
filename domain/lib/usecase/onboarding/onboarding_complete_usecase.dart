import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/onboarding/onboarding_complete_repo_impl.dart';

final onboardingCompleteUseCaseProvider = Provider((ref) => OnboardingCompleteUseCase(
    onboardingCompleteRepoImpl: ref.read(onboardingCompleteRepositoryProvider)));

class OnboardingCompleteUseCase
    implements UseCase<BaseModel, EmptyRequest> {
  OnboardingCompleteUseCase({required this.onboardingCompleteRepoImpl});

  OnboardingCompleteRepoImpl onboardingCompleteRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
    await onboardingCompleteRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
