import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/municipality/municipality_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final municipalityRepositoryProvider = Provider((ref) => MunicipalityRepoImpl(
    municipalityService: ref.read(municipalityServiceProvider)));

abstract class MunicipalityRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class MunicipalityRepoImpl implements MunicipalityRepository {
  MunicipalityService municipalityService;

  MunicipalityRepoImpl({required this.municipalityService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await municipalityService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
