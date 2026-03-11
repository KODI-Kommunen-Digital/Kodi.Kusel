import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final digifitExerciseDetailsServicesProvider = Provider(
  (ref) => DigifitExerciseDetailsServices(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class DigifitExerciseDetailsServices {
  final Ref ref;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitExerciseDetailsServices({
    required this.ref,
    required this.sharedPreferenceHelper,
  });

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final locationId = requestModel.toJson()['locationId'];
    final equipmentId = requestModel.toJson()['id'];
    String? equipmentSlug = requestModel.toJson()['equipmentSlug'];

    final params = requestModel.toJson();

    String path =
        "$digifitExerciseDetailsEndPoint?translate=${params["translate"]}";

    if(locationId!=null && locationId!=0)
      {
        path = "$path&locationId=$locationId";
      }

    if(equipmentId!=null && equipmentId!=0)
      {
        path = "$path&equipmentId=$equipmentId";
      }

    if (equipmentSlug != null && equipmentSlug.isNotEmpty) {
      path = "$path&equipmentSlug=$equipmentSlug";
    }

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
