import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/favorites/favorites_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesRepositoryProvider = Provider((ref) =>
    FavoritesRepoImpl(favoritesService: ref.read(favoritesServiceProvider)));

abstract class FavoritesRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
  Future<Either<Exception, BaseModel>> addFavorite(
      BaseModel requestModel, BaseModel responseModel);
  Future<Either<Exception, BaseModel>> deleteFavorite(
      BaseModel requestModel, BaseModel responseModel);
}

class FavoritesRepoImpl implements FavoritesRepo {
  FavoritesService favoritesService;

  FavoritesRepoImpl({required this.favoritesService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await favoritesService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Exception, BaseModel>> addFavorite(BaseModel<dynamic> requestModel, BaseModel<dynamic> responseModel) async {
    print("add fav repo");
    final result = await favoritesService.addFavorite(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Exception, BaseModel>> deleteFavorite(BaseModel<dynamic> requestModel, BaseModel<dynamic> responseModel) async {
    print("delete fav repo");
    final result = await favoritesService.deleteFavorite(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
