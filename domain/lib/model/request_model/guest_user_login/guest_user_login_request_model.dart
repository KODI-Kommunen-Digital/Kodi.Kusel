import 'package:core/base_model.dart';

class GuestUserLoginRequestModel
    implements BaseModel<GuestUserLoginRequestModel> {
  String deviceId;

  GuestUserLoginRequestModel({required this.deviceId});

  @override
  GuestUserLoginRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"deviceId": deviceId};
  }
}
