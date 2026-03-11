import 'package:core/base_model.dart';

class DigifitUserTrophiesRequestModel
    implements BaseModel<DigifitUserTrophiesRequestModel> {
  final String translate;

  DigifitUserTrophiesRequestModel({required this.translate});

  @override
  Map<String, dynamic> toJson() => {'translate': translate};

  @override
  DigifitUserTrophiesRequestModel fromJson(Map<String, dynamic> json) => this;
}