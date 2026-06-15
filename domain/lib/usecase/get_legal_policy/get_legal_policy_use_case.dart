import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/request_model/get_legal_policy/get_legal_policy_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/get_legal_policy/get_legal_policy_repository.dart';

final getLegalPolicyUseCaseProvider = Provider((ref) => GetLegalPolicyUseCase(
    getLegalPolicyRepository: ref.read(getLegalPolicyRepositoryProvider)));

class GetLegalPolicyUseCase
    implements UseCase<BaseModel, GetLegalPolicyRequestModel> {
  GetLegalPolicyRepository getLegalPolicyRepository;

  GetLegalPolicyUseCase({required this.getLegalPolicyRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      GetLegalPolicyRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await getLegalPolicyRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
