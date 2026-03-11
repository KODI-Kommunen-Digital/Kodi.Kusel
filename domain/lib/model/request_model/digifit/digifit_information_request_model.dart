import 'package:core/base_model.dart';

class DigifitInformationRequestModel
    implements BaseModel<DigifitInformationRequestModel> {
  final String translate;

  DigifitInformationRequestModel({required this.translate});

  @override
  Map<String, dynamic> toJson() => {'translate': translate};

  @override
  DigifitInformationRequestModel fromJson(Map<String, dynamic> json) => this;
}
