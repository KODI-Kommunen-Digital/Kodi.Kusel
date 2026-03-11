import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/municipality/municipility_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/municipality/municipality_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final municipalityUseCaseProvider = Provider((ref) => MunicipalityUseCase(
    municipalityRepoImpl: ref.read(municipalityRepositoryProvider)));

class MunicipalityUseCase
    implements UseCase<BaseModel, MunicipalityRequestModel> {
  MunicipalityRepoImpl municipalityRepoImpl;

  MunicipalityUseCase({required this.municipalityRepoImpl});

  @override
  Future<Either<Exception, BaseModel>> call(
      MunicipalityRequestModel requestModel, BaseModel responseModel) async {
    final result = await municipalityRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
