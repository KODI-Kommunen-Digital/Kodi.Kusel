import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/delete_account/delete_account_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/delete_account/delete_account_request_model.dart';

final deleteAccountUseCaseProvider = Provider((ref) => DeleteAccountUseCase(
    deleteAccountRepository: ref.read(deleteAccountRepositoryProvider)));

class DeleteAccountUseCase
    implements UseCase<BaseModel, DeleteAccountRequestModel> {
  DeleteAccountRepository deleteAccountRepository;

  DeleteAccountUseCase({required this.deleteAccountRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DeleteAccountRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await deleteAccountRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
