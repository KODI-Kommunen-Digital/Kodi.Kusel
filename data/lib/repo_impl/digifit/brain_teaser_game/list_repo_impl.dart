import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:data/service/digifit_services/brain_teaser_game/list_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final brainTeaserGameListRepositoryProvider = Provider((ref) =>
    BrainTeaserGameListRepo(
        brainTeaserGameListServiceProvider:
            ref.read(brainTeaserGameListServiceProvider)));

class BrainTeaserGameListRepo implements Repository {
  BrainTeaserGameListService brainTeaserGameListServiceProvider;

  BrainTeaserGameListRepo({required this.brainTeaserGameListServiceProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameListServiceProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
