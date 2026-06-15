import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/search/search_repo_impl.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final searchUseCaseProvider = Provider(
    (ref) => SearchUseCase(searchRepo: ref.read(searchRepositoryProvider)));

class SearchUseCase implements UseCase<BaseModel, SearchRequestModel> {
  SearchRepo searchRepo;

  SearchUseCase({required this.searchRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      SearchRequestModel requestModel, BaseModel responseModel) async {
    final result = await searchRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
