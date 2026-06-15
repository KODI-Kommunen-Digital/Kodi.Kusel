import 'package:core/base_model.dart';

class DeleteFavouriteCityRequestModel
    implements BaseModel<DeleteFavouriteCityRequestModel> {
  final int? userId;
  final int? cityId;

  DeleteFavouriteCityRequestModel({this.userId, required this.cityId});

  @override
  DeleteFavouriteCityRequestModel fromJson(Map<String, dynamic> json) {
    return DeleteFavouriteCityRequestModel(
        userId: json['userId'], cityId: json['cityId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'cityId': cityId};
  }
}
