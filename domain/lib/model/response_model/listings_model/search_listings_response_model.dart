import 'package:core/base_model.dart';

import 'get_all_listings_response_model.dart';

class SearchListingsResponseModel extends BaseModel<SearchListingsResponseModel> {
  String? status;
  List<Listing>? data;

  SearchListingsResponseModel({this.status, this.data});

  @override
  SearchListingsResponseModel fromJson(Map<String, dynamic> json) {
    return SearchListingsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((item) => Listing.fromJson(item)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}
