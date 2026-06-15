import 'package:core/base_model.dart';

class ForgotPasswordResponseModel
    implements BaseModel<ForgotPasswordResponseModel> {
  String? status;
  String? message;

  ForgotPasswordResponseModel({this.message, this.status});

  @override
  ForgotPasswordResponseModel fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
        message: json['message'], status: json['status']);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
