// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sd_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeAdapter extends TypeAdapter<Theme> {
  @override
  final int typeId = 7;

  @override
  Theme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Theme(
      fields[0] as int?,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Theme obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hiveobjid)
      ..writeByte(1)
      ..write(obj.themeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
