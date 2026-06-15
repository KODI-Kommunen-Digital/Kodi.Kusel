import 'package:core/base_model.dart';

class SignInResponseModel implements BaseModel<SignInResponseModel> {
  String? status;
  SignInResponseData? data;
  int? errorCode;
  String? message;

  SignInResponseModel({this.status, this.data,this.message,this.errorCode});

  @override
  SignInResponseModel fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      status: json['status'],
      errorCode: json['errorCode'],
      message: json['message'],
      data: json['data'] != null ? SignInResponseData().fromJson(json['data']) : null,
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

class SignInResponseData implements BaseModel<SignInResponseData> {
  String? accessToken;
  String? refreshToken;
  int? userId;
  List<CityUser>? cityUsers;
  bool? isOnBoarded;

  SignInResponseData({this.accessToken, this.refreshToken, this.userId, this.cityUsers, this.isOnBoarded});

  @override
  SignInResponseData fromJson(Map<String, dynamic> json) {
    return SignInResponseData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      cityUsers: (json['cityUsers'] as List<dynamic>?)
          ?.map((e) => CityUser().fromJson(e))
          .toList(),
      isOnBoarded: json['isOnBoarded']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'cityUsers': cityUsers?.map((e) => e.toJson()).toList(),
      'isOnBoarded': isOnBoarded
    };
  }
}

class CityUser implements BaseModel<CityUser> {
  int? cityId;
  int? cityUserId;

  CityUser({this.cityId, this.cityUserId});

  @override
  CityUser fromJson(Map<String, dynamic> json) {
    return CityUser(
      cityId: json['cityId'],
      cityUserId: json['cityUserId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityUserId': cityUserId,
    };
  }
}
