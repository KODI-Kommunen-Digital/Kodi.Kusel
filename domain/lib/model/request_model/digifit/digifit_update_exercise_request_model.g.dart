// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digifit_update_exercise_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DigifitUpdateExerciseRequestModelAdapter
    extends TypeAdapter<DigifitUpdateExerciseRequestModel> {
  @override
  final int typeId = 8;

  @override
  DigifitUpdateExerciseRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitUpdateExerciseRequestModel(
      data: (fields[0] as List?)
          ?.map((dynamic e) => (e as Map).map((dynamic k, dynamic v) =>
              MapEntry(
                  k as String, (v as List).cast<DigifitExerciseRecordModel>())))
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, DigifitUpdateExerciseRequestModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitUpdateExerciseRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DigifitExerciseRecordModelAdapter
    extends TypeAdapter<DigifitExerciseRecordModel> {
  @override
  final int typeId = 9;

  @override
  DigifitExerciseRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitExerciseRecordModel(
      setComplete: fields[0] as int,
      locationId: fields[1] as int,
      createdAt: fields[2] as String,
      updatedAt: fields[3] as String,
      setTimeList: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DigifitExerciseRecordModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.setComplete)
      ..writeByte(1)
      ..write(obj.locationId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.setTimeList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitExerciseRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
