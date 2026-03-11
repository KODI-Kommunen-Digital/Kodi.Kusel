import 'package:core/base_model.dart';

class AddFavoritesResponseModel extends BaseModel<AddFavoritesResponseModel> {
  String? status;
  List<AddedFavorite>? id;

  AddFavoritesResponseModel({this.status, this.id});

  @override
  AddFavoritesResponseModel fromJson(Map<String, dynamic> json) {
    return AddFavoritesResponseModel(
      status: json['status'] as String?,
      id: (json['id'] as List<dynamic>?)
          ?.map((item) => AddedFavorite.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': id?.map((item) => item.toJson()).toList(),
    };
  }
}

class AddedFavorite {
  int? id;
  String? status;
  String? message;

  AddedFavorite({
    this.id,
    this.status,
    this.message,
  });

  factory AddedFavorite.fromJson(Map<String, dynamic> json) {
    return AddedFavorite(
        id: json['id'],
        status: json['status'],
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'message': message,
    };
  }
}
