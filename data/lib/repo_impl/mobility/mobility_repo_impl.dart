import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/mobility/mobility_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mobilityRepositoryProvider = Provider((ref) => MobilityRepoImpl(
    mobilityService: ref.read(mobilityServiceProvider)));

abstract class MobilityRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class MobilityRepoImpl implements MobilityRepository {
  MobilityService mobilityService;

  MobilityRepoImpl({required this.mobilityService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await mobilityService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
