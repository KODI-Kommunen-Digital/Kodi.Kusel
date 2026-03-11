import 'package:core/base_model.dart';

class OnboardingUserDemographicsResponseModel
    implements BaseModel<OnboardingUserDemographicsResponseModel> {
  String? status;
  String? message;

  OnboardingUserDemographicsResponseModel({this.status, this.message});

  @override
  OnboardingUserDemographicsResponseModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserDemographicsResponseModel(
        status: json['status'] as String?, message: json['message'] as String?);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"status": status, "message": message};
  }
}
