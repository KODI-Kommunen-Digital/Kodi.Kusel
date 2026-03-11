import 'package:core/base_model.dart';

class ResetPasswordResponseModel implements BaseModel<ResetPasswordResponseModel>
{
  bool? success;
  String? message;

  ResetPasswordResponseModel({this.message, this.success});

  @override
  ResetPasswordResponseModel fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'],
      success: json['success']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return  {};
  }

}