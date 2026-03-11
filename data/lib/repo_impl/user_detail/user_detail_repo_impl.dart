import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/user_detail/user_detail_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDetailRepositoryProvider = Provider((ref) =>
    UserDetailRepoImpl(userDetailService: ref.read(userDetailServiceProvider)));

abstract class UserDetailRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class UserDetailRepoImpl implements UserDetailRepository {
  UserDetailService userDetailService;

  UserDetailRepoImpl({required this.userDetailService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await userDetailService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
