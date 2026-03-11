import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/service/participate/participate_service.dart';
final participateRepositoryProvider = Provider((ref) => ParticipateRepoImpl(
    participateService: ref.read(participateServiceProvider)));

abstract class ParticipateRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class ParticipateRepoImpl implements ParticipateRepository {
  ParticipateService participateService;

  ParticipateRepoImpl({required this.participateService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await participateService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
