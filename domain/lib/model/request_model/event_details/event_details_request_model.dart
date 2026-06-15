import 'package:core/base_model.dart';

class GetEventDetailsRequestModel implements BaseModel<GetEventDetailsRequestModel> {
  int? id;
  String? translate;

  GetEventDetailsRequestModel({this.id, this.translate});

  @override
  GetEventDetailsRequestModel fromJson(Map<String, dynamic> json) {
    return GetEventDetailsRequestModel(
      translate: json['translate'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'translate': translate,
    };
  }
}
