import 'package:core/base_model.dart';
import 'package:data/service/edit_user_detail/edit_user_detail_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final editUserDetailRepositoryProvider = Provider((ref) =>
    EditUserImageRepoImpl(
        editUserDetailService: ref.read(editUserDetailServiceProvider)));

abstract class EditUserDetailRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class EditUserImageRepoImpl implements EditUserDetailRepo {
  EditUserDetailService editUserDetailService;

  EditUserImageRepoImpl({required this.editUserDetailService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await editUserDetailService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => right(r));
  }
}
