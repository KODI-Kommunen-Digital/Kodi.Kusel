import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';

import '../../service/digifit_services/digifit_fav_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitFavRepositoryProvider = Provider(
      (ref) => DigifitFavRepositoryImpl(
    digifitFavService:
    ref.read(digifitFavServiceProvider),
  ),
);

class DigifitFavRepositoryImpl implements Repository {
  final DigifitFavService
  digifitFavService;

  DigifitFavRepositoryImpl({
    required this.digifitFavService,
  });

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await digifitFavService.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
