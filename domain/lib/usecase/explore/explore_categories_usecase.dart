import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/explore/explore_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response_model/categories_model/get_all_categories_response_model.dart';

final exploreCategoriesUseCaseProvider = Provider(
    (ref) => ExploreCategoriesUseCase(exploreRepo: ref.read(exploreRepositoryProvider)));

class ExploreCategoriesUseCase implements UseCase<BaseModel, GetAllCategoriesResponseModel> {
  ExploreRepo exploreRepo;

  ExploreCategoriesUseCase({required this.exploreRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await exploreRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
