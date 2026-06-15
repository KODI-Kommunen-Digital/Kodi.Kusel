import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/participate/participate_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/Participate/Participate_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final participateUseCaseProvider = Provider((ref) => ParticipateUseCase(
    participateRepoImpl: ref.read(participateRepositoryProvider)));

class ParticipateUseCase
    implements UseCase<BaseModel, ParticipateRequestModel> {
  ParticipateRepoImpl participateRepoImpl;

  ParticipateUseCase({required this.participateRepoImpl});

  @override
  Future<Either<Exception, BaseModel>> call(
      ParticipateRequestModel requestModel, BaseModel responseModel) async {
    final result = await participateRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
