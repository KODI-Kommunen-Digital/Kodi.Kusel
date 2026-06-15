import 'package:core/base_model.dart';

class OnboardingUserTypeResponseModel
    implements BaseModel<OnboardingUserTypeResponseModel> {
  String? status;
  String? message;

  OnboardingUserTypeResponseModel({this.status, this.message});

  @override
  OnboardingUserTypeResponseModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserTypeResponseModel(
        status: json['status'] as String?, message: json['message'] as String?);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"status": status, "message": message};
  }
}
