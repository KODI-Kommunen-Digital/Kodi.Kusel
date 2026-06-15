import 'package:core/base_model.dart';

class DigifitUserTrophiesResponseModel
    extends BaseModel<DigifitUserTrophiesResponseModel> {
  final DigifitUserTrophyDataModel? data;
  final String? status;

  DigifitUserTrophiesResponseModel({this.data, this.status});

  @override
  DigifitUserTrophiesResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophiesResponseModel(
      data: json['data'] != null
          ? DigifitUserTrophyDataModel().fromJson(json['data'])
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

class DigifitUserTrophyDataModel extends BaseModel<DigifitUserTrophyDataModel> {
  final int? sourceId;
  final DigifitUserTrophyStatsModel? userStats;
  final List<DigifitUserTrophyItemModel>? latestTrophies;
  final DigifitUserAllTrophiesModel? allTrophies;
  final DigifitUserReceivedTrophiesModel? trophiesReceived;
  final DigifitUserTrophyActionsModel? actions;

  DigifitUserTrophyDataModel({
    this.sourceId,
    this.userStats,
    this.latestTrophies,
    this.allTrophies,
    this.trophiesReceived,
    this.actions,
  });

  @override
  DigifitUserTrophyDataModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyDataModel(
      sourceId: json['sourceId'],
      userStats: json['userStats'] != null
          ? DigifitUserTrophyStatsModel().fromJson(json['userStats'])
          : null,
      latestTrophies: json['latestTrophies'] != null
          ? List.from(json['latestTrophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
      allTrophies: json['allTrophies'] != null
          ? DigifitUserAllTrophiesModel().fromJson(json['allTrophies'])
          : null,
      trophiesReceived: json['trophiesReceived'] != null
          ? DigifitUserReceivedTrophiesModel()
              .fromJson(json['trophiesReceived'])
          : null,
      actions: json['actions'] != null
          ? DigifitUserTrophyActionsModel().fromJson(json['actions'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'userStats': userStats?.toJson(),
      'latestTrophies': latestTrophies?.map((e) => e.toJson()).toList(),
      'allTrophies': allTrophies?.toJson(),
      'trophiesReceived': trophiesReceived?.toJson(),
      'actions': actions?.toJson(),
    };
  }
}

class DigifitUserTrophyStatsModel
    extends BaseModel<DigifitUserTrophyStatsModel> {
  final int? points;
  final int? trophies;

  DigifitUserTrophyStatsModel({this.points, this.trophies});

  @override
  DigifitUserTrophyStatsModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyStatsModel(
      points: json['points'],
      trophies: json['trophies'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'trophies': trophies,
    };
  }
}

class DigifitUserTrophyItemModel extends BaseModel<DigifitUserTrophyItemModel> {
  final int? id;
  final String? name;
  final String? iconUrl;
  final bool? isCompleted;
  String? muscleGroups;

  DigifitUserTrophyItemModel({
    this.id,
    this.name,
    this.iconUrl,
    this.isCompleted,
    this.muscleGroups,
  });

  @override
  DigifitUserTrophyItemModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyItemModel(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconUrl'],
      isCompleted: json['isCompleted'],
      muscleGroups: json['muscleGroups'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'isCompleted': isCompleted,
      'muscleGroups': muscleGroups,
    };
  }
}

class DigifitUserAllTrophiesModel
    extends BaseModel<DigifitUserAllTrophiesModel> {
  final int? total;
  final int? locked;
  final List<DigifitUserTrophyItemModel>? trophies;

  DigifitUserAllTrophiesModel({this.total, this.locked, this.trophies});

  @override
  DigifitUserAllTrophiesModel fromJson(Map<String, dynamic> json) {
    return DigifitUserAllTrophiesModel(
      total: json['total'],
      locked: json['locked'],
      trophies: json['trophies'] != null
          ? List.from(json['trophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'locked': locked,
      'trophies': trophies?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitUserReceivedTrophiesModel
    extends BaseModel<DigifitUserReceivedTrophiesModel> {
  final int? unlocked;
  final int? total;
  final List<DigifitUserTrophyItemModel>? trophies;

  DigifitUserReceivedTrophiesModel({this.unlocked, this.total, this.trophies});

  @override
  DigifitUserReceivedTrophiesModel fromJson(Map<String, dynamic> json) {
    return DigifitUserReceivedTrophiesModel(
      unlocked: json['unlocked'],
      total: json['total'],
      trophies: json['trophies'] != null
          ? List.from(json['trophies'])
              .map((e) => DigifitUserTrophyItemModel().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'unlocked': unlocked,
      'total': total,
      'trophies': trophies?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitUserTrophyActionsModel
    extends BaseModel<DigifitUserTrophyActionsModel> {
  final String? scanWorkoutUrl;
  final String? loadMoreTrophiesUrl;

  DigifitUserTrophyActionsModel(
      {this.scanWorkoutUrl, this.loadMoreTrophiesUrl});

  @override
  DigifitUserTrophyActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitUserTrophyActionsModel(
      scanWorkoutUrl: json['scanWorkoutUrl'],
      loadMoreTrophiesUrl: json['loadMoreTrophiesUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'scanWorkoutUrl': scanWorkoutUrl,
      'loadMoreTrophiesUrl': loadMoreTrophiesUrl,
    };
  }
}
