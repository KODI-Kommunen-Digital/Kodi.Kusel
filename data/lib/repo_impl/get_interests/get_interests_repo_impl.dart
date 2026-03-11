import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/get_interests/get_interests_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final getInterestsRepositoryProvider = Provider((ref) =>
    GetInterestsRepoImpl(getInterestsService: ref.read(getInterestsServiceProvider)));

abstract class GetInterestsRepository {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class GetInterestsRepoImpl implements GetInterestsRepository {
  GetInterestsService getInterestsService;

  GetInterestsRepoImpl({required this.getInterestsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await getInterestsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
