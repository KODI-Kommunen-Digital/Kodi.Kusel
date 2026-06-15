import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/filter/get_filter_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFilterRepositoryProvider = Provider(
        (ref) => GetFilterRepoImpl(getFilterService: ref.read(getFilterServiceProvider)));

abstract class GetFilterRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GetFilterRepoImpl implements GetFilterRepo {
  GetFilterService getFilterService;

  GetFilterRepoImpl({required this.getFilterService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await getFilterService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
