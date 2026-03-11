import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/feedback/feedback_service.dart';

final feedBackRepositoryProvider = Provider((ref) =>
    FeedBackRepoImpl(feedBackService: ref.read(feedBackServiceProvider)));

abstract class FeedBackRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class FeedBackRepoImpl implements FeedBackRepo {
  FeedBackService feedBackService;

  FeedBackRepoImpl({required this.feedBackService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await feedBackService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
