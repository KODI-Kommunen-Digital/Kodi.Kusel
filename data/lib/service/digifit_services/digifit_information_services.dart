import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitInformationServiceProvider = Provider((ref) =>
    DigifitInformationService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class DigifitInformationService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  DigifitInformationService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final params = requestModel.toJson();
    final path = '$digifitInformationEndPoint?translate=${params["translate"]}';

    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.getRequest(
        create: () => responseModel, path: path, headers: headers);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
