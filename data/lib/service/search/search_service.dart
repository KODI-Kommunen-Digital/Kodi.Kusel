import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = Provider(
    (ref) => SearchService(ref: ref));

class SearchService {
  Ref ref;

  SearchService({required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final endpoint = Uri.parse(searchEndPoint).replace(queryParameters: {
      'searchQuery': (requestModel.toJson()["searchQuery"] ?? "").toString(),
    });

    final path =
        "${endpoint.toString()}&translate=${requestModel.toJson()["translate"]}";

    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.getRequest(
        path: path,
        create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
