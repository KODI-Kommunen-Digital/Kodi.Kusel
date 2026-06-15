import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/get_interests/get_interests_repo_impl.dart';

final getInterestsUseCaseProvider = Provider((ref) => GetInterestsUseCase(
    getInterestsRepository: ref.read(getInterestsRepositoryProvider)));

class GetInterestsUseCase
    implements UseCase<BaseModel, EmptyRequest> {
  GetInterestsRepository getInterestsRepository;

  GetInterestsUseCase({required this.getInterestsRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
        await getInterestsRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
