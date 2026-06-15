import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/refresh_token/refresh_token_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshTokenRepositoryProvider = Provider(
        (ref) => RefreshTokenRepoImpl(refreshTokenService: ref.read(refreshTokenServiceProvider)));

abstract class RefreshTokenRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class RefreshTokenRepoImpl implements RefreshTokenRepo {
  RefreshTokenService refreshTokenService;

  RefreshTokenRepoImpl({required this.refreshTokenService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await refreshTokenService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
