import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/search/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchRepositoryProvider = Provider(
        (ref) => SearchRepoImpl(searchService: ref.read(searchServiceProvider)));

abstract class SearchRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class SearchRepoImpl implements SearchRepo {
  SearchService searchService;

  SearchRepoImpl({required this.searchService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await searchService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
