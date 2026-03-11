import 'package:core/base_model.dart';

class GameDetailsRequestModel extends BaseModel<GameDetailsRequestModel> {
  final int? id;
  final String translate;

  GameDetailsRequestModel({this.id, required this.translate});

  @override
  GameDetailsRequestModel fromJson(Map<String, dynamic> json) => this;

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'translate': translate};
  }
}
