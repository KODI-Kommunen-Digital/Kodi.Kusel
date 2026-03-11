// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digifit_information_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DigifitInformationResponseModelAdapter
    extends TypeAdapter<DigifitInformationResponseModel> {
  @override
  final int typeId = 2;

  @override
  DigifitInformationResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationResponseModel(
      data: fields[0] as DigifitInformationDataModel?,
      status: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationResponseModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitInformationDataModelAdapter
    extends TypeAdapter<DigifitInformationDataModel> {
  @override
  final int typeId = 3;

  @override
  DigifitInformationDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationDataModel(
      sourceId: fields[0] as int?,
      userStats: fields[1] as DigifitInformationUserStatsModel?,
      parcours: (fields[2] as List?)?.cast<DigifitInformationParcoursModel>(),
      actions: fields[3] as DigifitInformationActionsModel?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sourceId)
      ..writeByte(1)
      ..write(obj.userStats)
      ..writeByte(2)
      ..write(obj.parcours)
      ..writeByte(3)
      ..write(obj.actions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitInformationUserStatsModelAdapter
    extends TypeAdapter<DigifitInformationUserStatsModel> {
  @override
  final int typeId = 4;

  @override
  DigifitInformationUserStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationUserStatsModel(
      points: fields[0] as int?,
      trophies: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationUserStatsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.points)
      ..writeByte(1)
      ..write(obj.trophies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationUserStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitInformationParcoursModelAdapter
    extends TypeAdapter<DigifitInformationParcoursModel> {
  @override
  final int typeId = 5;

  @override
  DigifitInformationParcoursModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationParcoursModel(
      name: fields[0] as String?,
      locationId: fields[1] as int?,
      mapImageUrl: fields[2] as String?,
      showParcoursUrl: fields[3] as String?,
      points: fields[4] as int?,
      trophies: fields[5] as int?,
      stations: (fields[6] as List?)?.cast<DigifitInformationStationModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationParcoursModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.locationId)
      ..writeByte(2)
      ..write(obj.mapImageUrl)
      ..writeByte(3)
      ..write(obj.showParcoursUrl)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.trophies)
      ..writeByte(6)
      ..write(obj.stations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationParcoursModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitInformationStationModelAdapter
    extends TypeAdapter<DigifitInformationStationModel> {
  @override
  final int typeId = 6;

  @override
  DigifitInformationStationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationStationModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      muscleGroups: fields[2] as String?,
      qrCodeIdentifier: fields[3] as String?,
      machineImageUrl: fields[4] as String?,
      isFavorite: fields[5] as bool?,
      isCompleted: fields[6] as bool?,
      recommendedReps: fields[7] as int?,
      recommendedSets: fields[8] as int?,
      description: fields[9] as String?,
      minReps: fields[10] as int?,
      minSets: fields[11] as int?,
      sets: fields[12] as String?,
      repetitions: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationStationModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.muscleGroups)
      ..writeByte(3)
      ..write(obj.qrCodeIdentifier)
      ..writeByte(4)
      ..write(obj.machineImageUrl)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.recommendedReps)
      ..writeByte(8)
      ..write(obj.recommendedSets)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.minReps)
      ..writeByte(11)
      ..write(obj.minSets)
      ..writeByte(12)
      ..write(obj.sets)
      ..writeByte(13)
      ..write(obj.repetitions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationStationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitInformationActionsModelAdapter
    extends TypeAdapter<DigifitInformationActionsModel> {
  @override
  final int typeId = 7;

  @override
  DigifitInformationActionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitInformationActionsModel(
      trophiesUrl: fields[0] as String?,
      puzzleUrl: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitInformationActionsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.trophiesUrl)
      ..writeByte(1)
      ..write(obj.puzzleUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitInformationActionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
