// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_genric_behaviour_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusGenericBehaviourModalAdapter
    extends TypeAdapter<PBISPlusGenericBehaviourModal> {
  @override
  final int typeId = 44;

  @override
  PBISPlusGenericBehaviourModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusGenericBehaviourModal(
      id: fields[0] as String?,
      activeStatusC: fields[1] as String?,
      iconUrlC: fields[2] as String?,
      name: fields[3] as String?,
      sortOrderC: fields[4] as String?,
      counter: fields[5] as int?,
      behaviourId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusGenericBehaviourModal obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.counter)
      ..writeByte(6)
      ..write(obj.behaviourId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusGenericBehaviourModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
