import 'package:core/base_model.dart';

import '../explore_details/explore_details_response_model.dart';

class MeinOrtResponseModel extends BaseModel<MeinOrtResponseModel> {
  final String? status;
  final List<Municipality>? data;

  MeinOrtResponseModel({
    this.status,
    this.data,
  });

  @override
  MeinOrtResponseModel fromJson(Map<String, dynamic> json) {
    return MeinOrtResponseModel(
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((e) => Municipality.fromJson(e))
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
