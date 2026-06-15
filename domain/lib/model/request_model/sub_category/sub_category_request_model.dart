import 'package:core/base_model.dart';

class SubCategoryRequestModel implements BaseModel<SubCategoryRequestModel> {
  int? id;

  SubCategoryRequestModel({this.id});

  @override
  SubCategoryRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}
