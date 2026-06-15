import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/refresh_token/refresh_token_repo_impl.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response_model/sigin_model/sigin_response_model.dart';

final refreshTokenUseCaseProvider = Provider(
        (ref) => RefreshTokenUseCase(refreshTokenRepository: ref.read(refreshTokenRepositoryProvider)));

class RefreshTokenUseCase implements UseCase<BaseModel, RefreshTokenRequestModel> {
  RefreshTokenRepo refreshTokenRepository;

  RefreshTokenUseCase({required this.refreshTokenRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      RefreshTokenRequestModel requestModel, BaseModel responseModel) async {
    final result = await refreshTokenRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
