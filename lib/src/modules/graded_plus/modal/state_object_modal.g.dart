// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_object_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StateListObjectAdapter extends TypeAdapter<StateListObject> {
  @override
  final int typeId = 29;

  @override
  StateListObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateListObject(
      gradedplusRubricC: fields[0] as String?,
      standardsPdfC: fields[1] as String?,
      stateC: fields[2] as String?,
      titleC: fields[3] as String?,
      usedInC: fields[4] as String?,
      id: fields[5] as String?,
      dateTime: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StateListObject obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.gradedplusRubricC)
      ..writeByte(1)
      ..write(obj.standardsPdfC)
      ..writeByte(2)
      ..write(obj.stateC)
      ..writeByte(3)
      ..write(obj.titleC)
      ..writeByte(4)
      ..write(obj.usedInC)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateListObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
