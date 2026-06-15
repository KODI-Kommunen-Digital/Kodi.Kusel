import 'package:core/base_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod/riverpod.dart';
import 'package:data/repo_impl/digifit/brain_teaser_game/game_details_tracker_repo_impl.dart';

import '../../../model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';

final brainTeaserGameDetailsTrackingUseCaseProvider =
    Provider((ref) => BrainTeaserGameDetailsTrackingUseCase(
          brainTeaserGameDetailsTrackingRepository:
              ref.read(brainTeaserGameDetailsTrackingRepositoryProvider),
        ));

class BrainTeaserGameDetailsTrackingUseCase
    implements UseCase<BaseModel, GamesTrackerRequestModel> {
  BrainTeaserGameDetailsTrackingRepoImpl
      brainTeaserGameDetailsTrackingRepository;

  BrainTeaserGameDetailsTrackingUseCase(
      {required this.brainTeaserGameDetailsTrackingRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GamesTrackerRequestModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameDetailsTrackingRepository.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
