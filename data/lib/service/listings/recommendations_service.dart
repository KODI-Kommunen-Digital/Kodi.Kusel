import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../dio_helper_object.dart';
import '../../end_points.dart';

final recommendationsServiceProvider = Provider((ref) => RecommendationService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class RecommendationService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  RecommendationService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final queryParams = requestModel
        .toJson()
        .entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
        .join("&");

    final path = "$recommendationsListingEndPoint?$queryParams";

    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.getRequest(
        path: path, headers: headers, create: () => responseModel);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
