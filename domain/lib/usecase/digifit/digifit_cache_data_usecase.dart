import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/digifit/digifit_cache_data_repo_impl.dart';

import '../../model/request_model/digifit/digifit_information_request_model.dart';

final digifitCacheDataUseCaseProvider = Provider((ref) =>
    DigifitCacheDataUseCase(
        DigifitCacheDataRepository:
            ref.read(digifitCacheDataRepositoryProvider)));

class DigifitCacheDataUseCase
    implements UseCase<BaseModel, DigifitInformationRequestModel> {
  final DigifitCacheDataRepo DigifitCacheDataRepository;

  DigifitCacheDataUseCase({required this.DigifitCacheDataRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitInformationRequestModel requestModel,
      BaseModel responseModel) async {
    final result =
        await DigifitCacheDataRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
