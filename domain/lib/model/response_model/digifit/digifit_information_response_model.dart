import 'package:core/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'digifit_information_response_model.g.dart';

@HiveType(typeId: 2)
class DigifitInformationResponseModel
    extends BaseModel<DigifitInformationResponseModel> {
  @HiveField(0)
  final DigifitInformationDataModel? data;
  @HiveField(1)
  final String? status;

  DigifitInformationResponseModel({
    this.data,
    this.status,
  });

  @override
  DigifitInformationResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationResponseModel(
      data: json['data'] != null
          ? DigifitInformationDataModel().fromJson(json['data'])
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

@HiveType(typeId: 3)
class DigifitInformationDataModel {
  @HiveField(0)
  final int? sourceId;
  @HiveField(1)
  final DigifitInformationUserStatsModel? userStats;
  @HiveField(2)
  List<DigifitInformationParcoursModel>? parcours;
  @HiveField(3)
  final DigifitInformationActionsModel? actions;

  DigifitInformationDataModel({
    this.sourceId,
    this.userStats,
    this.parcours,
    this.actions,
  });

  DigifitInformationDataModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationDataModel(
      sourceId: json['sourceId'],
      userStats: json['userStats'] != null
          ? DigifitInformationUserStatsModel().fromJson(json['userStats'])
          : null,
      parcours: json['parcours'] != null
          ? List<DigifitInformationParcoursModel>.from(json['parcours']
              .map((e) => DigifitInformationParcoursModel().fromJson(e)))
          : null,
      actions: json['actions'] != null
          ? DigifitInformationActionsModel().fromJson(json['actions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'userStats': userStats?.toJson(),
      'parcours': parcours?.map((e) => e.toJson()).toList(),
      'actions': actions?.toJson(),
    };
  }
}

@HiveType(typeId: 4)
class DigifitInformationUserStatsModel {
  @HiveField(0)
  final int? points;
  @HiveField(1)
  final int? trophies;

  DigifitInformationUserStatsModel({
    this.points,
    this.trophies,
  });

  DigifitInformationUserStatsModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationUserStatsModel(
      points: json['points'],
      trophies: json['trophies'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'trophies': trophies,
    };
  }
}

@HiveType(typeId: 5)
class DigifitInformationParcoursModel {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final int? locationId;
  @HiveField(2)
  final String? mapImageUrl;
  @HiveField(3)
  final String? showParcoursUrl;
  @HiveField(4)
  final int? points;
  @HiveField(5)
  final int? trophies;
  @HiveField(6)
  List<DigifitInformationStationModel>? stations;

  DigifitInformationParcoursModel({
    this.name,
    this.locationId,
    this.mapImageUrl,
    this.showParcoursUrl,
    this.points,
    this.trophies,
    this.stations,
  });

  DigifitInformationParcoursModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationParcoursModel(
      name: json['name'],
      locationId: json['locationId'],
      mapImageUrl: json['mapImageUrl'],
      showParcoursUrl: json['showParcoursUrl'],
      points: json['points'],
      trophies: json['trophies'],
      stations: json['stations'] != null
          ? List<DigifitInformationStationModel>.from(json['stations']
              .map((e) => DigifitInformationStationModel().fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locationId': locationId,
      'mapImageUrl': mapImageUrl,
      'showParcoursUrl': showParcoursUrl,
      'points': points,
      'trophies': trophies,
      'stations': stations?.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 6)
class DigifitInformationStationModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? muscleGroups;
  @HiveField(3)
  final String? qrCodeIdentifier;
  @HiveField(4)
  final String? machineImageUrl;
  @HiveField(5)
  bool? isFavorite;
  @HiveField(6)
  final bool? isCompleted;
  @HiveField(7)
  final int? recommendedReps;
  @HiveField(8)
  final int? recommendedSets;
  @HiveField(9)
  final String? description;
  @HiveField(10)
  final int? minReps;
  @HiveField(11)
  final int? minSets;
  @HiveField(12)
  final String? sets;
  @HiveField(13)
  final String? repetitions;

  DigifitInformationStationModel({
    this.id,
    this.name,
    this.muscleGroups,
    this.qrCodeIdentifier,
    this.machineImageUrl,
    this.isFavorite,
    this.isCompleted,
    this.recommendedReps,
    this.recommendedSets,
    this.description,
    this.minReps,
    this.minSets,
    this.sets,
    this.repetitions,
  });

  DigifitInformationStationModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationStationModel(
      id: json['id'],
      name: json['name'],
      muscleGroups: json['muscleGroups'],
      qrCodeIdentifier: json['qrCodeIdentifier'],
      machineImageUrl: json['machineImageUrl'],
      isFavorite: json['isFavorite'],
      isCompleted: json['isCompleted'],
      recommendedReps: json['recommendedReps'],
      recommendedSets: json['recommendedSets'],
      description: json['description'],
      minReps: json['minReps'],
      minSets: json['minSets'],
      sets: json['sets'],
      repetitions: json['repetitions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroups': muscleGroups,
      'qrCodeIdentifier': qrCodeIdentifier,
      'machineImageUrl': machineImageUrl,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
      'recommendedReps': recommendedReps,
      'recommendedSets': recommendedSets,
      'description': description,
      'minReps': minReps,
      'minSets': minSets,
      'sets': sets,
      'repetitions': repetitions,
    };
  }
}

@HiveType(typeId: 7)
class DigifitInformationActionsModel {
  @HiveField(0)
  final String? trophiesUrl;
  @HiveField(1)
  final String? puzzleUrl;

  DigifitInformationActionsModel({
    this.trophiesUrl,
    this.puzzleUrl,
  });

  DigifitInformationActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitInformationActionsModel(
      trophiesUrl: json['trophiesUrl'],
      puzzleUrl: json['puzzleUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trophiesUrl': trophiesUrl,
      'puzzleUrl': puzzleUrl,
    };
  }
}
