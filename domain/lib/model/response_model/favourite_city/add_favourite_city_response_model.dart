import 'package:core/base_model.dart';

class AddFavouriteCityResponseModel
    implements BaseModel<AddFavouriteCityResponseModel> {
  final String? status;
  final FavouriteCityIdModel? id;

  AddFavouriteCityResponseModel({this.status, this.id});

  @override
  AddFavouriteCityResponseModel fromJson(Map<String, dynamic> json) {
    return AddFavouriteCityResponseModel(
      status: json['status'],
      id: json['id'] != null
          ? FavouriteCityIdModel().fromJson(json['id'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id?.toJson(),
    };
  }
}

class FavouriteCityIdModel implements BaseModel<FavouriteCityIdModel> {
  final String? status;
  final String? message;
  final int? id;

  FavouriteCityIdModel({this.status, this.message, this.id});

  @override
  FavouriteCityIdModel fromJson(Map<String, dynamic> json) {
    return FavouriteCityIdModel(
      status: json['status'],
      message: json['message'],
      id: json['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'id': id,
    };
  }
}
