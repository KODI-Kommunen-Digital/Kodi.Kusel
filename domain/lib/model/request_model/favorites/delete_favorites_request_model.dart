import 'package:core/base_model.dart';

class DeleteFavoritesRequestModel implements BaseModel<DeleteFavoritesRequestModel> {
  int? id;
  int? userId;

  DeleteFavoritesRequestModel({this.userId, this.id});

  @override
  DeleteFavoritesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "id": id,
    };
  }
}
