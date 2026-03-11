import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../dio_helper_object.dart';
import '../../end_points.dart';

final digifitOverviewServiceProvider = Provider((ref) => DigifitOverviewService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class DigifitOverviewService {
  final Ref ref;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitOverviewService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final location = requestModel.toJson()['locationId'];
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final params = requestModel.toJson();

    final path = "$digifitOverviewEndPoint/$location?translate=${params["translate"]}";

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
