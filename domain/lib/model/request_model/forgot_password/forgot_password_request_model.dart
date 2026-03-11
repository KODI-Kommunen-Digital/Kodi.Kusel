import 'package:core/base_model.dart';

class ForgotPasswordRequestModel
    implements BaseModel<ForgotPasswordRequestModel> {
  String? userNameOrEmail;
  String? language;

  ForgotPasswordRequestModel({this.language, this.userNameOrEmail});

  @override
  ForgotPasswordRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"username": userNameOrEmail, "language": language};
  }
}
