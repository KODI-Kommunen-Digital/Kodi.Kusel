import 'package:core/base_model.dart';

class BrainTeaserGameListResponseModel
    extends BaseModel<BrainTeaserGameListResponseModel> {
  BrainTeaserGameListDataModel? data;
  String? status;

  BrainTeaserGameListResponseModel({this.data, this.status});

  @override
  BrainTeaserGameListResponseModel fromJson(Map<String, dynamic> json) {
    return BrainTeaserGameListResponseModel(
      status: json['status'],
      data: json['data'] != null
          ? BrainTeaserGameListDataModel().fromJson(json['data'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}

class BrainTeaserGameListDataModel
    extends BaseModel<BrainTeaserGameListDataModel> {
  int? sourceId;
  List<BrainTeaserGameListGamesModel>? games;

  BrainTeaserGameListDataModel({this.sourceId, this.games});

  @override
  BrainTeaserGameListDataModel fromJson(Map<String, dynamic> json) {
    List<BrainTeaserGameListGamesModel> gamesList = [];
    if (json['games'] != null) {
      for (var item in json['games']) {
        gamesList.add(BrainTeaserGameListGamesModel().fromJson(item));
      }
    }

    return BrainTeaserGameListDataModel(
      sourceId: json['sourceId'],
      games: gamesList,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'games': games?.map((e) => e.toJson()).toList(),
      };
}

class BrainTeaserGameListGamesModel
    extends BaseModel<BrainTeaserGameListGamesModel> {
  int? id;
  String? name;
  String? subDescription;
  String? gameImageUrl;

  BrainTeaserGameListGamesModel({
    this.id,
    this.name,
    this.subDescription,
    this.gameImageUrl,
  });

  @override
  BrainTeaserGameListGamesModel fromJson(Map<String, dynamic> json) {
    return BrainTeaserGameListGamesModel(
      id: json['id'],
      name: json['name'],
      subDescription: json['subDescription'],
      gameImageUrl: json['gameImageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subDescription': subDescription,
        'gameImageUrl': gameImageUrl,
      };
}
