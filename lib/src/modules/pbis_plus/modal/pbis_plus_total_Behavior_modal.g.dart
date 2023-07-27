// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_total_Behavior_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusTotalBehaviorModalAdapter
    extends TypeAdapter<PBISPlusTotalBehaviorModal> {
  @override
  final int typeId = 59;

  @override
  PBISPlusTotalBehaviorModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusTotalBehaviorModal(
      schoolAppC: fields[0] as String?,
      studentId: fields[1] as String?,
      teacherEmail: fields[2] as String?,
      studentEmail: fields[3] as String?,
      behaviorList: (fields[4] as List?)?.cast<BehaviorList>(),
      createdAt: fields[5] as String?,
    )..classroomCourseId = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, PBISPlusTotalBehaviorModal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.schoolAppC)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.teacherEmail)
      ..writeByte(3)
      ..write(obj.studentEmail)
      ..writeByte(4)
      ..write(obj.behaviorList)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.classroomCourseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusTotalBehaviorModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
