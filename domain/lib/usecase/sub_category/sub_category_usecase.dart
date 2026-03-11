import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/sub_category/sub_category_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/sub_category/sub_category_request_model.dart';

final subCategoryUseCaseProvider = Provider((ref) => SubCategoryUseCase(
    subCategoryRepo: ref.read(subCategoryRepositoryProvider)));

class SubCategoryUseCase
    implements UseCase<BaseModel, SubCategoryRequestModel> {
  SubCategoryRepo subCategoryRepo;

  SubCategoryUseCase({required this.subCategoryRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      SubCategoryRequestModel requestModel, BaseModel responseModel) async {
    final result = await subCategoryRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
