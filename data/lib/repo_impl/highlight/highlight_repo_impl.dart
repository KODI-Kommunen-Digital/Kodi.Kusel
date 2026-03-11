import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/highlight/highlight_service.dart';

final highlightRepositoryProvider = Provider((ref) =>
    HighlightRepoImpl(highlightService: ref.read(highlightServiceProvider)));

abstract class HighlightRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class HighlightRepoImpl implements HighlightRepo {
  HighlightService highlightService;

  HighlightRepoImpl({required this.highlightService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await highlightService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
