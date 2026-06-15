import 'package:core/base_model.dart';

import '../explore_details/explore_details_response_model.dart';

class GetCityDetailsResponseModel
    extends BaseModel<GetCityDetailsResponseModel> {
  final String? status;
  final List<City>? data;

  GetCityDetailsResponseModel({this.status, this.data});

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  GetCityDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetCityDetailsResponseModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e))
          .toList(),
    );
  }
}