import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../end_points.dart';

final localDigifitBulkTrackingServiceProvider = Provider(
  (ref) => LocalDigifitBulkTrackingService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class LocalDigifitBulkTrackingService {
  final Ref ref;
  final SharedPreferenceHelper sharedPreferenceHelper;

  LocalDigifitBulkTrackingService({
    required this.ref,
    required this.sharedPreferenceHelper,
  });

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final path = localDigifitBulkTrackingEndPoint;

    final body = requestModel.toJson();

    final result = await apiHelper.postRequest(
        path: path, create: () => responseModel, headers: headers, body: body);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
