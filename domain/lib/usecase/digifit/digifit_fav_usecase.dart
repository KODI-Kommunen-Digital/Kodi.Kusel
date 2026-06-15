import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/digifit/digifit_fav_repo_impl.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/model/request_model/digitfit_fav/digifit_fav_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitFavUseCaseProvider = Provider((ref) =>
    DigifitFavUseCase(
        digifitFavRepository:
        ref.read(digifitFavRepositoryProvider)));

class DigifitFavUseCase
    implements UseCase<BaseModel, DigifitFavRequestModel> {
  final DigifitFavRepositoryImpl digifitFavRepository;

  DigifitFavUseCase(
      {required this.digifitFavRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitFavRequestModel requestModel,
      BaseModel responseModel) async {
    final result = await digifitFavRepository.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
