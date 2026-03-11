import 'package:core/base_model.dart';

class AddFavoritesRequestModel implements BaseModel<AddFavoritesRequestModel> {
  String? cityId;
  String? listingId;
  String? userId;
  String? translate;

  AddFavoritesRequestModel({this.userId, this.cityId, this.listingId, this.translate});

  @override
  AddFavoritesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "cityId": cityId,
      "listingId": listingId,
      'translate': translate,
    };
  }
}
