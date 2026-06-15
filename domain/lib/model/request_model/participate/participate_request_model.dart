import 'package:core/base_model.dart';

class ParticipateRequestModel implements BaseModel<ParticipateRequestModel>{

  String? translate;
  ParticipateRequestModel({required this.translate});

  @override
  ParticipateRequestModel fromJson(Map<String, dynamic> json) {
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