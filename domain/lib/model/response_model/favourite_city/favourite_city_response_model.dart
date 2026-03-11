import 'package:core/base_model.dart';

class GetFavouriteCitiesResponseModel
    implements BaseModel<GetFavouriteCitiesResponseModel> {
  final String? status;
  final List<CityModel>? data;

  GetFavouriteCitiesResponseModel({this.status, this.data});

  @override
  GetFavouriteCitiesResponseModel fromJson(Map<String, dynamic> json) {
    return GetFavouriteCitiesResponseModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CityModel().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class CityModel implements BaseModel<CityModel> {
  final int? id;
  final String? name;
  final String? type;
  final String? connectionString;
  final bool? isAdminListings;
  final String? image;
  final String? description;
  final String? subtitle;
  final String? mapImage;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final String? openUntil;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  final bool? inCityServer;
  final bool? hasForum;
  final int? parentId;

  CityModel({
    this.id,
    this.name,
    this.type,
    this.connectionString,
    this.isAdminListings,
    this.image,
    this.description,
    this.subtitle,
    this.mapImage,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.websiteUrl,
    this.openUntil,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.inCityServer,
    this.hasForum,
    this.parentId,
  });

  @override
  CityModel fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      connectionString: json['connectionString'],
      isAdminListings: json['isAdminListings'],
      image: json['image'],
      description: json['description'],
      subtitle: json['subtitle'],
      mapImage: json['mapImage'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      websiteUrl: json['websiteUrl'],
      openUntil: json['openUntil'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inCityServer: json['inCityServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
    );
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
    };
  }
}
