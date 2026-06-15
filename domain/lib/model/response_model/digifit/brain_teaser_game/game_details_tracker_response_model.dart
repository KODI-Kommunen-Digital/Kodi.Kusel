import 'package:core/base_model.dart';

class GamesTrackerResponseModel extends BaseModel<GamesTrackerResponseModel> {
  final GamesTrackerDataModel? data;
  final String? status;

  GamesTrackerResponseModel({this.data, this.status});

  @override
  GamesTrackerResponseModel fromJson(Map<String, dynamic> json) {
    return GamesTrackerResponseModel(
      data: json['data'] != null
          ? GamesTrackerDataModel().fromJson(json['data'])
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

class GamesTrackerDataModel extends BaseModel<GamesTrackerDataModel> {
  final int? id;
  final int? userId;
  final int? gameId;
  final int? levelId;
  final int? stampId;
  final String? startedAt;
  final String? endedAt;
  final bool? isCompleted;
  final int? isAborted;
  final String? createdAt;
  final String? updatedAt;

  GamesTrackerDataModel({
    this.id,
    this.userId,
    this.gameId,
    this.levelId,
    this.stampId,
    this.startedAt,
    this.endedAt,
    this.isCompleted,
    this.isAborted,
    this.createdAt,
    this.updatedAt,
  });

  @override
  GamesTrackerDataModel fromJson(Map<String, dynamic> json) {
    return GamesTrackerDataModel(
      id: json['id'],
      userId: json['userId'],
      gameId: json['gameId'],
      levelId: json['levelId'],
      stampId: json['stampId'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      isCompleted: json['isCompleted'],
      isAborted: json['isAborted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'gameId': gameId,
      'levelId': levelId,
      'stampId': stampId,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'isCompleted': isCompleted,
      'isAborted': isAborted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
