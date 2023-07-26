// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_total_behaviour_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusStudentDashboardTotalBehaviourModalAdapter
    extends TypeAdapter<PBISPlusStudentDashboardTotalBehaviourModal> {
  @override
  final int typeId = 55;

  @override
  PBISPlusStudentDashboardTotalBehaviourModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusStudentDashboardTotalBehaviourModal(
      schoolId: fields[0] as String?,
      studentId: fields[1] as String?,
      teacherEmail: fields[2] as String?,
      studentEmail: fields[3] as String?,
      interactionCounts: (fields[4] as List?)?.cast<InteractionCounts>(),
      createdAt: fields[5] as String?,
    );
  }

  @override
  void write(
      BinaryWriter writer, PBISPlusStudentDashboardTotalBehaviourModal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.schoolId)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.teacherEmail)
      ..writeByte(3)
      ..write(obj.studentEmail)
      ..writeByte(4)
      ..write(obj.interactionCounts)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusStudentDashboardTotalBehaviourModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InteractionCountsAdapter extends TypeAdapter<InteractionCounts> {
  @override
  final int typeId = 56;

  @override
  InteractionCounts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InteractionCounts(
      behaviourId: fields[0] as String?,
      behaviorCount: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, InteractionCounts obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.behaviourId)
      ..writeByte(1)
      ..write(obj.behaviorCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractionCountsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
