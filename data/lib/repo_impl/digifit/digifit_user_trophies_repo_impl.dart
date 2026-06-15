import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/digifit_services/digifit_user_trophies_services.dart';

final digifitUserTrophiesRepositoryProvider = Provider((ref) =>
    DigifitUserTrophiesRepoImpl(
        digifitUserTrophiesService:
            ref.read(digifitUserTrophiesServiceProvider)));

class DigifitUserTrophiesRepoImpl implements Repository {
  DigifitUserTrophiesService digifitUserTrophiesService;

  DigifitUserTrophiesRepoImpl({required this.digifitUserTrophiesService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitUserTrophiesService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}