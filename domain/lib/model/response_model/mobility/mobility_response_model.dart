import 'package:core/base_model.dart';

class MobilityResponseModel extends BaseModel<MobilityResponseModel> {
  final String? status;
  final MobilityData? data;

  MobilityResponseModel({this.status, this.data});

  @override
  MobilityResponseModel fromJson(Map<String, dynamic> json) {
    return MobilityResponseModel(
      status: json['status'],
      data: json['data'] != null ? MobilityData.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class MobilityData {
  final int? id;
  final String? title;
  final String? description;
  final String? iconUrl;
  final String? linkUrl;
  final String? imageUrl;
  final String? route;
  final int? displayOrder;
  final int? isActive;
  final List<MobilityItem>? servicesOffered;
  final List<MobilityItem>? moreInformations;
  final List<MobilityItem>? contactDetails;
  final List<dynamic>? links;

  MobilityData({
    this.id,
    this.title,
    this.description,
    this.iconUrl,
    this.linkUrl,
    this.imageUrl,
    this.route,
    this.displayOrder,
    this.isActive,
    this.servicesOffered,
    this.moreInformations,
    this.contactDetails,
    this.links,
  });

  factory MobilityData.fromJson(Map<String, dynamic> json) {
    return MobilityData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      linkUrl: json['linkUrl'],
      imageUrl: json['imageUrl'],
      route: json['route'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
      servicesOffered: (json['servicesOffered'] as List?)
          ?.map((e) => MobilityItem.fromJson(e))
          .toList(),
      moreInformations: (json['moreInformations'] as List?)
          ?.map((e) => MobilityItem.fromJson(e))
          .toList(),
      contactDetails: (json['contactDetails'] as List?)
          ?.map((e) => MobilityItem.fromJson(e))
          .toList(),
      links: json['links'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconUrl': iconUrl,
    'linkUrl': linkUrl,
    'imageUrl': imageUrl,
    'route': route,
    'displayOrder': displayOrder,
    'isActive': isActive,
    'servicesOffered':
    servicesOffered?.map((item) => item.toJson()).toList(),
    'moreInformations':
    moreInformations?.map((item) => item.toJson()).toList(),
    'contactDetails':
    contactDetails?.map((item) => item.toJson()).toList(),
    'links': links,
  };
}

class MobilityItem {
  final int? id;
  final int? discoverServiceId;
  final String? type;
  final String? title;
  final String? description;
  final String? iconUrl;
  final String? phone;
  final String? email;
  final String? linkUrl;
  final int? displayOrder;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  MobilityItem({
    this.id,
    this.discoverServiceId,
    this.type,
    this.title,
    this.description,
    this.iconUrl,
    this.phone,
    this.email,
    this.linkUrl,
    this.displayOrder,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory MobilityItem.fromJson(Map<String, dynamic> json) {
    return MobilityItem(
      id: json['id'],
      discoverServiceId: json['discoverServiceId'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      phone: json['phone'],
      email: json['email'],
      linkUrl: json['linkUrl'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'discoverServiceId': discoverServiceId,
    'type': type,
    'title': title,
    'description': description,
    'iconUrl': iconUrl,
    'phone': phone,
    'email': email,
    'linkUrl': linkUrl,
    'displayOrder': displayOrder,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
