import 'package:core/base_model.dart';

class WeatherRequestModel implements BaseModel<WeatherRequestModel>{

  String placeName;
  int days;

  WeatherRequestModel({required this.days, required this.placeName});
  @override
  WeatherRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'placeName':placeName,
      'days':days
    };
  }

}