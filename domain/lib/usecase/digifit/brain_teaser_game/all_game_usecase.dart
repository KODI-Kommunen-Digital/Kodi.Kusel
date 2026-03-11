import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:data/repo_impl/digifit/brain_teaser_game/all_game_repo_impl.dart';

import '../../../model/request_model/digifit/brain_teaser_game/all_game_request_model.dart';

final brainTeaserGamesUseCaseProvider = Provider((ref) =>
    BrainTeaserGamesUseCase(
        brainTeaserGamesRepositoryProvider:
            ref.read(brainTeaserGamesRepositoryProvider)));

class BrainTeaserGamesUseCase
    implements UseCase<BaseModel, AllGamesRequestModel> {
  final BrainTeaserGamesRepository brainTeaserGamesRepositoryProvider;

  BrainTeaserGamesUseCase({required this.brainTeaserGamesRepositoryProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      AllGamesRequestModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGamesRepositoryProvider.call(
        requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
