import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../end_points.dart';

final editUserImageServiceProvider = Provider((ref) =>
    EditUserImageService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class EditUserImageService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  EditUserImageService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(BaseModel requestModel,
      BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final path =
        "$userDetailsEndPoint${uploadImageEndPoint}";
    String imagePath = requestModel.toJson()['imagePath'];

    FormData body = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,
      ),
    });
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.postFormRequest(
        headers: headers,
        path: path,
        create: () => responseModel,
        body: body);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
