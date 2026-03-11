import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/digifit_services/digit_equipment_fav_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitEquipmentFavRepositoryProvider = Provider((ref) =>
    DigifitEquipmentFavRepoImpl(
        digifitEquipmentFavService:
            ref.read(digifitEquipmentFavServiceProvider)));

abstract class DigifitEquipmentFavRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class DigifitEquipmentFavRepoImpl implements DigifitEquipmentFavRepository {
  final DigifitEquipmentFavService digifitEquipmentFavService;

  DigifitEquipmentFavRepoImpl({required this.digifitEquipmentFavService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitEquipmentFavService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
