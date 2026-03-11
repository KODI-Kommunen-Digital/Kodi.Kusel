import 'package:core/base_model.dart';

class DigifitEquipmentFavResponseModel
    implements BaseModel<DigifitEquipmentFavResponseModel> {
  String? status;
  DigifitEquipmentFavDataModel? data;
  String? message;

  DigifitEquipmentFavResponseModel({this.status, this.data, this.message});

  @override
  DigifitEquipmentFavResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitEquipmentFavResponseModel(
        status: json['status'],
        data: json['data'] != null
            ? DigifitEquipmentFavDataModel().fromJson(json['data'])
            : null,
        message: json['message']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class DigifitEquipmentFavDataModel
    implements BaseModel<DigifitEquipmentFavDataModel> {
  bool? isFavorite;

  DigifitEquipmentFavDataModel({this.isFavorite});

  @override
  DigifitEquipmentFavDataModel fromJson(Map<String, dynamic> json) {
    return DigifitEquipmentFavDataModel(
      isFavorite: json['isFavorite'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isFavorite': isFavorite,
    };
  }
}
