import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_exercise_details_tracking_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_tracking_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitExerciseDetailsTrackingUseCaseProvider = Provider(
  (ref) => DigifitExerciseDetailsTrackingUseCase(
    digifitExerciseDetailsTrackingRepository:
        ref.read(digifitExerciseDetailsTrackingRepositoryProvider),
  ),
);

class DigifitExerciseDetailsTrackingUseCase
    implements UseCase<BaseModel, DigifitExerciseDetailsTrackingRequestModel> {
  final DigifitExerciseDetailsTrackingRepoImpl
      digifitExerciseDetailsTrackingRepository;

  DigifitExerciseDetailsTrackingUseCase({
    required this.digifitExerciseDetailsTrackingRepository,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitExerciseDetailsTrackingRequestModel requestModel,
      BaseModel responseModel) async {
    final result = await digifitExerciseDetailsTrackingRepository.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
