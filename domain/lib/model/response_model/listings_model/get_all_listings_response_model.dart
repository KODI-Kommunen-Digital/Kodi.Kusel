import 'package:core/base_model.dart';

class GetAllListingsResponseModel
    extends BaseModel<GetAllListingsResponseModel> {
  String? status;
  List<Listing>? data;

  GetAllListingsResponseModel({this.status, this.data});

  @override
  GetAllListingsResponseModel fromJson(Map<String, dynamic> json) {
    return GetAllListingsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Listing.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Listing {
  int? id;
  String? title;
  String? description;
  String? createdAt;
  double? latitude;
  double? longitude;
  int? userId;
  String? startDate;
  String? endDate;
  int? statusId;
  int? categoryId;
  int? subcategoryId;
  bool? showExternal;
  int? appointmentId;
  int? viewCount;
  String? externalId;
  String? expiryDate;
  int? sourceId;
  String? website;
  String? address;
  String? email;
  String? phone;
  int? zipcode;
  String? pdf;
  int? cityId;
  int? cityCount;
  List<int>? allCities;
  String? logo;
  int? logoCount;
  List<OtherLogo>? otherLogos;
  bool? isFavorite;
  String? categoryName;

  Listing({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.userId,
    this.startDate,
    this.endDate,
    this.statusId,
    this.categoryId,
    this.subcategoryId,
    this.showExternal,
    this.appointmentId,
    this.viewCount,
    this.externalId,
    this.expiryDate,
    this.sourceId,
    this.website,
    this.address,
    this.email,
    this.phone,
    this.zipcode,
    this.pdf,
    this.cityId,
    this.cityCount,
    this.allCities,
    this.logo,
    this.logoCount,
    this.otherLogos,
    this.isFavorite,
    this.categoryName,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      userId: json['userId'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      statusId: json['statusId'] as int?,
      categoryId: json['categoryId'] as int?,
      subcategoryId: json['subcategoryId'] as int?,
      showExternal: (json['showExternal'] as int?) == 1,
      appointmentId: json['appointmentId'] as int?,
      viewCount: json['viewCount'] as int?,
      externalId: json['externalId'] as String?,
      expiryDate: json['expiryDate'] as String?,
      sourceId: json['sourceId'] as int?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      zipcode: json['zipcode'] as int?,
      pdf: json['pdf'] as String?,
      cityId: json['cityId'] as int?,
      cityCount: json['cityCount'] as int?,
      allCities: json['allCities'] != null
          ? List<int>.from(json['allCities'] as List)
          : null,
      logo: json['logo'],
      logoCount: json['logoCount'] as int?,
      otherLogos: json['otherLogos'] != null
          ? (json['otherLogos'] as List)
          .map((x) => OtherLogo.fromJson(x as Map<String, dynamic>))
          .toList()
          : null,
      isFavorite: json['isFavorite'] as bool?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'statusId': statusId,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'showExternal': showExternal! ? 1 : 0,
      'appointmentId': appointmentId,
      'viewCount': viewCount,
      'externalId': externalId,
      'expiryDate': expiryDate,
      'sourceId': sourceId,
      'website': website,
      'address': address,
      'email': email,
      'phone': phone,
      'zipcode': zipcode,
      'pdf': pdf,
      'cityId': cityId,
      'cityCount': cityCount,
      'allCities': allCities,
      'logo': logo,
      'logoCount': logoCount,
      'otherLogos': otherLogos?.map((x) => x.toJson()).toList(),
      'isFavorite': isFavorite,
      'categoryName': categoryName,
    };
  }
}

class OtherLogo {
  int? id;
  String? logo;
  int? listingId;
  int? imageOrder;

  OtherLogo({this.id, this.logo, this.listingId, this.imageOrder});

  factory OtherLogo.fromJson(Map<String, dynamic> json) {
    return OtherLogo(
      id: json['id'] as int?,
      logo: json['logo'],
      listingId: json['listingId'] as int?,
      imageOrder: json['imageOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo': logo,
      'listingId': listingId,
      'imageOrder': imageOrder,
    };
  }
}
