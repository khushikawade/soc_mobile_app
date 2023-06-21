// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_skill_list_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusSkillsAdapter extends TypeAdapter<PBISPlusSkills> {
  @override
  final int typeId = 44;

  @override
  PBISPlusSkills read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusSkills(
      id: fields[0] as String?,
      activeStatusC: fields[1] as String?,
      iconUrlC: fields[2] as String?,
      name: fields[3] as String?,
      sortOrderC: fields[4] as String?,
      counter: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusSkills obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activeStatusC)
      ..writeByte(2)
      ..write(obj.iconUrlC)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.sortOrderC)
      ..writeByte(5)
      ..write(obj.counter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusSkillsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
