import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/filter/get_filter_repo_impl.dart';
import 'package:domain/model/request_model/filter/get_filter_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFilterUseCaseProvider = Provider((ref) => GetFilterUseCase(
    getFilterRepository: ref.read(getFilterRepositoryProvider)));

class GetFilterUseCase implements UseCase<BaseModel, GetFilterRequestModel> {
  GetFilterRepo getFilterRepository;

  GetFilterUseCase({required this.getFilterRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GetFilterRequestModel requestModel, BaseModel responseModel) async {
    final result = await getFilterRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
