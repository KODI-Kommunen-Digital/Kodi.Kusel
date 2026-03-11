import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final municipalPartyDetailServiceProvider = Provider((ref) =>
    MunicipalPartyDetailService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class MunicipalPartyDetailService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  MunicipalPartyDetailService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final params = requestModel.toJson();
    final municipalIdParams = requestModel.toJson()["municipalId"];

    final path = "$ortDetailEndPoint/$municipalIdParams?translate=${params["translate"]}";

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.getRequest(
        path: path, headers: headers, create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
