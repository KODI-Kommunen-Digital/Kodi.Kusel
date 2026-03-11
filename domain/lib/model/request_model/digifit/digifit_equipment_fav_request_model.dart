import 'package:core/base_model.dart';

class DigifitEquimentFavRequestModel
    implements BaseModel<DigifitEquimentFavRequestModel> {
  bool isFavorite;
  int equipmentId;
  int locationId;

  DigifitEquimentFavRequestModel({
    required this.isFavorite,
    required this.equipmentId,
    required this.locationId,
  });

  @override
  DigifitEquimentFavRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitEquimentFavRequestModel(
      isFavorite: json['isFavorite'],
      equipmentId: json['equipmentId'],
      locationId: json['locationId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isFavorite': isFavorite,
      'equipmentId': equipmentId,
      'locationId': locationId,
    };
  }
}
