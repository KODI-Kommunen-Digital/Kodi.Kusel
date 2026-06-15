import 'package:core/base_model.dart';

class OrtDetailResponseModel implements BaseModel<OrtDetailResponseModel> {
  OrtDetailResponseModel({this.status, this.data});

  String? status;
  OrtDetailDataModel? data;

  @override
  OrtDetailResponseModel fromJson(Map<String, dynamic> json) {
    return OrtDetailResponseModel(
      status: json['status'],
      data: json['data'] != null ? OrtDetailDataModel().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class OrtDetailDataModel implements BaseModel<OrtDetailDataModel> {
  int? id;
  String? name;
  String? type;
  String? connectionString;
  bool? isAdminListings;
  String? image;
  String? description;
  String? subtitle;
  String? mapImage;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  String? websiteUrl;
  String? openUntil;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  bool? inCityServer;
  bool? hasForum;
  int? parentId;
  bool? isFavorite;
  List<OnlineServiceModel>? onlineServices;
  String? mayorName;
  String? mayorImage;
  String? mayorDescription;

  @override
  OrtDetailDataModel fromJson(Map<String, dynamic> json) {
    return OrtDetailDataModel()
      ..id = json['id']
      ..name = json['name']
      ..type = json['type']
      ..connectionString = json['connectionString']
      ..isAdminListings = json['isAdminListings']
      ..image = json['image']
      ..description = json['description']
      ..subtitle = json['subtitle']
      ..mapImage = json['mapImage']
      ..address = json['address']
      ..latitude = json['latitude']
      ..longitude = json['longitude']
      ..phone = json['phone']
      ..email = json['email']
      ..websiteUrl = json['websiteUrl'] ?? "https://www.landkreis-kusel.de"
      ..openUntil = json['openUntil']
      ..isActive = json['isActive']
      ..createdAt = json['createdAt']
      ..updatedAt = json['updatedAt']
      ..inCityServer = json['inCityServer']
      ..hasForum = json['hasForum']
      ..parentId = json['parentId']
      ..isFavorite = json['isFavorite']
      ..onlineServices = (json['onlineServices'] as List?)?.map((e) => OnlineServiceModel().fromJson(e)).toList()
      ..mayorName=json['mayor_name']
    ..mapImage=json['mayor_image']
    ..mayorDescription=json['mayor_description'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'connectionString': connectionString,
      'isAdminListings': isAdminListings,
      'image': image,
      'description': description,
      'subtitle': subtitle,
      'mapImage': mapImage,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'websiteUrl': websiteUrl,
      'openUntil': openUntil,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
      'isFavorite': isFavorite,
      'onlineServices': onlineServices?.map((e) => e.toJson()).toList(),
    };
  }
}

class OnlineServiceModel implements BaseModel<OnlineServiceModel> {
  int? id;
  String? title;
  String? description;
  String? linkUrl;
  String? iconUrl;
  int? displayOrder;
  int? isActive;

  @override
  OnlineServiceModel fromJson(Map<String, dynamic> json) {
    return OnlineServiceModel()
      ..id = json['id']
      ..title = json['title']
      ..description = json['description']
      ..linkUrl = json['linkUrl']
      ..iconUrl = json['iconUrl']
      ..displayOrder = json['displayOrder']
      ..isActive = json['isActive'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'linkUrl': linkUrl,
      'iconUrl': iconUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }
}
