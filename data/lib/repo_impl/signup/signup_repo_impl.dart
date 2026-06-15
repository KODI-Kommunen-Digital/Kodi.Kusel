import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/signup/signup_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpRepositoryProvider = Provider(
    (ref) => SignUpRepoImpl(signUpService: ref.read(signUpServiceProvider)));

abstract class SignUpRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class SignUpRepoImpl implements SignUpRepo {
  SignUpService signUpService;

  SignUpRepoImpl({required this.signUpService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await signUpService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
