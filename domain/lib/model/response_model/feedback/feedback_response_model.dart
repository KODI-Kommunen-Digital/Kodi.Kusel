import 'package:core/base_model.dart';

class FeedBackResponseModel implements BaseModel<FeedBackResponseModel> {
  final String? status;
  final String? message;

  FeedBackResponseModel({this.status, this.message});

  @override
  FeedBackResponseModel fromJson(Map<String, dynamic> json) {
    return FeedBackResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
