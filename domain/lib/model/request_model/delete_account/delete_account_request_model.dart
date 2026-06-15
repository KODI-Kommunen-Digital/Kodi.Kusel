import 'package:core/base_model.dart';

class DeleteAccountRequestModel
    implements BaseModel<DeleteAccountRequestModel> {
  String token;
  String? id;

  DeleteAccountRequestModel({this.id, required this.token});

  @override
  DeleteAccountRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "token": token};
  }
}
