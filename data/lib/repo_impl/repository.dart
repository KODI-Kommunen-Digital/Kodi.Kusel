
import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  /// Calls the repository with the given request and response models.
  ///
  /// Returns a [Future] that resolves to an [Either] containing either an
  /// [Exception] or a [BaseModel].
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}