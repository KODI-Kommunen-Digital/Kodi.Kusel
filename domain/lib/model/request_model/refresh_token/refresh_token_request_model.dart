import 'package:core/base_model.dart';

class RefreshTokenRequestModel extends BaseModel<RefreshTokenRequestModel> {
  String? userId;

  RefreshTokenRequestModel({this.userId});

  @override
  RefreshTokenRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"userId": userId};
  }
}
