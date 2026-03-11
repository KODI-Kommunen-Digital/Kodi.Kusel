import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guestUserLoginServiceProvider =
    Provider((ref) => GuestUserLoginService(ref: ref));

class GuestUserLoginService {
  Ref ref;

  GuestUserLoginService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    final body = requestModel.toJson();

    final result = await apiHelper.postRequest(
        path: guestUserLoginEndPoint, body: body, create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
