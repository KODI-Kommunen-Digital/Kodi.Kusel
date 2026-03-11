import 'package:core/base_model.dart';

class MobilityRequestModel implements BaseModel<MobilityRequestModel>{

  String? translate;
  MobilityRequestModel({required this.translate});

  @override
  MobilityRequestModel fromJson(Map<String, dynamic> json) {
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