import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_exercise_details_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitExerciseDetailsUseCaseProvider = Provider((ref) =>
    DigifitExerciseDetailsUseCase(
        digifitExerciseDetailsRepository:
            ref.read(digifitExerciseDetailsRepositoryProvider)));

class DigifitExerciseDetailsUseCase
    implements UseCase<BaseModel, DigifitExerciseDetailsRequestModel> {
  final DigifitExerciseDetailsRepoImpl digifitExerciseDetailsRepository;

  DigifitExerciseDetailsUseCase(
      {required this.digifitExerciseDetailsRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitExerciseDetailsRequestModel requestModel,
      BaseModel responseModel) async {
    final result = await digifitExerciseDetailsRepository.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
