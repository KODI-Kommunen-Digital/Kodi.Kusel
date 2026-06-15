import 'package:core/base_model.dart';

class DigifitFavResponseModel implements BaseModel<DigifitFavResponseModel> {
  String? status;
  List<DigifitFavData>? data;

  DigifitFavResponseModel({this.status, this.data});

  @override
  DigifitFavResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitFavResponseModel(
      status: json['status'],
      data: (json['data'] != null)
          ? (json['data'] as List)
              .map((e) => DigifitFavData().fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class DigifitFavData implements BaseModel<DigifitFavData> {
  int? equipmentId;
  String? name;
  String? muscleGroup;
  int? locationId;
  String? machineImageUrls;
  String? description;
  int? recommendedSets;
  int? recommendedReps;
  int? minReps;
  int? minSets;
  String? qrCodeIdentifier;
  String? locationName;
  String? mapImageUrl;
  bool? isFavorite;
  bool? isCompleted;

  DigifitFavData(
      {this.equipmentId,
      this.name,
      this.muscleGroup,
      this.locationId,
      this.machineImageUrls,
      this.description,
      this.recommendedSets,
      this.recommendedReps,
      this.minReps,
      this.minSets,
      this.qrCodeIdentifier,
      this.locationName,
      this.mapImageUrl,
      this.isFavorite,
      this.isCompleted});

  @override
  DigifitFavData fromJson(Map<String, dynamic> json) {
    return DigifitFavData(
      equipmentId: json['equipmentId'],
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      locationId: json['locationId'],
      machineImageUrls: json['machineImageUrls'],
      description: json['description'],
      recommendedSets: json['recommendedSets'],
      recommendedReps: json['recommendedReps'],
      minReps: json['minReps'],
      minSets: json['minSets'],
      qrCodeIdentifier: json['qrCodeIdentifier'],
      locationName: json['locationName'],
      mapImageUrl: json['mapImageUrl'],
      isFavorite: json['isFavorite'],
      isCompleted: json['isCompleted'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'equipmentId': equipmentId,
      'name': name,
      'muscleGroup': muscleGroup,
      'locationId': locationId,
      'machineImageUrls': machineImageUrls,
      'description': description,
      'recommendedSets': recommendedSets,
      'recommendedReps': recommendedReps,
      'minReps': minReps,
      'minSets': minSets,
      'qrCodeIdentifier': qrCodeIdentifier,
      'locationName': locationName,
      'mapImageUrl': mapImageUrl,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted
    };
  }
}
