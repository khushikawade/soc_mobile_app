// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pibs_plus_history_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusHistoryModalAdapter extends TypeAdapter<PBISPlusHistoryModal> {
  @override
  final int typeId = 38;

  @override
  PBISPlusHistoryModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusHistoryModal(
      id: fields[0] as int?,
      createdAt: fields[1] as String?,
      type: fields[2] as String?,
      uRL: fields[3] as String?,
      teacherEmail: fields[4] as String?,
      schoolId: fields[5] as String?,
    )
      ..classroomCourse = fields[6] as String?
      ..title = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, PBISPlusHistoryModal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.uRL)
      ..writeByte(4)
      ..write(obj.teacherEmail)
      ..writeByte(5)
      ..write(obj.schoolId)
      ..writeByte(6)
      ..write(obj.classroomCourse)
      ..writeByte(7)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusHistoryModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
