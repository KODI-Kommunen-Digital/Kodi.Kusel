import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/poi_coordinate/poi_coordinates_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/poi_coordinates/poi_coordinates_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final poiCoordinatesUseCaseProvider = Provider((ref) => PoiCoordinatesUseCase(
    poiCoordinatesRepository: ref.read(poiCoordinatesRepositoryProvider)));

class PoiCoordinatesUseCase
    implements UseCase<BaseModel, PoiCoordinatesRequestModel> {
  PoiCoordinatesRepository poiCoordinatesRepository;

  PoiCoordinatesUseCase({required this.poiCoordinatesRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      PoiCoordinatesRequestModel requestModel, BaseModel responseModel) async {
    final result = await poiCoordinatesRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
