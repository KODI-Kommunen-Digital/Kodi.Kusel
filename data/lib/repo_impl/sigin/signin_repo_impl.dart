import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/sigin/sigin_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sigInRepositoryProvider = Provider(
    (ref) => SignInRepoImpl(sigInService: ref.read(signInServiceProvider)));

abstract class SignInRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class SignInRepoImpl implements SignInRepo {
  SigInService sigInService;

  SignInRepoImpl({required this.sigInService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await sigInService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
