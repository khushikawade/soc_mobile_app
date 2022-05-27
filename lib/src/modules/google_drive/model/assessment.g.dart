// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAssessmentAdapter extends TypeAdapter<HistoryAssessment> {
  @override
  final int typeId = 16;

  @override
  HistoryAssessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryAssessment(
      title: fields[0] as String?,
      description: fields[1] as String?,
      fileid: fields[2] as String?,
      label: fields[3] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryAssessment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.fileid)
      ..writeByte(3)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
