import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/guest_user_login/guest_user_login_repo.dart';
import 'package:domain/model/request_model/guest_user_login/guest_user_login_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guestUserLoginUseCaseProvider = Provider((ref) => GuestUserLoginUseCase(
    guestUserLoginRepository: ref.read(guestUserLoginRepositoryProvider)));

class GuestUserLoginUseCase
    implements UseCase<BaseModel, GuestUserLoginRequestModel> {
  GuestUserLoginRepository guestUserLoginRepository;

  GuestUserLoginUseCase({required this.guestUserLoginRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GuestUserLoginRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await guestUserLoginRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
