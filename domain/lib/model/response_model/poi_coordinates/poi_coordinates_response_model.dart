import 'package:core/base_model.dart';

class PoiCoordinatesResponseModel
    implements BaseModel<PoiCoordinatesResponseModel> {
  String? status;
  List<PoiCoordinateItem>? data;

  PoiCoordinatesResponseModel({this.status, this.data});

  @override
  PoiCoordinatesResponseModel fromJson(Map<String, dynamic> json) {
    return PoiCoordinatesResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => PoiCoordinateItem().fromJson(e))
          .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (status != null) map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class PoiCoordinateItem implements BaseModel<PoiCoordinateItem> {
  int? id;
  double? latitude;
  double? longitude;
  int? categoryId;

  PoiCoordinateItem({this.id, this.latitude, this.longitude, this.categoryId});

  @override
  PoiCoordinateItem fromJson(Map<String, dynamic> json) {
    return PoiCoordinateItem(
      id: json['id'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      categoryId: json['categoryId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (categoryId != null) map['categoryId'] = categoryId;
    return map;
  }
}
