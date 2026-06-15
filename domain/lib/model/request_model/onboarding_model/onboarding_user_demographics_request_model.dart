import 'package:core/base_model.dart';

class OnboardingUserDemographicsRequestModel
    extends BaseModel<OnboardingUserDemographicsRequestModel> {
  final String? maritalStatus;
  final List<String>? accommodationPreference;
  final int? cityId;

  OnboardingUserDemographicsRequestModel({
    this.maritalStatus,
    this.accommodationPreference,
    this.cityId,
  });

  @override
  OnboardingUserDemographicsRequestModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserDemographicsRequestModel(
      maritalStatus: json['maritalStatus'],
      accommodationPreference: json['accommodationPreference'] != null
          ? List<String>.from(json['accommodationPreference'])
          : null,
      cityId: json['cityId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "maritalStatus": maritalStatus,
      "accommodationPreference": accommodationPreference,
      "cityId": cityId,
    };
  }
}
