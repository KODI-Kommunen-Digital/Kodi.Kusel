import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../service/digifit_services/brain_teaser_game/game_details_tracker_services.dart';

final brainTeaserGameDetailsTrackingRepositoryProvider =
    Provider((ref) => BrainTeaserGameDetailsTrackingRepoImpl(
          brainTeaserGameDetailsTrackingService:
              ref.read(brainTeaserGameDetailsTrackingService),
        ));

class BrainTeaserGameDetailsTrackingRepoImpl implements Repository {
  final BrainTeaserGameDetailsTrackingService
      brainTeaserGameDetailsTrackingService;

  BrainTeaserGameDetailsTrackingRepoImpl({
    required this.brainTeaserGameDetailsTrackingService,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameDetailsTrackingService.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
