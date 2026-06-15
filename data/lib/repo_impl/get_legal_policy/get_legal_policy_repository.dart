import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/get_legal_policy/get_legal_policy_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final getLegalPolicyRepositoryProvider = Provider((ref) =>
    GetInterestsRepoImpl(getLegalPolicy: ref.read(getLegalPolicyServiceProvider)));

abstract class GetLegalPolicyRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GetInterestsRepoImpl implements GetLegalPolicyRepository {
  GetLegalPolicyService getLegalPolicy;

  GetInterestsRepoImpl({required this.getLegalPolicy});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await getLegalPolicy.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
