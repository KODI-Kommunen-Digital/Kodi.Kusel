import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/brain_teaser_game/list_repo_impl.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/list_request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../usecase.dart';

final brainTeaserGameListUseCaseProvider = Provider((ref) =>
    BrainTeaserGameListUseCase(
        brainTeaserGameListRepositoryProvider:
            ref.read(brainTeaserGameListRepositoryProvider)));

class BrainTeaserGameListUseCase
    implements UseCase<BaseModel, BrainTeaserGameListRequestModel> {
  final BrainTeaserGameListRepo brainTeaserGameListRepositoryProvider;

  BrainTeaserGameListUseCase(
      {required this.brainTeaserGameListRepositoryProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BrainTeaserGameListRequestModel requestModel,
      BaseModel responseModel) async {
    final result = await brainTeaserGameListRepositoryProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
