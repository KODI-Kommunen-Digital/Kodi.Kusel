import 'package:core/base_model.dart';

class GameDetailsResponseModel extends BaseModel<GameDetailsResponseModel> {
  final GameDetailsDataModel? data;
  final String? status;

  GameDetailsResponseModel({this.data, this.status});

  @override
  GameDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return GameDetailsResponseModel(
      data: json['data'] != null
          ? GameDetailsDataModel().fromJson(json['data'])
          : null,
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }
}

class GameDetailsDataModel extends BaseModel<GameDetailsDataModel> {
  final int? sourceId;
  final GameDetailsGameModel? game;
  final List<GameDetailsStampModel>? stamps;
  final List<GameDetailsLevelModel>? levels;
  final List<GameDetailsMoreGameModel>? moreGames;

  GameDetailsDataModel({
    this.sourceId,
    this.game,
    this.stamps,
    this.levels,
    this.moreGames,
  });

  @override
  GameDetailsDataModel fromJson(Map<String, dynamic> json) {
    return GameDetailsDataModel(
      sourceId: json['sourceId'],
      game: json['game'] != null
          ? GameDetailsGameModel().fromJson(json['game'])
          : null,
      stamps: json['stamps'] != null
          ? List.from(json['stamps'])
              .map((e) => GameDetailsStampModel().fromJson(e))
              .toList()
          : null,
      levels: json['levels'] != null
          ? List.from(json['levels'])
              .map((e) => GameDetailsLevelModel().fromJson(e))
              .toList()
          : null,
      moreGames: json['moreGames'] != null
          ? List.from(json['moreGames'])
              .map((e) => GameDetailsMoreGameModel().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'game': game?.toJson(),
      'stamps': stamps?.map((e) => e.toJson()).toList(),
      'levels': levels?.map((e) => e.toJson()).toList(),
      'moreGames': moreGames?.map((e) => e.toJson()).toList(),
    };
  }
}

class GameDetailsGameModel extends BaseModel<GameDetailsGameModel> {
  final int? id;
  final String? name;
  final String? subDescription;
  final String? description;

  GameDetailsGameModel(
      {this.id, this.name, this.subDescription, this.description});

  @override
  GameDetailsGameModel fromJson(Map<String, dynamic> json) {
    return GameDetailsGameModel(
      id: json['id'],
      name: json['name'],
      subDescription: json['subDescription'],
      description: json['description'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subDescription': subDescription,
      'description': description,
    };
  }
}

class GameDetailsStampModel extends BaseModel<GameDetailsStampModel> {
  final int? id;
  final String? stampImageUrl;
  final bool? isCompleted;

  GameDetailsStampModel({this.id, this.stampImageUrl, this.isCompleted});

  @override
  GameDetailsStampModel fromJson(Map<String, dynamic> json) {
    return GameDetailsStampModel(
      id: json['id'],
      stampImageUrl: json['stampImageUrl'],
      isCompleted: json['isCompleted'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stampImageUrl': stampImageUrl,
      'isCompleted': isCompleted,
    };
  }
}

class GameDetailsLevelModel extends BaseModel<GameDetailsLevelModel> {
  final int? id;
  final String? name;
  final int? timer;
  final String? levelImageUrl;
  final bool? isCompleted;
  final bool? isUnlocked;

  GameDetailsLevelModel({
    this.id,
    this.name,
    this.timer,
    this.levelImageUrl,
    this.isCompleted,
    this.isUnlocked,
  });

  @override
  GameDetailsLevelModel fromJson(Map<String, dynamic> json) {
    return GameDetailsLevelModel(
      id: json['id'],
      name: json['name'],
      timer: json['timer'],
      levelImageUrl: json['levelImageUrl'],
      isCompleted: json['isCompleted'],
      isUnlocked: json['isUnlocked'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timer': timer,
      'levelImageUrl': levelImageUrl,
      'isCompleted': isCompleted,
      'isUnlocked': isUnlocked,
    };
  }
}

class GameDetailsMoreGameModel extends BaseModel<GameDetailsMoreGameModel> {
  final int? id;
  final String? name;
  final String? subDescription;
  final String? gameImageUrl;

  GameDetailsMoreGameModel(
      {this.id, this.name, this.subDescription, this.gameImageUrl});

  @override
  GameDetailsMoreGameModel fromJson(Map<String, dynamic> json) {
    return GameDetailsMoreGameModel(
      id: json['id'],
      name: json['name'],
      subDescription: json['subDescription'],
      gameImageUrl: json['gameImageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subDescription': subDescription,
      'gameImageUrl': gameImageUrl,
    };
  }
}
