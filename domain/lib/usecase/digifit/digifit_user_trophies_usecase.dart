import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_user_trophies_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/digifit/digifit_user_trophies_request_model.dart';

final digifitUserTrophiesUseCaseProvider = Provider((ref) =>
    DigifitUserTrophiesUseCase(
        digifitUserTrophiesRepository:
            ref.read(digifitUserTrophiesRepositoryProvider)));

class DigifitUserTrophiesUseCase
    implements UseCase<BaseModel, DigifitUserTrophiesRequestModel> {
  final DigifitUserTrophiesRepoImpl digifitUserTrophiesRepository;

  DigifitUserTrophiesUseCase({required this.digifitUserTrophiesRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitUserTrophiesRequestModel requestModel,
      BaseModel responseModel) async {
    final result =
        await digifitUserTrophiesRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}