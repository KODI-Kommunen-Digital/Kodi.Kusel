import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/favourite_city/modify_favourite_city_service.dart';

final modifyFavouriteCityRepositoryProvider = Provider((ref) =>
    ModifyFavouriteCityRepoImpl(
        modifyFavouriteCityService:
            ref.read(modifyFavouriteCityServiceProvider)));

abstract class ModifyFavouriteCityRepository {
  Future<Either<Exception, BaseModel>> addFavourite(
      BaseModel requestModel, BaseModel responseModel);

  Future<Either<Exception, BaseModel>> deleteFavourite(
      BaseModel requestModel, BaseModel responseModel);
}

class ModifyFavouriteCityRepoImpl implements ModifyFavouriteCityRepository {
  ModifyFavouriteCityService modifyFavouriteCityService;

  ModifyFavouriteCityRepoImpl({required this.modifyFavouriteCityService});

  @override
  Future<Either<Exception, BaseModel>> addFavourite(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await modifyFavouriteCityService.addFavourite(
        requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Exception, BaseModel>> deleteFavourite(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await modifyFavouriteCityService.deleteFavourite(
        requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
