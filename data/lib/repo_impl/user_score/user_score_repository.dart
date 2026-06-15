import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/user_score/user_score_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userScoreRepositoryProvider = Provider((ref) =>
    UserScoreRepoImpl(userScoreService: ref.read(userScoreServiceProvider)));

abstract class UserScoreRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class UserScoreRepoImpl implements UserScoreRepository {
  UserScoreService userScoreService;

  UserScoreRepoImpl({required this.userScoreService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await userScoreService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
