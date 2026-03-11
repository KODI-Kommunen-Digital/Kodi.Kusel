import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/delete_account/delete_accout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAccountRepositoryProvider = Provider((ref) => DeleteAccountRepoImpl(
    deleteAccountService: ref.read(deleteAccountServiceProvider)));

abstract class DeleteAccountRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class DeleteAccountRepoImpl implements DeleteAccountRepository {
  DeleteAccountService deleteAccountService;

  DeleteAccountRepoImpl({required this.deleteAccountService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await deleteAccountService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
