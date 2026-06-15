import 'package:core/base_model.dart';

class SignUpResponseModel extends BaseModel<SignUpResponseModel> {
  String? status;
  int? errorCode;
  String? message;
  int? id;

  SignUpResponseModel({
    this.status,
    this.id,
    this.message,
    this.errorCode
  });

  @override
  SignUpResponseModel fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      status: json['status'] as String?,
      id: json['id'] as int?,
      message: json['message'],
      errorCode: json['errorCode']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
    };
  }
}
