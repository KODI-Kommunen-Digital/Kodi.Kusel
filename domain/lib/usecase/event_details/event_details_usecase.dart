import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/event_details/event_details_repo_impl.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/request_model/event_details/event_details_request_model.dart';

final eventDetailsUseCaseProvider = Provider((ref) => EventDetailsUseCase(
    eventDetailsRepo: ref.read(eventDetailsRepositoryProvider)));

class EventDetailsUseCase
    implements UseCase<BaseModel, GetEventDetailsRequestModel> {
  EventDetailsRepo eventDetailsRepo;

  EventDetailsUseCase({required this.eventDetailsRepo});

  @override
  Future<Either<Exception, BaseModel>> call(
      GetEventDetailsRequestModel requestModel, BaseModel responseModel) async {
    final result = await eventDetailsRepo.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
