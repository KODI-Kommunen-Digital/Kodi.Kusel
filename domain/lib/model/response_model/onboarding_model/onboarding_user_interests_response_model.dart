import 'package:core/base_model.dart';

class OnboardingUserInterestsResponseModel
    implements BaseModel<OnboardingUserInterestsResponseModel> {
  String? status;
  String? message;

  OnboardingUserInterestsResponseModel({this.status, this.message});

  @override
  OnboardingUserInterestsResponseModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserInterestsResponseModel(
        status: json['status'] as String?, message: json['message'] as String?);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"status": status, "message": message};
  }
}
