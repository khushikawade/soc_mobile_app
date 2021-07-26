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
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
      fields[8] as String?,
      fields[7] as String?,
      fields[6] as String?,
      fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Recent obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.hiveobjid)
      ..writeByte(1)
      ..write(obj.titleC)
      ..writeByte(2)
      ..write(obj.appURLC)
      ..writeByte(3)
      ..write(obj.urlC)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.typeC)
      ..writeByte(7)
      ..write(obj.rtfHTMLC)
      ..writeByte(8)
      ..write(obj.pdfURL)
      ..writeByte(9)
      ..write(obj.deepLink);
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
