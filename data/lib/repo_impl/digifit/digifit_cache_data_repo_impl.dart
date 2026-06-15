import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/digifit_services/digifit_cache_data_service.dart';

final digifitCacheDataRepositoryProvider = Provider((ref) =>
    DigifitCacheDataRepoImpl(
        digifitCacheDataService: ref.read(digifitCacheDataServiceProvider)));

abstract class DigifitCacheDataRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class DigifitCacheDataRepoImpl implements DigifitCacheDataRepo {
  DigifitCacheDataService digifitCacheDataService;

  DigifitCacheDataRepoImpl({required this.digifitCacheDataService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitCacheDataService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
