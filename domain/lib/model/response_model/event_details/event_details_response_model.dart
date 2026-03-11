import 'package:core/base_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class GetEventDetailsResponseModel
    extends BaseModel<GetEventDetailsResponseModel> {
  final String? status;
  final Listing? data;

  GetEventDetailsResponseModel({this.status, this.data});

  @override
  GetEventDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GetEventDetailsResponseModel(
      status: json['status'],
      data: json['data'] != null ? Listing.fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}
