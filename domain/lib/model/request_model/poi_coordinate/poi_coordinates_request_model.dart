import 'package:core/base_model.dart';

class PoiCoordinatesRequestModel
    implements BaseModel<PoiCoordinatesRequestModel> {
  String translate;

  PoiCoordinatesRequestModel({required this.translate});

  @override
  PoiCoordinatesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"translate": translate};
  }
}
