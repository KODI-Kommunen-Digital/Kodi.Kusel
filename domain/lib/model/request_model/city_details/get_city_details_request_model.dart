import 'package:core/base_model.dart';

class GetCityDetailsRequestModel  extends BaseModel<GetCityDetailsRequestModel>{
  final bool hasForum;
  String? type;

  GetCityDetailsRequestModel({required this.hasForum,
  this.type});

  @override
  Map<String, dynamic> toJson() {
    return {
      'hasForum': hasForum,
      'type':type
    };
  }

  @override
  GetCityDetailsRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
