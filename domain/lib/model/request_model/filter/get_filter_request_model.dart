import 'package:core/base_model.dart';

class GetFilterRequestModel implements BaseModel<GetFilterRequestModel> {
  String? translate;

  GetFilterRequestModel({this.translate});

  @override
  GetFilterRequestModel fromJson(Map<String, dynamic> json) => this;

  @override
  Map<String, dynamic> toJson() => {'translate': translate};
}
