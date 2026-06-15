import 'package:core/base_model.dart';

class GamesTrackerRequestModel extends BaseModel<GamesTrackerRequestModel> {
  final int? sessionId;
  final String? activityStatus;

  GamesTrackerRequestModel({this.sessionId, this.activityStatus});

  @override
  GamesTrackerRequestModel fromJson(Map<String, dynamic> json) {
    return GamesTrackerRequestModel(
      sessionId: json['sessionId'],
      activityStatus: json['activityStatus'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'activityStatus': activityStatus,
    };
  }
}
