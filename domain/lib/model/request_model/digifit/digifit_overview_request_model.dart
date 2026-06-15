import 'package:core/base_model.dart';

class DigifitOverviewRequestModel
    extends BaseModel<DigifitOverviewRequestModel> {
  final int locationId;
  final String translate;

  DigifitOverviewRequestModel({
    required this.locationId,
    required this.translate,
  });

  @override
  DigifitOverviewRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitOverviewRequestModel(
      locationId: json['locationId'] ?? 0,
      translate: json['translate'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'translate': translate,
    };
  }
}
