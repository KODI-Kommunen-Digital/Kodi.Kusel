import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../end_points.dart';

final brainTeaserGameDetailsServiceProvider = Provider((ref) =>
    BrainTeaserGameDetailsService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class BrainTeaserGameDetailsService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  BrainTeaserGameDetailsService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final id = requestModel.toJson()['id'];

    final params = requestModel.toJson();

    final path =
        "$brainTeaserGameDetailsEndPoint/$id?translate=${params["translate"]}";

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
