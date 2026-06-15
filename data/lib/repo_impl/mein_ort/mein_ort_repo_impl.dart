import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/mein_ort/mein_ort_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meinOrtRepositoryProvider = Provider((ref) =>
    MeinOrtRepoImpl(
        meinOrtService: ref.read(meinOrtServiceProvider)));

abstract class MeinOrtRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class MeinOrtRepoImpl implements MeinOrtRepository {
  MeinOrtService meinOrtService;

  MeinOrtRepoImpl({required this.meinOrtService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await meinOrtService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
