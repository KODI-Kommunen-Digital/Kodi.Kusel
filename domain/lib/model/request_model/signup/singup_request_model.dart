import 'package:core/base_model.dart';

class SignUpRequestModel extends BaseModel<SignUpRequestModel> {
  String? username;
  String? email;
  int? roleId;
  String? firstname;
  String? lastname;
  String? password;
  String? description;
  String? website;
  Map<String, dynamic>? socialMedia;

  SignUpRequestModel({
    this.username,
    this.email,
    this.roleId,
    this.firstname,
    this.lastname,
    this.password,
    this.description,
    this.website,
    this.socialMedia,
  });

  @override
  SignUpRequestModel fromJson(Map<String, dynamic> json) {
    return SignUpRequestModel(
      username: json['username'] as String?,
      email: json['email'] as String?,
      roleId: json['roleId'] as int?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      password: json['password'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      socialMedia: json['socialMedia'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'roleId': roleId,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
      'description': description,
      'website': website,
      'socialMedia': socialMedia,
    };
  }
}
