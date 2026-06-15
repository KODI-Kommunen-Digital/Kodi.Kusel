import 'package:core/base_model.dart';

class VirtualTownHallRequestModel
    implements BaseModel<VirtualTownHallRequestModel> {
  final String translate;

  VirtualTownHallRequestModel({required this.translate});

  @override
  Map<String, dynamic> toJson() => {'translate': translate};

  @override
  VirtualTownHallRequestModel fromJson(Map<String, dynamic> json) => this;
}