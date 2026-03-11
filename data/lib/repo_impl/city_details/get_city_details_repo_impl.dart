import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/city_details/get_cities_service.dart';

final getCityDetailsRepositoryProvider = Provider((ref) =>
    GetCityDetailsRepoImpl(
        getCityDetailsService: ref.read(getCityDetailsServiceProvider)));

abstract class GetCityDetailsRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GetCityDetailsRepoImpl implements GetCityDetailsRepository {
  GetCityDetailsService getCityDetailsService;

  GetCityDetailsRepoImpl({required this.getCityDetailsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await getCityDetailsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
