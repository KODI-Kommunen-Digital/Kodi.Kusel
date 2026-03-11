import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/mobility/mobility_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/Mobility/Mobility_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mobilityUseCaseProvider = Provider((ref) => MobilityUseCase(
    mobilityRepoImpl: ref.read(mobilityRepositoryProvider)));

class MobilityUseCase
    implements UseCase<BaseModel, MobilityRequestModel> {
  MobilityRepoImpl mobilityRepoImpl;

  MobilityUseCase({required this.mobilityRepoImpl});

  @override
  Future<Either<Exception, BaseModel>> call(
      MobilityRequestModel requestModel, BaseModel responseModel) async {
    final result = await mobilityRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
