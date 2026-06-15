import 'package:core/base_model.dart';
import 'package:data/service/edit_user_detail/edit_user_image_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

final editUserImageRepositoryProvider = Provider((ref) => EditUserImageRepoImpl(
    editUserImageService: ref.read(editUserImageServiceProvider)));

abstract class EditUserImageRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class EditUserImageRepoImpl implements EditUserImageRepo {
  EditUserImageService editUserImageService;

  EditUserImageRepoImpl({required this.editUserImageService});

  @override
  Future<Either<Exception, BaseModel>> call(BaseModel requestModel,
      BaseModel responseModel) async {
    final result =
        await editUserImageService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => right(r));
  }
}
