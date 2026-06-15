// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digifit_cache_data_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DigifitCacheDataResponseModelAdapter
    extends TypeAdapter<DigifitCacheDataResponseModel> {
  @override
  final int typeId = 1;

  @override
  DigifitCacheDataResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigifitCacheDataResponseModel(
      status: fields[0] as String,
      data: fields[1] as DigifitInformationDataModel?,
    );
  }

  @override
  void write(BinaryWriter writer, DigifitCacheDataResponseModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigifitCacheDataResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
