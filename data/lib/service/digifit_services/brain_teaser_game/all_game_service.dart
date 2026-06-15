import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../end_points.dart';

final brainTeaserGamesServiceProvider = Provider((ref) =>
    BrainTeaserGamesService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class BrainTeaserGamesService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  BrainTeaserGamesService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    final params = requestModel.toJson();

    final gameId = requestModel.toJson()['gameId'];
    final levelId = requestModel.toJson()['levelId'];

    final path =
        "$brainTeaserGamesEndPoint/$gameId/$levelId?translate=${params["translate"]}";

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
