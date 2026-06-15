import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../end_points.dart';

final editUserDetailServiceProvider = Provider((ref) => EditUserDetailService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class EditUserDetailService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  EditUserDetailService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final path = "$userDetailsEndPoint/";
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.patchRequest(
        headers: headers,
        path: path,
        create: () => responseModel,
        body: requestModel.toJson());
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
