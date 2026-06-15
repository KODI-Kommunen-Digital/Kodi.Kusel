import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';

import '../../../service/digifit_services/local_digifit_services/local_digifit_bulk_tracking_services.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDigifitBulkTrackingRepositoryProvider = Provider(
  (ref) => LocalDigifitBulkTrackingRepoImpl(
    localDigifitBulkTrackingService:
        ref.read(localDigifitBulkTrackingServiceProvider),
  ),
);

class LocalDigifitBulkTrackingRepoImpl implements Repository {
  final LocalDigifitBulkTrackingService localDigifitBulkTrackingService;

  LocalDigifitBulkTrackingRepoImpl({
    required this.localDigifitBulkTrackingService,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await localDigifitBulkTrackingService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
