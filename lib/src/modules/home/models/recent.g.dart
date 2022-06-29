// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentAdapter extends TypeAdapter<Recent> {
  @override
  final int typeId = 6;

  @override
  Recent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recent(
      fields[0] as int?,
      fields[1] as String?,
      fields[2] as dynamic,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Recent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.hiveobjid)
      ..writeByte(1)
      ..write(obj.titleC)
      ..writeByte(2)
      ..write(obj.appIconUrlC)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.objectName)
      ..writeByte(5)
      ..write(obj.typeC)
      ..writeByte(6)
      ..write(obj.darkModeIconC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
