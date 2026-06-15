import 'package:core/base_model.dart';

class OrtDetailRequestModel implements BaseModel<OrtDetailRequestModel> {
  String ortId;
  String translate;

  OrtDetailRequestModel({
    required this.ortId,
    required this.translate,
  });

  @override
  OrtDetailRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "ortId": ortId,
      "translate": translate,
    };
  }
}
