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
      webContentLink: fields[4] as String?,
      createdDate: fields[5] as String?,
      modifiedDate: fields[6] as String?,
      sessionId: fields[7] as String?,
      isCreatedAsPremium: fields[8] as String?,
      assessmentType: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryAssessment obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.fileid)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.webContentLink)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.modifiedDate)
      ..writeByte(7)
      ..write(obj.sessionId)
      ..writeByte(8)
      ..write(obj.isCreatedAsPremium)
      ..writeByte(9)
      ..write(obj.assessmentType);
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
