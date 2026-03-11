import 'package:core/base_model.dart';

class DigifitFavRequestModel implements BaseModel<DigifitFavRequestModel> {
  String translate;
  int? pageNo;
  int? pageSize;

  DigifitFavRequestModel(
      {required this.translate, this.pageSize, this.pageNo});

  @override
  DigifitFavRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data = {
      "translate": translate,
      "pageNo": pageNo,
      "pageSize": pageSize
    };
    data.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));
    return data;
  }
}
