import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_overview_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_overview_request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usecase.dart';

final digifitOverviewUseCaseProvider = Provider((ref) => DigifitOverviewUseCase(
    digifitOverviewRepository: ref.read(digifitOverviewRepositoryProvider)));

class DigifitOverviewUseCase
    implements UseCase<BaseModel, DigifitOverviewRequestModel> {
  final DigifitRepoImpl digifitOverviewRepository;

  DigifitOverviewUseCase({required this.digifitOverviewRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitOverviewRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
