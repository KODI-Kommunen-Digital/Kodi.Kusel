import 'package:core/base_model.dart';

class ExploreDetailsResponseModel implements BaseModel<ExploreDetailsResponseModel> {
  final String? status;
  final MunicipalPartyDetailDataModel? data;

  ExploreDetailsResponseModel({
    this.status,
    this.data,
  });

  @override
  ExploreDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return ExploreDetailsResponseModel(
      status: json['status'],
      data: json['data'] != null ? MunicipalPartyDetailDataModel.fromJson(json['data']) : null,
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

class MunicipalPartyDetailDataModel {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? inCityServer;
  final bool? hasForum;
  final int? parentId;
  bool? isFavorite;
  final List<OnlineService>? onlineServices;
  final List<City>? topFiveCities;
  final List<Municipality>? municipalities; // Only present for district_admin type

  MunicipalPartyDetailDataModel({
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
    this.isFavorite,
    this.onlineServices,
    this.topFiveCities,
    this.municipalities,
  });

  factory MunicipalPartyDetailDataModel.fromJson(Map<String, dynamic> json) {
    return MunicipalPartyDetailDataModel(
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
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      inCityServer: json['inCityServer'],
      hasForum: json['hasForum'],
      parentId: json['parentId'],
      isFavorite: json['isFavorite'],
      onlineServices: json['onlineServices'] != null
          ? (json['onlineServices'] as List).map((e) => OnlineService.fromJson(e)).toList()
          : null,
      topFiveCities: json['topFiveCities'] != null
          ? (json['topFiveCities'] as List).map((e) => City.fromJson(e)).toList()
          : null,
      municipalities: json['municipalities'] != null
          ? (json['municipalities'] as List).map((e) => Municipality.fromJson(e)).toList()
          : null,
    );
  }

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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'inCityServer': inCityServer,
      'hasForum': hasForum,
      'parentId': parentId,
      'isFavorite': isFavorite,
      'onlineServices': onlineServices?.map((e) => e.toJson()).toList(),
      'topFiveCities': topFiveCities?.map((e) => e.toJson()).toList(),
      'municipalities': municipalities?.map((e) => e.toJson()).toList(),
    };
  }
}

class Municipality {
  int? id;
  String? name;
  String? type;
  String? image;
  String? mapImage;
  String? websiteUrl;
  int? parentId;
  bool? isFavorite;
  List<City>? topFiveCities;

  Municipality({
    this.id,
    this.name,
    this.type,
    this.image,
    this.mapImage,
    this.websiteUrl,
    this.parentId,
    this.isFavorite,
    this.topFiveCities,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      mapImage: json['mapImage'],
      websiteUrl: json['websiteUrl'],
      parentId: json['parentId'],
      isFavorite: json['isFavorite'],
      topFiveCities: json['topFiveCities'] != null
          ? (json['topFiveCities'] as List).map((e) => City.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'mapImage': mapImage,
      'websiteUrl': websiteUrl,
      'parentId': parentId,
      'isFavorite': isFavorite,
      'topFiveCities': topFiveCities?.map((e) => e.toJson()).toList(),
    };
  }
}

class City {
  int? id;
  String? name;
  String? type;
  String? image;
  String? mapImage;
  String? subtitle;
  String? websiteUrl;
  int? parentId;
  bool? isFavorite;

  City({
    this.id,
    this.name,
    this.type,
    this.image,
    this.mapImage,
    this.subtitle,
    this.websiteUrl,
    this.parentId,
    this.isFavorite,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      mapImage: json['mapImage'],
      subtitle: json['subtitle'],
      websiteUrl: json['websiteUrl'],
      parentId: json['parentId'],
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'mapImage': mapImage,
      'subtitle': subtitle,
      'websiteUrl': websiteUrl,
      'parentId': parentId,
      'isFavorite': isFavorite,
    };
  }
}

class OnlineService {
  final int? id;
  final String? title;
  final String? description;
  final String? linkUrl;
  final String? iconUrl;
  final int? displayOrder;
  final int? isActive;

  OnlineService({
    this.id,
    this.title,
    this.description,
    this.linkUrl,
    this.iconUrl,
    this.displayOrder,
    this.isActive,
  });

  factory OnlineService.fromJson(Map<String, dynamic> json) {
    return OnlineService(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      linkUrl: json['linkUrl'],
      iconUrl: json['iconUrl'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
    );
  }

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