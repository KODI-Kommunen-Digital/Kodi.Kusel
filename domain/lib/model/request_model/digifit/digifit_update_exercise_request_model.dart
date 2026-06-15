import 'package:core/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'digifit_update_exercise_request_model.g.dart';

@HiveType(typeId: 8)
class DigifitUpdateExerciseRequestModel
    extends BaseModel<DigifitUpdateExerciseRequestModel> {
  @HiveField(0)
  final List<Map<String, List<DigifitExerciseRecordModel>>> data;

  DigifitUpdateExerciseRequestModel({
    List<Map<String, List<DigifitExerciseRecordModel>>>? data,
  }) : data = data ?? [];

  @override
  DigifitUpdateExerciseRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitUpdateExerciseRequestModel(
      data: (json['data'] as List?)
          ?.map((map) => (map as Map).map((key, value) => MapEntry(
        key.toString(),
        (value as List)
            .map((e) => DigifitExerciseRecordModel().fromJson(e))
            .toList(),
      )))
          .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data
          .map((map) => map.map(
            (key, value) => MapEntry(
          key,
          value.map((e) => e.toJson()).toList(),
        ),
      ))
          .toList(),
    };
  }
}


@HiveType(typeId: 9)
class DigifitExerciseRecordModel
    extends BaseModel<DigifitExerciseRecordModel> {
  @HiveField(0)
  final int setComplete;
  @HiveField(1)
  final int locationId;
  @HiveField(2)
  final String createdAt;
  @HiveField(3)
  final String updatedAt;
  @HiveField(4)
  final List<String> setTimeList;

  DigifitExerciseRecordModel({
    this.setComplete = 0,
    this.locationId = 0,
    this.createdAt = '',
    this.updatedAt = '',
    List<String>? setTimeList,
  }) : setTimeList = setTimeList ?? [];

  @override
  DigifitExerciseRecordModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseRecordModel(
      setComplete: json['setComplete'] ?? 0,
      locationId: json['locationId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      setTimeList: (json['setTimeList'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'setComplete': setComplete,
      'locationId': locationId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'setTimeList': setTimeList,
    };
  }
}