import 'package:core/base_model.dart';

class RefreshTokenRequestModel extends BaseModel<RefreshTokenRequestModel> {
  String refreshToken;

  RefreshTokenRequestModel({required this.refreshToken});

  @override
  RefreshTokenRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
     throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"refreshToken": refreshToken};
  }
}
