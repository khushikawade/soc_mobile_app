// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_total_interaction_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusTotalInteractionByTeacherModalAdapter
    extends TypeAdapter<PBISPlusTotalInteractionByTeacherModal> {
  @override
  final int typeId = 40;

  @override
  PBISPlusTotalInteractionByTeacherModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusTotalInteractionByTeacherModal(
      schoolId: fields[0] as String?,
      studentId: fields[1] as String?,
      teacherEmail: fields[2] as String?,
      engaged: fields[3] as int?,
      niceWork: fields[4] as int?,
      helpful: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusTotalInteractionByTeacherModal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.schoolId)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.teacherEmail)
      ..writeByte(3)
      ..write(obj.engaged)
      ..writeByte(4)
      ..write(obj.niceWork)
      ..writeByte(5)
      ..write(obj.helpful);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusTotalInteractionByTeacherModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
