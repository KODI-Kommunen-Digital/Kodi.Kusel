import 'package:core/base_model.dart';

class UserDetailRequestModel implements BaseModel<UserDetailRequestModel> {
  int? id;

  UserDetailRequestModel({this.id});

  @override
  UserDetailRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}
