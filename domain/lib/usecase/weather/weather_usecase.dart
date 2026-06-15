import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/weather/weather_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/weather/weather_request_model.dart';

final weatherUseCaseProvider = Provider((ref) =>
    WeatherUseCase(weatherRepository: ref.read(weatherRepositoryProvider)));

class WeatherUseCase implements UseCase<BaseModel, WeatherRequestModel> {
  WeatherRepository weatherRepository;

  WeatherUseCase({required this.weatherRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      WeatherRequestModel requestModel, BaseModel responseModel) async {
    final result = await weatherRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
