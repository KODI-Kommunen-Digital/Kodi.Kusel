import 'package:core/base_model.dart';

class OnboardingCompleteRequestModel
    extends BaseModel<OnboardingCompleteRequestModel> {
  int? id;

  OnboardingCompleteRequestModel({this.id});

  @override
  OnboardingCompleteRequestModel fromJson(Map<String, dynamic> json) {
    return OnboardingCompleteRequestModel(id: json['id'] as int?);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"id": id};
  }
}
