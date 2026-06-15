import 'package:core/base_model.dart';

class OnboardingCompleteResponseModel
    extends BaseModel<OnboardingCompleteResponseModel> {
  final bool? success;
  final String? message;

  OnboardingCompleteResponseModel({this.success, this.message});

  @override
  OnboardingCompleteResponseModel fromJson(Map<String, dynamic> json) {
    return OnboardingCompleteResponseModel(
      success: json['success'],
      message: json['message'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
