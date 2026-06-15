import 'package:core/base_model.dart';

class OnboardingDetailsResponseModel
    extends BaseModel<OnboardingDetailsResponseModel> {
  String? status;
  OnboardingData? data;

  OnboardingDetailsResponseModel({this.status, this.data});

  @override
  OnboardingDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return OnboardingDetailsResponseModel(
      status: json['status'] as String?,
      data: json['data'] != null
          ? OnboardingData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class OnboardingData {
  String? userType;
  int? cityId;
  String? maritalStatus;
  List<String>? accommodationPreference;
  List<int>? interests;
  int? onBoarded;

  OnboardingData({
    this.userType,
    this.cityId,
    this.maritalStatus,
    this.accommodationPreference,
    this.interests,
    this.onBoarded,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      userType: json['userType'] as String?,
      cityId: json['cityId'] as int?,
      maritalStatus: json['maritalStatus'] as String?,
      accommodationPreference: json['accommodationPreference'] != null
          ? List<String>.from(json['accommodationPreference'] as List)
          : null,
      interests: json['interests'] != null
          ? List<int>.from(json['interests'] as List)
          : null,
      onBoarded: json['onBoarded'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'cityId': cityId,
      'maritalStatus': maritalStatus,
      'accommodationPreference': accommodationPreference,
      'interests': interests,
      'onBoarded': onBoarded,
    };
  }
}