import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/favourite_city/get_favourite_cities_repo_impl.dart';
import 'package:domain/model/request_model/favourite_city/favourite_city_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFavouriteCitiesUseCaseProvider = Provider((ref) => GetFavouriteCitiesUseCase(
    getFavouriteCitiesRepository: ref.read(getFavouriteCitiesRepositoryProvider)));

class GetFavouriteCitiesUseCase
    implements UseCase<BaseModel, GetFavouriteCitiesRequestModel> {
  GetFavouriteCitiesRepository getFavouriteCitiesRepository;

  GetFavouriteCitiesUseCase({required this.getFavouriteCitiesRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GetFavouriteCitiesRequestModel requestModel, BaseModel responseModel) async {
    final result =
    await getFavouriteCitiesRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
