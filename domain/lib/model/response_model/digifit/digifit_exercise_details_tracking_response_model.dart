import 'package:core/base_model.dart';

class DigifitExerciseDetailsTrackingResponseModel
    extends BaseModel<DigifitExerciseDetailsTrackingResponseModel> {
  final String status;
  final DigifitExerciseDetailsTrackingDataModel data;

  DigifitExerciseDetailsTrackingResponseModel({
    this.status = '',
    DigifitExerciseDetailsTrackingDataModel? data,
  }) : data = data ?? DigifitExerciseDetailsTrackingDataModel();

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }

  @override
  DigifitExerciseDetailsTrackingResponseModel fromJson(
      Map<String, dynamic> json) {
    return DigifitExerciseDetailsTrackingResponseModel(
      status: json['status'] ?? '',
      data: DigifitExerciseDetailsTrackingDataModel()
          .fromJson(json['data'] ?? {}),
    );
  }
}

class DigifitExerciseDetailsTrackingDataModel
    extends BaseModel<DigifitExerciseDetailsTrackingDataModel> {
  final int sessionId;
  final bool isCompleted;
  final int completedSets;
  final int setNumber;
  final int reps;
  final String message;

  DigifitExerciseDetailsTrackingDataModel({
    this.sessionId = 0,
    this.isCompleted = false,
    this.completedSets = 0,
    this.setNumber = 0,
    this.reps = 0,
    this.message = '',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'isCompleted': isCompleted,
      'completedSets': completedSets,
      'setNumber': setNumber,
      'reps': reps,
      'message': message,
    };
  }

  @override
  DigifitExerciseDetailsTrackingDataModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsTrackingDataModel(
      sessionId: json['sessionId'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      completedSets: json['completedSets'] ?? 0,
      setNumber: json['setNumber'] ?? 0,
      reps: json['reps'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
