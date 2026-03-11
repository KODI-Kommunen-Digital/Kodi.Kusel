import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../service/digifit_services/brain_teaser_game/all_game_service.dart';

final brainTeaserGamesRepositoryProvider = Provider((ref) =>
    BrainTeaserGamesRepository(
        brainTeaserGamesServiceProvider:
            ref.read(brainTeaserGamesServiceProvider)));

class BrainTeaserGamesRepository implements Repository {
  BrainTeaserGamesService brainTeaserGamesServiceProvider;

  BrainTeaserGamesRepository({required this.brainTeaserGamesServiceProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await brainTeaserGamesServiceProvider.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
