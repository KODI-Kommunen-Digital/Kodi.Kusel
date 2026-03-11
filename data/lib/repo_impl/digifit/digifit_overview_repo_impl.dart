import 'package:dartz/dartz.dart';
import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/digifit_services/digifit_overview_services.dart';

final digifitOverviewRepositoryProvider = Provider((ref) => DigifitRepoImpl(
    digifitOverviewService: ref.read(digifitOverviewServiceProvider)));

class DigifitRepoImpl implements Repository {
  final DigifitOverviewService digifitOverviewService;

  DigifitRepoImpl({required this.digifitOverviewService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitOverviewService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
