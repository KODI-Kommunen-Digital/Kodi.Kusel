import 'package:core/base_model.dart';

class ParticipateResponseModel implements BaseModel<ParticipateResponseModel> {
  String? status;
  ParticipateData? data;

  ParticipateResponseModel({this.status, this.data});

  @override
  ParticipateResponseModel fromJson(Map<String, dynamic> json) {
    return ParticipateResponseModel(
      status: json['status'],
      data: json['data'] != null ? ParticipateData().fromJson(json['data']) : null,
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

class ParticipateData implements BaseModel<ParticipateData> {
  int? id;
  String? title;
  String? description;
  String? iconUrl;
  String? linkUrl;
  String? imageUrl;
  String? route;
  int? displayOrder;
  int? isActive;
  List<Service>? servicesOffered;
  List<Info>? moreInformations;
  List<Contact>? contactDetails;
  List<Link>? links;

  ParticipateData({
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

  @override
  ParticipateData fromJson(Map<String, dynamic> json) {
    return ParticipateData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      linkUrl: json['linkUrl'],
      imageUrl: json['imageUrl'],
      route: json['route'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
      servicesOffered: (json['servicesOffered'] as List?)?.map((e) => Service().fromJson(e)).toList(),
      moreInformations: (json['moreInformations'] as List?)?.map((e) => Info().fromJson(e)).toList(),
      contactDetails: (json['contactDetails'] as List?)?.map((e) => Contact().fromJson(e)).toList(),
      links: (json['links'] as List?)?.map((e) => Link().fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'linkUrl': linkUrl,
      'imageUrl': imageUrl,
      'route': route,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'servicesOffered': servicesOffered?.map((e) => e.toJson()).toList(),
      'moreInformations': moreInformations?.map((e) => e.toJson()).toList(),
      'contactDetails': contactDetails?.map((e) => e.toJson()).toList(),
      'links': links?.map((e) => e.toJson()).toList(),
    };
  }
}

class Service implements BaseModel<Service> {
  int? id;
  int? discoverServiceId;
  String? type;
  String? title;
  String? description;
  String? iconUrl;
  String? phone;
  String? email;
  String? linkUrl;
  int? displayOrder;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Service();

  @override
  Service fromJson(Map<String, dynamic> json) {
    return Service()
      ..id = json['id']
      ..discoverServiceId = json['discoverServiceId']
      ..type = json['type']
      ..title = json['title']
      ..description = json['description']
      ..iconUrl = json['iconUrl']
      ..phone = json['phone']
      ..email = json['email']
      ..linkUrl = json['linkUrl']
      ..displayOrder = json['displayOrder']
      ..isActive = json['isActive']
      ..createdAt = json['createdAt']
      ..updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
}

class Info implements BaseModel<Info> {
  int? id;
  int? discoverServiceId;
  String? type;
  String? title;
  String? description;
  String? iconUrl;
  String? phone;
  String? email;
  String? linkUrl;
  int? displayOrder;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Info();

  @override
  Info fromJson(Map<String, dynamic> json) {
    return Info()
      ..id = json['id']
      ..discoverServiceId = json['discoverServiceId']
      ..type = json['type']
      ..title = json['title']
      ..description = json['description']
      ..iconUrl = json['iconUrl']
      ..phone = json['phone']
      ..email = json['email']
      ..linkUrl = json['linkUrl']
      ..displayOrder = json['displayOrder']
      ..isActive = json['isActive']
      ..createdAt = json['createdAt']
      ..updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
}

class Contact implements BaseModel<Contact> {
  int? id;
  int? discoverServiceId;
  String? type;
  String? title;
  String? description;
  String? iconUrl;
  String? phone;
  String? email;
  String? linkUrl;
  int? displayOrder;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Contact();

  @override
  Contact fromJson(Map<String, dynamic> json) {
    return Contact()
      ..id = json['id']
      ..discoverServiceId = json['discoverServiceId']
      ..type = json['type']
      ..title = json['title']
      ..description = json['description']
      ..iconUrl = json['iconUrl']
      ..phone = json['phone']
      ..email = json['email']
      ..linkUrl = json['linkUrl']
      ..displayOrder = json['displayOrder']
      ..isActive = json['isActive']
      ..createdAt = json['createdAt']
      ..updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
}

class Link implements BaseModel<Link> {
  int? id;
  int? discoverServiceId;
  String? type;
  String? title;
  String? description;
  String? iconUrl;
  String? phone;
  String? email;
  String? linkUrl;
  int? displayOrder;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Link();

  @override
  Link fromJson(Map<String, dynamic> json) {
    return Link()
      ..id = json['id']
      ..discoverServiceId = json['discoverServiceId']
      ..type = json['type']
      ..title = json['title']
      ..description = json['description']
      ..iconUrl = json['iconUrl']
      ..phone = json['phone']
      ..email = json['email']
      ..linkUrl = json['linkUrl']
      ..displayOrder = json['displayOrder']
      ..isActive = json['isActive']
      ..createdAt = json['createdAt']
      ..updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
}
