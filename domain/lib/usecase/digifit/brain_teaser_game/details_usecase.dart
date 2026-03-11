import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/digifit/brain_teaser_game/details_repo_impl.dart';

import '../../../model/request_model/digifit/brain_teaser_game/details_request_model.dart';

final brainTeaserGameDetailsUseCaseProvider = Provider((ref) =>
    BrainTeaseGameDetailsUseCase(
        brainTeaserGameDetailsRepositoryProvider:
            ref.read(brainTeaserGameDetailsRepositoryProvider)));

class BrainTeaseGameDetailsUseCase
    implements UseCase<BaseModel, GameDetailsRequestModel> {
  final BrainTeaserGameDetailsRepo brainTeaserGameDetailsRepositoryProvider;

  BrainTeaseGameDetailsUseCase(
      {required this.brainTeaserGameDetailsRepositoryProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      GameDetailsRequestModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameDetailsRepositoryProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
