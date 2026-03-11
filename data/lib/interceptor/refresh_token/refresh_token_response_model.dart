import 'package:core/base_model.dart';

class RefreshTokenResponseModel extends BaseModel<RefreshTokenResponseModel> {
  final String? status;
  final String? message;
  final RefreshTokenResponseDataModel? data;

  RefreshTokenResponseModel({this.data, this.message, this.status});

  @override
  RefreshTokenResponseModel fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? RefreshTokenResponseDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }


  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class RefreshTokenResponseDataModel {
  final String? accessToken;
  final String? refreshToken;

  RefreshTokenResponseDataModel({
    this.accessToken,
    this.refreshToken,
  });

  factory RefreshTokenResponseDataModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseDataModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
