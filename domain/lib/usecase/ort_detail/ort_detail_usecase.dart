import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/ort_detail/ort_detail_repo.dart';
import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ortDetailUseCaseProvider = Provider((ref) => OrtDetailUseCase(
    ortDetailRepository: ref.read(ortDetailRepositoryProvider)));

class OrtDetailUseCase implements UseCase<BaseModel, OrtDetailResponseModel> {
  OrtDetailRepo ortDetailRepository;

  OrtDetailUseCase({required this.ortDetailRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await ortDetailRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
