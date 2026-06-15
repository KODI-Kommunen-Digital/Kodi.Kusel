import 'package:core/base_model.dart';

class DeleteFavouriteCityResponseModel
    implements BaseModel<DeleteFavouriteCityResponseModel> {
  final String? status;

  DeleteFavouriteCityResponseModel({this.status});

  @override
  DeleteFavouriteCityResponseModel fromJson(Map<String, dynamic> json) {
    return DeleteFavouriteCityResponseModel(
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
