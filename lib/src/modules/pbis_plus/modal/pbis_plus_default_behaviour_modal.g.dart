// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_default_behaviour_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusDefaultAndCustomBehaviourModalAdapter
    extends TypeAdapter<PBISPlusDefaultAndCustomBehaviourModal> {
  @override
  final int typeId = 46;

  @override
  PBISPlusDefaultAndCustomBehaviourModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusDefaultAndCustomBehaviourModal(
      defaultList: (fields[0] as List?)?.cast<PBISPlusDefaultBehaviourModal>(),
      customList: (fields[1] as List?)?.cast<PBISPlusDefaultBehaviourModal>(),
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusDefaultAndCustomBehaviourModal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.defaultList)
      ..writeByte(1)
      ..write(obj.customList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusDefaultAndCustomBehaviourModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PBISPlusDefaultBehaviourModalAdapter
    extends TypeAdapter<PBISPlusDefaultBehaviourModal> {
  @override
  final int typeId = 47;

  @override
  PBISPlusDefaultBehaviourModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusDefaultBehaviourModal(
      id: fields[0] as int?,
      behaviourId: fields[1] as String?,
      sortingOrder: fields[2] as String?,
      createdAt: fields[4] as String?,
      updatedAt: fields[5] as String?,
      teacherId: fields[3] as String?,
      name: fields[6] as String?,
      iconUrl: fields[7] as String?,
      isdefault: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusDefaultBehaviourModal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.behaviourId)
      ..writeByte(2)
      ..write(obj.sortingOrder)
      ..writeByte(3)
      ..write(obj.teacherId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.iconUrl)
      ..writeByte(8)
      ..write(obj.isdefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusDefaultBehaviourModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
