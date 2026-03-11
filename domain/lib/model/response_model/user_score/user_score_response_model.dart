import 'package:core/base_model.dart';

class UserScoreResponseModel implements BaseModel<UserScoreResponseModel> {
  bool? success;
  UserScoreData? data;

  UserScoreResponseModel({
    this.success,
    this.data,
  });

  @override
  UserScoreResponseModel fromJson(Map<String, dynamic> json) {
    return UserScoreResponseModel(
      success: json['success'],
      data: json['data'] != null ? UserScoreData().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class UserScoreData {
  int? totalPoints;
  int? stamp;

  UserScoreData({
    this.totalPoints,
    this.stamp,
  });

  UserScoreData fromJson(Map<String, dynamic> json) {
    return UserScoreData(
      totalPoints: json['totalPoints'],
      stamp: json['stamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'stamp': stamp,
    };
  }
}
