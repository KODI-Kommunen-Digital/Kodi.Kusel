import 'package:core/base_model.dart';

class DigifitExerciseDetailsResponseModel
    extends BaseModel<DigifitExerciseDetailsResponseModel> {
  final String status;
  final DigifitExerciseDetailsDataModel data;

  DigifitExerciseDetailsResponseModel({
    this.status = '',
    DigifitExerciseDetailsDataModel? data,
  }) : data = data ?? DigifitExerciseDetailsDataModel();

  @override
  DigifitExerciseDetailsResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsResponseModel(
      status: json['status'] ?? '',
      data: DigifitExerciseDetailsDataModel().fromJson(json['data'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DigifitExerciseDetailsDataModel
    extends BaseModel<DigifitExerciseDetailsDataModel> {
  final DigifitExerciseEquipmentModel equipment;
  final List<DigifitExerciseRelatedStationsModel> relatedStations;

  DigifitExerciseDetailsDataModel({
    DigifitExerciseEquipmentModel? equipment,
    List<DigifitExerciseRelatedStationsModel>? relatedStations,
  })  : equipment = equipment ?? DigifitExerciseEquipmentModel(),
        relatedStations = relatedStations ?? [];

  @override
  DigifitExerciseDetailsDataModel fromJson(Map<String, dynamic> json) {
    final rawList = json['relatedStations'];
    final List relatedStationsList = rawList is List ? rawList : [];

    return DigifitExerciseDetailsDataModel(
      equipment:
          DigifitExerciseEquipmentModel().fromJson(json['equipment'] ?? {}),
      relatedStations: relatedStationsList
          .map((item) => DigifitExerciseRelatedStationsModel().fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'equipment': equipment.toJson(),
        'relatedStations': relatedStations.map((e) => e.toJson()).toList(),
      };
}

class DigifitExerciseEquipmentModel
    extends BaseModel<DigifitExerciseEquipmentModel> {
  int id;
  String name;
  String machineVideoUrl;
  String description;
  String qrCodeIdentifier;
  int? sourceId;
  DigifitExerciseRecommendationModel recommendation;
  DigifitExerciseUserProgressModel userProgress;
  DigifitExerciseActionsModel actions;
  bool isFavorite;

  DigifitExerciseEquipmentModel({
    this.id = 0,
    this.name = '',
    this.machineVideoUrl = '',
    this.description = '',
    this.qrCodeIdentifier = '',
    this.sourceId = 0,
    this.isFavorite = false,
    DigifitExerciseRecommendationModel? recommendation,
    DigifitExerciseUserProgressModel? userProgress,
    DigifitExerciseActionsModel? actions,
  })  : recommendation = recommendation ?? DigifitExerciseRecommendationModel(),
        userProgress = userProgress ?? DigifitExerciseUserProgressModel(),
        actions = actions ?? DigifitExerciseActionsModel();

  @override
  DigifitExerciseEquipmentModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseEquipmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      machineVideoUrl: json['machineVideoUrl'] ?? '',
      description: json['description'] ?? '',
      qrCodeIdentifier: json['qrCodeIdentifier'] ?? '',
      sourceId: json['sourceId'] ?? 0,
      recommendation: DigifitExerciseRecommendationModel()
          .fromJson(json['recommendation'] ?? {}),
      userProgress: DigifitExerciseUserProgressModel()
          .fromJson(json['userProgress'] ?? {}),
      actions: DigifitExerciseActionsModel().fromJson(json['actions'] ?? {}),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'machineVideoUrl': machineVideoUrl,
        'description': description,
        'qrCodeIdentifier': qrCodeIdentifier,
        'sourceId': sourceId,
        'recommendation': recommendation.toJson(),
        'userProgress': userProgress.toJson(),
        'actions': actions.toJson(),
        'isFavorite': isFavorite,
      };
}


class DigifitExerciseRecommendationModel
    extends BaseModel<DigifitExerciseRecommendationModel> {
  String sets;
  String repetitions;

  DigifitExerciseRecommendationModel({
    this.sets = '',
    this.repetitions = '',
  });

  @override
  DigifitExerciseRecommendationModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseRecommendationModel(
      sets: json['sets'] ?? '',
      repetitions: json['repetitions'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'sets': sets,
        'repetitions': repetitions,
      };
}

class DigifitExerciseUserProgressModel
    extends BaseModel<DigifitExerciseUserProgressModel> {
  int currentSet;
  int totalCompletedReps;
  int totalSets;
  int repetitionsPerSet;
  bool isCompleted;

  DigifitExerciseUserProgressModel({
    this.currentSet = 0,
    this.totalCompletedReps = 0,
    this.totalSets = 0,
    this.repetitionsPerSet = 0,
    this.isCompleted = false,
  });

  @override
  DigifitExerciseUserProgressModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseUserProgressModel(
      currentSet: json['currentSet'] ?? 0,
      totalCompletedReps: json['totalCompletedReps'] ?? 0,
      totalSets: json['totalSets'] ?? 0,
      repetitionsPerSet: json['repetitionsPerSet'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'currentSet': currentSet,
    'totalCompletedReps': totalCompletedReps,
    'totalSets': totalSets,
    'repetitionsPerSet': repetitionsPerSet,
    'isCompleted': isCompleted,
  };
}


class DigifitExerciseActionsModel
    extends BaseModel<DigifitExerciseActionsModel> {
  String scanExerciseUrl;

  DigifitExerciseActionsModel({this.scanExerciseUrl = ''});

  @override
  DigifitExerciseActionsModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseActionsModel(
      scanExerciseUrl: json['scanExerciseUrl'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'scanExerciseUrl': scanExerciseUrl,
      };
}

class DigifitExerciseRelatedStationsModel
    extends BaseModel<DigifitExerciseRelatedStationsModel> {
  int id;
  String name;
  String muscleGroups;
  bool isFavorite;
  String machineImageUrl;

  DigifitExerciseRelatedStationsModel({
    this.id = 0,
    this.name = '',
    this.muscleGroups = '',
    this.isFavorite = false,
    this.machineImageUrl = ''
  });

  @override
  DigifitExerciseRelatedStationsModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseRelatedStationsModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        muscleGroups: json['muscleGroups'] ?? '',
        isFavorite: json['isFavorite'] ?? false,
        machineImageUrl: json['machineImageUrl'] ?? ''
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroups': muscleGroups,
        'isFavorite': isFavorite,
        'machineImageUrl': machineImageUrl
      };
}
