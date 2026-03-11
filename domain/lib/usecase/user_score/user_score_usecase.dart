import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/user_score/user_score_repository.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/user_score/user_score_request_model.dart';

final userScoreUseCaseProvider = Provider((ref) => UserScoreUseCase(
    userScoreRepository: ref.read(userScoreRepositoryProvider)));

class UserScoreUseCase implements UseCase<BaseModel, UserScoreRequestModel> {
  UserScoreRepository userScoreRepository;

  UserScoreUseCase({required this.userScoreRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      UserScoreRequestModel requestModel, BaseModel responseModel) async {
    final result = await userScoreRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
