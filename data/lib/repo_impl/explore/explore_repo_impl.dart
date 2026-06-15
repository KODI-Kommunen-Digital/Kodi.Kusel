import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/explore/explore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exploreRepositoryProvider = Provider(
    (ref) => ExploreRepoImpl(exploreService: ref.read(exploreServiceProvider)));

abstract class ExploreRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ExploreRepoImpl implements ExploreRepo {
  ExploreService exploreService;

  ExploreRepoImpl({required this.exploreService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await exploreService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
