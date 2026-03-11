import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/feedback/feeback_repo_impl.dart';
import 'package:domain/model/request_model/feedback/feedback_request_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedBackUseCaseProvider = Provider((ref) => FeedBackUseCase(
    feedBackRepository: ref.read(feedBackRepositoryProvider)));

class FeedBackUseCase implements UseCase<BaseModel, FeedBackRequestModel> {
  FeedBackRepo feedBackRepository;

  FeedBackUseCase({required this.feedBackRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      FeedBackRequestModel requestModel, BaseModel responseModel) async {
    final result = await feedBackRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
