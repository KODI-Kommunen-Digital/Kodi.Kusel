import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ortDetailServiceProvider =
Provider((ref) => OrtDetailService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class OrtDetailService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  OrtDetailService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final params = requestModel.toJson();
    final ordIdParams = requestModel.toJson()["ortId"];
    final path =
        "$ortDetailEndPoint/$ordIdParams?translate=${params["translate"]}";


    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final apiHelper = ref.read(apiHelperProvider);

    final result =
    await apiHelper.getRequest(
        path: path,
        headers: headers,
        create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
