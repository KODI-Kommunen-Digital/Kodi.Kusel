import 'package:core/base_model.dart';

class FlipCatchResponseModel extends BaseModel<FlipCatchResponseModel> {
  final FlipCatchData? data;
  final String? status;

  FlipCatchResponseModel({
    this.data,
    this.status,
  });

  @override
  FlipCatchResponseModel fromJson(Map<String, dynamic> json) {
    return FlipCatchResponseModel(
      data: FlipCatchData.fromJson(json['data'] ?? {}),
      status: json['status'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }
}

class FlipCatchData {
  final String? subDescription;
  final List<String> targetWords;
  final List<String> originalText;
  final int timer;
  final int sessionId;
  final int activityId;

  FlipCatchData({
    required this.targetWords,
    required this.originalText,
    required this.timer,
    required this.sessionId,
    required this.activityId,
    this.subDescription,
  });

  factory FlipCatchData.fromJson(Map<String, dynamic> json) {
    return FlipCatchData(
      targetWords: (json['targetWords'] is List)
          ? List<String>.from(json['targetWords'])
          : const [],
      originalText: (json['originalText'] is List)
          ? List<String>.from(json['originalText'])
          : const [],
      timer: json['timer'] ?? 0,
      sessionId: json['sessionId'] ?? 0,
      activityId: json['activityId'] ?? 0,
      subDescription: json['subDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetWords': targetWords,
      'originalText': originalText,
      'timer': timer,
      'sessionId': sessionId,
      'activityId': activityId,
      'subDescription': subDescription,
    };
  }
}
