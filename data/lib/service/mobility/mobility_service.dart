import 'package:core/base_model.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mobilityServiceProvider = Provider((ref) => MobilityService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class MobilityService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  MobilityService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path = "$mobilityPath?translate=${requestModel.toJson()["translate"]}";

    final apiHelper = ref.read(apiHelperProvider);

    final result =
    await apiHelper.getRequest(
        path: path,
        create: () => responseModel
    );

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
