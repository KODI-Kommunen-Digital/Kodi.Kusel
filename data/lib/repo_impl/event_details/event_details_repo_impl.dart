import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/service/event_details/event_details_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventDetailsRepositoryProvider = Provider((ref) => EventDetailsRepoImpl(
    eventDetailsService: ref.read(eventDetailsServiceProvider)));

abstract class EventDetailsRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class EventDetailsRepoImpl implements EventDetailsRepo {
  EventDetailsService eventDetailsService;

  EventDetailsRepoImpl({required this.eventDetailsService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await eventDetailsService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
