import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/edit_user_detail/edit_user_detail_repo_impl.dart';

final editUserDetailUseCaseProvider = Provider((ref) => EditUserDetailUseCase(
    editUserDetailRepoImpl: ref.read(editUserDetailRepositoryProvider)));

class EditUserDetailUseCase
    implements UseCase<BaseModel, EditUserDetailRequestModel> {
  EditUserDetailUseCase({required this.editUserDetailRepoImpl});

  EditUserImageRepoImpl editUserDetailRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      EditUserDetailRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await editUserDetailRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
