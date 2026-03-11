import 'package:core/base_model.dart';

class OnboardingUserInterestsRequestModel
    extends BaseModel<OnboardingUserInterestsRequestModel> {
  final List<int>? interestIds;

  OnboardingUserInterestsRequestModel({this.interestIds});

  @override
  OnboardingUserInterestsRequestModel fromJson(Map<String, dynamic> json) {
    return OnboardingUserInterestsRequestModel(
      interestIds: (json['interestIds'] as List?)?.map((e) => e as int).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "interestIds": interestIds,
    };
  }
}
