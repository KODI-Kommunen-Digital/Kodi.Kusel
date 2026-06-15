import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/favourite_city/get_favourite_cities_service.dart';


final getFavouriteCitiesRepositoryProvider = Provider((ref) =>
    GetFavouriteCitiesRepoImpl(
        getFavouriteCitiesService: ref.read(getFavouriteCitiesServiceProvider)));

abstract class GetFavouriteCitiesRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GetFavouriteCitiesRepoImpl implements GetFavouriteCitiesRepository {
  GetFavouriteCitiesService getFavouriteCitiesService;

  GetFavouriteCitiesRepoImpl({required this.getFavouriteCitiesService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
    await getFavouriteCitiesService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
