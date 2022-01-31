// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_directory_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolDirectoryListAdapter extends TypeAdapter<SchoolDirectoryList> {
  @override
  final int typeId = 4;

  @override
  SchoolDirectoryList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolDirectoryList(
      titleC: fields[0] as String?,
      imageUrlC: fields[1] as String?,
      address: fields[2] as String?,
      phoneC: fields[3] as String?,
      rtfHTMLC: fields[4] as String?,
      emailC: fields[5] as String?,
      geoLocation: fields[6] as dynamic,
      urlC: fields[7] as String?,
      id: fields[8] as String?,
      sortOrder: fields[9] as dynamic,
      statusC: fields[10] as dynamic,
      latitude: fields[11] as dynamic,
      longitude: fields[12] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolDirectoryList obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.titleC)
      ..writeByte(1)
      ..write(obj.imageUrlC)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phoneC)
      ..writeByte(4)
      ..write(obj.rtfHTMLC)
      ..writeByte(5)
      ..write(obj.emailC)
      ..writeByte(6)
      ..write(obj.geoLocation)
      ..writeByte(7)
      ..write(obj.urlC)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.sortOrder)
      ..writeByte(10)
      ..write(obj.statusC)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolDirectoryListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
