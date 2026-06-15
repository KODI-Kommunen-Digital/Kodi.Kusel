import 'package:core/base_model.dart';

class UserDetailResponseModel implements BaseModel<UserDetailResponseModel> {
  String? status;
  UserData? data;

  UserDetailResponseModel({
    this.status,
    this.data,
  });

  @override
  UserDetailResponseModel fromJson(Map<String, dynamic> json) {
    return UserDetailResponseModel(
      status: json['status'],
      data: json['data'] != null ? UserData().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "data": data?.toJson(),
    };
  }
}

class UserData implements BaseModel<UserData> {
  int? id;
  String? username;
  String? socialMedia;
  String? email;
  String? website;
  String? description;
  String? image;
  String? phoneNumber;
  String? firstname;
  String? lastname;
  int? roleId;

  String? address;
  Place? place;
  List<UserDetailInterest>? interests;

  UserData({
    this.id,
    this.username,
    this.socialMedia,
    this.email,
    this.website,
    this.description,
    this.image,
    this.phoneNumber,
    this.firstname,
    this.lastname,
    this.roleId,
    this.address,
    this.place,
    this.interests,
  });

  @override
  UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      socialMedia: json['socialMedia'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      roleId: json['roleId'],
      address: json['address'],

      place: json['place'] != null ? Place().fromJson(json['place']) : null,

      interests: json['interests'] != null
          ? List<UserDetailInterest>.from(
          json['interests'].map((x) => UserDetailInterest().fromJson(x)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'socialMedia': socialMedia,
      'email': email,
      'website': website,
      'description': description,
      'image': image,
      'phoneNumber': phoneNumber,
      'firstname': firstname,
      'lastname': lastname,
      'roleId': roleId,
      'address': address,
      'place': place?.toJson(),
      'interests': interests?.map((e) => e.toJson()).toList(),
    };
  }
}

class Place implements BaseModel<Place> {
  int? id;
  String? name;

  Place({this.id, this.name});

  @override
  Place fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserDetailInterest implements BaseModel<UserDetailInterest> {
  int? id;
  String? name;

  UserDetailInterest({this.id, this.name});

  @override
  UserDetailInterest fromJson(Map<String, dynamic> json) {
    return UserDetailInterest(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
