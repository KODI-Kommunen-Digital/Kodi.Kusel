import 'package:core/base_model.dart';

class ResetPasswordRequestModel implements BaseModel<ResetPasswordRequestModel>{

  String oldPassword;
  String newPassword;

  ResetPasswordRequestModel({required this.newPassword, required this.oldPassword});

  @override
  ResetPasswordRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return  {
      "newPassword":newPassword,
      "oldPassword":oldPassword
    };
  }

}