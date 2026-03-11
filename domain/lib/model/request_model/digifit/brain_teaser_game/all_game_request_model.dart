import 'package:core/base_model.dart';

class AllGamesRequestModel extends BaseModel<AllGamesRequestModel> {
  final int gameId;
  final int levelId;
  final String translate;

  AllGamesRequestModel(
      {required this.gameId, required this.levelId, required this.translate});

  @override
  AllGamesRequestModel fromJson(Map<String, dynamic> json) => this;

  @override
  Map<String, dynamic> toJson() =>
      {'gameId': gameId, 'levelId': levelId, 'translate': translate};
}
