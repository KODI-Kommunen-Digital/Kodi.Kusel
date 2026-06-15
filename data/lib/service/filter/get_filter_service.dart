import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFilterServiceProvider = Provider((ref) => GetFilterService(ref: ref));

class GetFilterService {
  Ref ref;

  GetFilterService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final params = requestModel.toJson();

    final path = '$getFilterEndPoint?translate=${params["translate"]}';

    final result = await apiHelper.getRequest(
      path: path,
      create: () => responseModel,
    );

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
