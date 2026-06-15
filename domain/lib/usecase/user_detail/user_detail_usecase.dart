import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/user_detail/user_detail_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/user_detail/user_detail_request_model.dart';

final userDetailUseCaseProvider = Provider((ref) => UserDetailUseCase(
    userDetailRepository: ref.read(userDetailRepositoryProvider)));

class UserDetailUseCase implements UseCase<BaseModel, UserDetailRequestModel> {
  UserDetailRepository userDetailRepository;

  UserDetailUseCase({required this.userDetailRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      UserDetailRequestModel requestModel, BaseModel responseModel) async {
    final result = await userDetailRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
