import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/virtual_town_hall/virtual_town_hall_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final virtualTownHallRepositoryProvider = Provider((ref) =>
    VirtualTownHallRepoImpl(
        virtualTownHallService: ref.read(virtualTownHallServiceProvider)));

abstract class VirtualTownHallRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class VirtualTownHallRepoImpl implements VirtualTownHallRepository {
  VirtualTownHallService virtualTownHallService;

  VirtualTownHallRepoImpl({required this.virtualTownHallService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await virtualTownHallService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
