import 'package:core/base_model.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCityDetailsServiceProvider = Provider((ref) => GetCityDetailsService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class GetCityDetailsService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  GetCityDetailsService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    String path = ortDetailEndPoint;

    final requestToJson = requestModel.toJson();

    if (requestToJson['type'] != null &&
        (requestToJson['type'] as String).isNotEmpty) {
      path = "$path?type=${requestToJson['type']}";
    }

    final apiHelper = ref.read(apiHelperProvider);
    // String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    // final headers = {'Authorization': 'Bearer $token'};

    final result =
        await apiHelper.getRequest(path: path, create: () => responseModel);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
