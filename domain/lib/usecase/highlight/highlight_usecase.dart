import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:data/repo_impl/highlight/highlight_repo_impl.dart';

final highlightUseCaseProvider = Provider(
        (ref) => HighlightUseCase(highlightRepo: ref.read(highlightRepositoryProvider)));

class HighlightUseCase implements UseCase<BaseModel, GetAllListingsResponseModel> {
  HighlightRepo highlightRepo;

  HighlightUseCase({required this.highlightRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await highlightRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
