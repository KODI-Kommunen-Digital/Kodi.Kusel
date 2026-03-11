import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAccountServiceProvider =
    Provider((ref) => DeleteAccountService(ref: ref));

class DeleteAccountService {
  Ref ref;

  DeleteAccountService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final token = requestModel.toJson()["token"];

    final path = "$deleteAccountEndPoint/";
    final apiHelper = ref.read(apiHelperProvider);
    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.delete(
        path: path, create: () => responseModel, headers: headers);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
