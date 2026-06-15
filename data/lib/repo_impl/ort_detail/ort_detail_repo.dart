import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/ort_detail/ort_detail_service.dart';

final ortDetailRepositoryProvider = Provider((ref) =>
    OrtDetailRepoImpl(
        ortDetailService:
        ref.read(ortDetailServiceProvider)));

abstract class OrtDetailRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class OrtDetailRepoImpl implements OrtDetailRepo {
  OrtDetailService ortDetailService;

  OrtDetailRepoImpl({required this.ortDetailService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await ortDetailService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
