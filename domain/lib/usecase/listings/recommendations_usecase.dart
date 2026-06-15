import 'package:core/base_model.dart';
import 'package:data/repo_impl/listings/recommendations_repo_impl.dart';
import 'package:domain/model/request_model/listings/recommendations_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod/riverpod.dart';

final recommendationUseCaseProvider = Provider((ref) => RecommendationsUseCase(
    recommendationsRepositoryProvider:
        ref.read(recommendationsRepositoryProvider)));

class RecommendationsUseCase
    implements UseCase<BaseModel, RecommendationsRequestModel> {
  RecommendationRepoImpl recommendationsRepositoryProvider;

  RecommendationsUseCase({required this.recommendationsRepositoryProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      RecommendationsRequestModel requestModel, BaseModel responseModel) async {
    final result = await recommendationsRepositoryProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
