import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/local_digifit_services/local_digifit_bulk_tracking_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/request_model/digifit/local/local_digifit_bulk_tracking_request_model.dart';

final localDigifitBulkTrackingUseCaseProvider = Provider(
  (ref) => LocalDigifitBulkTrackingUseCase(
    localDigifitBulkTrackingUseaCase:
        ref.read(localDigifitBulkTrackingRepositoryProvider),
  ),
);

class LocalDigifitBulkTrackingUseCase
    implements UseCase<BaseModel, DigifitUpdateExerciseRequestModel> {
  final LocalDigifitBulkTrackingRepoImpl
      localDigifitBulkTrackingUseaCase;

  LocalDigifitBulkTrackingUseCase({
    required this.localDigifitBulkTrackingUseaCase,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitUpdateExerciseRequestModel requestModel, BaseModel responseModel) async {
    final result = await localDigifitBulkTrackingUseaCase.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
