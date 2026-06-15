import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/service/poi_coordinates/get_poi_coordinates_service.dart';

final poiCoordinatesRepositoryProvider = Provider((ref) => ParticipateRepoImpl(
    poiCoordinatesService: ref.read(poiCoordinatesServiceProvider)));

abstract class PoiCoordinatesRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ParticipateRepoImpl implements PoiCoordinatesRepository {
  PoiCoordinatesService poiCoordinatesService;

  ParticipateRepoImpl({required this.poiCoordinatesService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await poiCoordinatesService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
