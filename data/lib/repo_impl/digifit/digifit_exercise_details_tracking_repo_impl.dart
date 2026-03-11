import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';

import '../../service/digifit_services/digifit_exercise_details_tracking_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitExerciseDetailsTrackingRepositoryProvider = Provider(
  (ref) => DigifitExerciseDetailsTrackingRepoImpl(
    digifitExerciseDetailsTrackingService:
        ref.read(digifitExerciseDetailsTrackingService),
  ),
);

class DigifitExerciseDetailsTrackingRepoImpl implements Repository {
  final DigifitExerciseDetailsTrackingService
      digifitExerciseDetailsTrackingService;

  DigifitExerciseDetailsTrackingRepoImpl({
    required this.digifitExerciseDetailsTrackingService,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await digifitExerciseDetailsTrackingService.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
