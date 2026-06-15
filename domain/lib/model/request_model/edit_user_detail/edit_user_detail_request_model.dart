import 'package:core/base_model.dart';

class EditUserDetailRequestModel
    implements BaseModel<EditUserDetailRequestModel> {
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

  EditUserDetailRequestModel({
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
    this.address
  });

  @override
  EditUserDetailRequestModel fromJson(Map<String, dynamic> json) {
    return EditUserDetailRequestModel(
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
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final entries = {
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
      'address': address
    }.entries.where((e) => e.value != null);
    return Map.fromEntries(entries);
  }
}
