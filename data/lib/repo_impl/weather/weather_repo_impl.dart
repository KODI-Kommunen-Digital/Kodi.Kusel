import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/weather/weather_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherRepositoryProvider = Provider((ref) =>
    WeatherRepositoryImpl(weatherService: ref.read(weatherServiceProvider)));

abstract class WeatherRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherService weatherService;

  WeatherRepositoryImpl({required this.weatherService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await weatherService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
