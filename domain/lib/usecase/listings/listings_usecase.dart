import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:data/repo_impl/listings/listings_repo_impl.dart';

final listingsUseCaseProvider = Provider(
        (ref) => ListingsUseCase(listingsRepo: ref.read(listingsRepositoryProvider)));

class ListingsUseCase implements UseCase<BaseModel, GetAllListingsResponseModel> {
  ListingsRepoImpl listingsRepo;

  ListingsUseCase({required this.listingsRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await listingsRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
