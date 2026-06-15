import 'package:core/base_model.dart';

class DeleteAccountResponseModel
    implements BaseModel<DeleteAccountResponseModel> {
  String? status;
  String? message;

  @override
  DeleteAccountResponseModel fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponseModel()
      ..status = json["status"]
      ..message = json["message"];
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
