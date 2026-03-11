import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/sub_category/sub_category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subCategoryRepositoryProvider = Provider((ref) => SubCategoryRepoImpl(
    subCategoryService: ref.read(subCategoryServiceProvider)));

abstract class SubCategoryRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class SubCategoryRepoImpl implements SubCategoryRepo {
  SubCategoryService subCategoryService;

  SubCategoryRepoImpl({required this.subCategoryService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await subCategoryService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
