import 'package:core/base_model.dart';

class MeinOrtRequestModel implements BaseModel<MeinOrtRequestModel>{

  String? translate;
  MeinOrtRequestModel({required this.translate});

  @override
  MeinOrtRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "translate":translate
    };
  }

}