import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Exception, Type>> call(
      Params requestModel, BaseModel responseModel);
}
