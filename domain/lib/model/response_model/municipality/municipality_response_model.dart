import 'package:core/base_model.dart';

import '../explore_details/explore_details_response_model.dart';

class MunicipalityResponseModel extends BaseModel<MunicipalityResponseModel> {
  final String? status;
  final List<City>? data;

  MunicipalityResponseModel({
    this.status,
    this.data,
  });

  @override
  MunicipalityResponseModel fromJson(Map<String, dynamic> json) {
    return MunicipalityResponseModel(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}