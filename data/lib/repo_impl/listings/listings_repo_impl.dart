import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/listings/listings_service.dart';

final listingsRepositoryProvider = Provider((ref) =>
    ListingsRepoImpl(listingsService: ref.read(listingServiceProvider)));

abstract class ListingsRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ListingsRepoImpl implements ListingsRepo {
  ListingsService listingsService;

  ListingsRepoImpl({required this.listingsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await listingsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
