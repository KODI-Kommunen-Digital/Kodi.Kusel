import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/edit_user_detail/edit_user_image_repo_impl.dart';

import '../../model/request_model/edit_user_detail/edit_user_image_request_model.dart';

final editUserImageUseCaseProvider = Provider((ref) => EditUserImageUseCase(
    editUserImageRepoImpl: ref.read(editUserImageRepositoryProvider)));

class EditUserImageUseCase
    implements UseCase<BaseModel, EditUserImageRequestModel> {
  EditUserImageUseCase({required this.editUserImageRepoImpl});

  EditUserImageRepoImpl editUserImageRepoImpl;

  @override
  Future<Either<Exception, BaseModel>> call(
      EditUserImageRequestModel requestModel,
      BaseModel responseModel) async {

    final result =
        await editUserImageRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
