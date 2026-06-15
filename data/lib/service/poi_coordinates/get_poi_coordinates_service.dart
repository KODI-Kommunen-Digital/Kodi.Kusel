import 'package:core/base_model.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final poiCoordinatesServiceProvider = Provider((ref) => PoiCoordinatesService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class PoiCoordinatesService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  PoiCoordinatesService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path = "$getPOICoordinatesEndPoint?translate=${requestModel.toJson()["translate"]}";

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
