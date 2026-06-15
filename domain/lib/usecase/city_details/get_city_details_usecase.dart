import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/city_details/get_city_details_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/city_details/get_city_details_request_model.dart';

final getCityDetailsUseCaseProvider = Provider((ref) => GetCityDetailsUseCase(
    getCityDetailsRepository: ref.read(getCityDetailsRepositoryProvider)));

class GetCityDetailsUseCase
    implements UseCase<BaseModel, GetCityDetailsRequestModel> {
  GetCityDetailsRepository getCityDetailsRepository;

  GetCityDetailsUseCase({required this.getCityDetailsRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GetCityDetailsRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await getCityDetailsRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
