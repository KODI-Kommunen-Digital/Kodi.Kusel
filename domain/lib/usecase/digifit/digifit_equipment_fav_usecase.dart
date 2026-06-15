import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_equipment_fav_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_equipment_fav_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitEquipmentFavUseCaseProvider = Provider((ref) =>
    DigifitEquipmentFavUseCase(
        digifitEquipmentFavRepository:
            ref.read(digifitEquipmentFavRepositoryProvider)));

class DigifitEquipmentFavUseCase
    implements UseCase<BaseModel, DigifitEquimentFavRequestModel> {
  final DigifitEquipmentFavRepository digifitEquipmentFavRepository;

  DigifitEquipmentFavUseCase({required this.digifitEquipmentFavRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitEquimentFavRequestModel requestModel,
      BaseModel responseModel) async {
    final result =
        await digifitEquipmentFavRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
