import 'package:core/base_model.dart';

class AddFavouriteCityRequestModel
    implements BaseModel<AddFavouriteCityRequestModel> {
  final String? cityId;

  AddFavouriteCityRequestModel({required this.cityId});

  @override
  AddFavouriteCityRequestModel fromJson(Map<String, dynamic> json) {
    return AddFavouriteCityRequestModel(cityId: json['cityId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'cityId': cityId};
  }
}
