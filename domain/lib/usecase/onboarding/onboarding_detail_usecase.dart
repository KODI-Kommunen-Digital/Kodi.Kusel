import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/onboarding/onboarding_detail_repo_impl.dart';

final onboardingDetailsUseCaseProvider = Provider((ref) => OnboardingDetailsUseCase(
    onboardingDetailsRepository: ref.read(onboardingDetailsRepositoryProvider)));

class OnboardingDetailsUseCase
    implements UseCase<BaseModel, EmptyRequest> {
  OnboardingDetailsRepository onboardingDetailsRepository;

  OnboardingDetailsUseCase({required this.onboardingDetailsRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
    await onboardingDetailsRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
