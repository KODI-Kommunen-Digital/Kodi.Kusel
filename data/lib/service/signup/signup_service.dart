import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpServiceProvider = Provider((ref) => SignUpService(ref: ref));

class SignUpService {
  Ref ref;

  SignUpService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.postRequest(
        path: signUpEndPoint,
        create: () => responseModel,
        body: requestModel.toJson());

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
