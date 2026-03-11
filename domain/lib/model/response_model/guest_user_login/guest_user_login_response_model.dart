import 'package:core/base_model.dart';

class GuestUserLoginResponseModel
    implements BaseModel<GuestUserLoginResponseModel> {
  String? status;
  GuestUserLoginDataModel? data;

  GuestUserLoginResponseModel({
    this.status,
    this.data,
  });

  @override
  GuestUserLoginResponseModel fromJson(Map<String, dynamic> json) {
    return GuestUserLoginResponseModel(
      status: json['status'],
      data: GuestUserLoginDataModel.fromJson(json['data']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data != null ? data!.toJson() : "",
    };
  }
}

class GuestUserLoginDataModel {
  String? accessToken;
  int? userId;

  GuestUserLoginDataModel({this.accessToken, this.userId});

  factory GuestUserLoginDataModel.fromJson(Map<String, dynamic> json) {
    return GuestUserLoginDataModel(
      accessToken: json['accessToken'],
      userId: json['userId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'userId':userId
    };
  }
}
