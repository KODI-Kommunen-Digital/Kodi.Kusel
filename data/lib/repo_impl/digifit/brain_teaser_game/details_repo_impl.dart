import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../service/digifit_services/brain_teaser_game/details_service.dart';

final brainTeaserGameDetailsRepositoryProvider = Provider((ref) =>
    BrainTeaserGameDetailsRepo(
        brainTeaserGameDetailsServiceProvider:
            ref.read(brainTeaserGameDetailsServiceProvider)));

class BrainTeaserGameDetailsRepo implements Repository {
  BrainTeaserGameDetailsService brainTeaserGameDetailsServiceProvider;

  BrainTeaserGameDetailsRepo(
      {required this.brainTeaserGameDetailsServiceProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameDetailsServiceProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
