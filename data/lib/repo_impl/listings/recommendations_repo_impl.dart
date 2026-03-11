import 'package:core/base_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../service/listings/recommendations_service.dart';

final recommendationsRepositoryProvider = Provider((ref) =>
    RecommendationRepoImpl(
        recommendationsService: ref.read(recommendationsServiceProvider)));

abstract class RecommendationRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class RecommendationRepoImpl implements RecommendationRepository {
  RecommendationService recommendationsService;

  RecommendationRepoImpl({required this.recommendationsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await recommendationsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}