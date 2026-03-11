import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/virtual_town_hall/virtual_town_hall_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/virtual_town_hall/virtual_town_hall_request_model.dart';

final virtualTownHallUseCaseProvider = Provider((ref) => VirtualTownHallUseCase(
    virtualTownHallRepository: ref.read(virtualTownHallRepositoryProvider)));

class VirtualTownHallUseCase implements UseCase<BaseModel, VirtualTownHallRequestModel> {
  VirtualTownHallRepository virtualTownHallRepository;

  VirtualTownHallUseCase({required this.virtualTownHallRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      VirtualTownHallRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await virtualTownHallRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
