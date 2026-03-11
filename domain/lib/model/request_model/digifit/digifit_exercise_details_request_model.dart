import 'package:core/base_model.dart';

class DigifitExerciseDetailsRequestModel
    extends BaseModel<DigifitExerciseDetailsRequestModel> {
  final int? locationId;
  final int? equipmentId;
  final String translate;
  String? equipmentSlug;

  DigifitExerciseDetailsRequestModel({
    required this.locationId,
    required this.equipmentId,
    required this.translate,
     this.equipmentSlug
  });

  @override
  DigifitExerciseDetailsRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsRequestModel(
      locationId: json['locationId'] ?? 0,
      equipmentId: json['id'] ?? 0,
      translate: json['translate'] ?? '',
      equipmentSlug:json['equipmentSlug'] ?? ''
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'id': equipmentId,
      'translate': translate,
      'equipmentSlug':equipmentSlug
    };
  }
}
