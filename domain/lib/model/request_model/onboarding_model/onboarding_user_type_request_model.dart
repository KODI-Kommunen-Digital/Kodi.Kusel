import 'package:core/base_model.dart';

class OnboardingUserTypeRequestModel
    extends BaseModel<OnboardingUserTypeRequestModel> {
  final String? userType;

  OnboardingUserTypeRequestModel({this.userType});

  @override
  OnboardingUserTypeRequestModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserTypeRequestModel(
      userType: json['userType'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {"userType": userType};
  }
}
