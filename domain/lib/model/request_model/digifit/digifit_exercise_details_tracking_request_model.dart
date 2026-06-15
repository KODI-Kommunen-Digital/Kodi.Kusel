import 'package:core/base_model.dart';

class DigifitExerciseDetailsTrackingRequestModel
    extends BaseModel<DigifitExerciseDetailsTrackingRequestModel> {
  final int equipmentId;
  final int locationId;
  final int setNumber;
  final int reps;
  final String activityStatus;

  DigifitExerciseDetailsTrackingRequestModel(
      {this.equipmentId = 0,
      this.locationId = 0,
      this.setNumber = 0,
      this.reps = 0,
      this.activityStatus = ''});

  @override
  Map<String, dynamic> toJson() {
    return {
      'equipmentId': equipmentId,
      'locationId': locationId,
      'setNumber': setNumber,
      'reps': reps,
      'activityStatus': activityStatus
    };
  }

  @override
  DigifitExerciseDetailsTrackingRequestModel fromJson(
      Map<String, dynamic> json) {
    return DigifitExerciseDetailsTrackingRequestModel(
      equipmentId: json['equipmentId'] ?? 0,
      locationId: json['locationId'] ?? 0,
      setNumber: json['setNumber'] ?? 0,
      reps: json['reps'] ?? 0,
      activityStatus: json['activityStatus'] ?? '',
    );
  }
}
