// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_skill_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusSkillsModalAdapter extends TypeAdapter<PBISPlusSkillsModal> {
  @override
  final int typeId = 43;

  @override
  PBISPlusSkillsModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusSkillsModal(
      dataList: (fields[0] as List).cast<PBISPlusActionInteractionModal>(),
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusSkillsModal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dataList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusSkillsModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PBISPlusActionInteractionModalAdapter
    extends TypeAdapter<PBISPlusActionInteractionModal> {
  @override
  final int typeId = 44;

  @override
  PBISPlusActionInteractionModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusActionInteractionModal(
      id: fields[0] as String?,
      activeStatusC: fields[1] as String?,
      iconUrlC: fields[2] as String?,
      name: fields[3] as String?,
      sortOrderC: fields[4] as String?,
      counter: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusActionInteractionModal obj) {
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
      other is PBISPlusActionInteractionModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
