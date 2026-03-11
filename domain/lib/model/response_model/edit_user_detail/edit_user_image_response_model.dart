import 'package:core/base_model.dart';

class EditUserImageResponseModel extends BaseModel<EditUserImageResponseModel> {
  String? status;
  String? image;

  EditUserImageResponseModel({
    this.status,
    this.image,
  });

  @override
  EditUserImageResponseModel fromJson(Map<String, dynamic> json) {
    return EditUserImageResponseModel(
      status: json['status'] as String?,
      image: json['data']?['image'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'image': image,
      },
    };
  }
}
