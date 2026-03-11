import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/repository.dart';

import '../../service/digifit_services/digifit_exercise_details_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitExerciseDetailsRepositoryProvider = Provider((ref) =>
    DigifitExerciseDetailsRepoImpl(
        digifitExerciseDetailsService:
            ref.read(digifitExerciseDetailsServicesProvider)));

class DigifitExerciseDetailsRepoImpl implements Repository {
  final DigifitExerciseDetailsServices digifitExerciseDetailsService;

  DigifitExerciseDetailsRepoImpl({required this.digifitExerciseDetailsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitExerciseDetailsService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
