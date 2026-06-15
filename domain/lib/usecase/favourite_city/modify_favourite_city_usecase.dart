import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/favourite_city/modify_favourite_city_repo_impl.dart';
import 'package:domain/model/request_model/favourite_city/add_favourite_city_request_model.dart';
import 'package:domain/model/request_model/favourite_city/delete_favourite_city_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addFavouriteCityUseCaseProvider = Provider((ref) => AddFavouriteCityUseCase(
    addFavouriteCityRepository: ref.read(modifyFavouriteCityRepositoryProvider)));

final deleteFavouriteCityUseCaseProvider = Provider((ref) => DeleteFavouriteCityUseCase(
    deleteFavouriteCityRepository: ref.read(modifyFavouriteCityRepositoryProvider)));

class AddFavouriteCityUseCase
    implements UseCase<BaseModel, AddFavouriteCityRequestModel> {
  ModifyFavouriteCityRepoImpl addFavouriteCityRepository;

  AddFavouriteCityUseCase({required this.addFavouriteCityRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      AddFavouriteCityRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await addFavouriteCityRepository.addFavourite(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}

class DeleteFavouriteCityUseCase
    implements UseCase<BaseModel, DeleteFavouriteCityRequestModel> {
  ModifyFavouriteCityRepoImpl deleteFavouriteCityRepository;

  DeleteFavouriteCityUseCase({required this.deleteFavouriteCityRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DeleteFavouriteCityRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await deleteFavouriteCityRepository.deleteFavourite(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
