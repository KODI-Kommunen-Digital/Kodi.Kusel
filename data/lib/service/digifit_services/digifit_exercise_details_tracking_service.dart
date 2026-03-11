import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dio_helper_object.dart';
import '../../end_points.dart';

final digifitExerciseDetailsTrackingService = Provider(
  (ref) => DigifitExerciseDetailsTrackingService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class DigifitExerciseDetailsTrackingService {
  final Ref ref;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitExerciseDetailsTrackingService({
    required this.ref,
    required this.sharedPreferenceHelper,
  });

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final path = digifitExerciseDetailsTrackingEndPoint;

    final body = requestModel.toJson();

    final result = await apiHelper.postRequest(
        path: path, create: () => responseModel, headers: headers, body: body);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
