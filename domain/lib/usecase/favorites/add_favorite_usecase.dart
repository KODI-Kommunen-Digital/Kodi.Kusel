import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/response_model/favorites/get_favorites_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:data/repo_impl/favorites/favorites_repo_impl.dart';

final addFavoritesUseCaseProvider = Provider(
        (ref) => AddFavoriteUseCase(favoritesRepo: ref.read(favoritesRepositoryProvider)));

class AddFavoriteUseCase implements UseCase<BaseModel, GetFavoritesResponseModel> {
  FavoritesRepoImpl favoritesRepo;

  AddFavoriteUseCase({required this.favoritesRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await favoritesRepo.addFavorite(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
