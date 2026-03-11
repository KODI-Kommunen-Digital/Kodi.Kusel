import 'package:core/base_model.dart';

class GetFavoritesResponseModel extends BaseModel<GetFavoritesResponseModel> {
  String? status;
  List<FavoritesItem>? data;

  GetFavoritesResponseModel({this.status, this.data});

  @override
  GetFavoritesResponseModel fromJson(Map<String, dynamic> json) {
    return GetFavoritesResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => FavoritesItem.fromJson(item))
          .toList(),
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

class FavoritesItem {
  int? id;
  int? cityId;
  int? listingId;
  int? userId;

  FavoritesItem({
    this.id,
    this.userId,
    this.listingId,
    this.cityId,
  });

  factory FavoritesItem.fromJson(Map<String, dynamic> json) {
    return FavoritesItem(
        id: json['id'],
        userId: json['userId'],
        cityId: json['cityId'],
        listingId: json['listingId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cityId': cityId,
      'listingId': listingId
    };
  }
}
