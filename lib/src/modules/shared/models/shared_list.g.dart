// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedListAdapter extends TypeAdapter<SharedList> {
  @override
  final int typeId = 2;

  @override
  SharedList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedList(
      titleC: fields[0] as String?,
      appIconC: fields[1] as String?,
      appUrlC: fields[3] as String?,
      pdfURL: fields[4] as String?,
      id: fields[5] as String?,
      name: fields[6] as String?,
      rtfHTMLC: fields[7] as String?,
      appIconUrlC: fields[2] as String?,
      typeC: fields[8] as String?,
      calendarId: fields[9] as String?,
      sortOrder: fields[10] as dynamic,
      status: fields[11] as dynamic,
      deepLinkC: fields[12] as String?,
      darkModeIconC: fields[13] as String?,
      isSecure: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SharedList obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.titleC)
      ..writeByte(1)
      ..write(obj.appIconC)
      ..writeByte(2)
      ..write(obj.appIconUrlC)
      ..writeByte(3)
      ..write(obj.appUrlC)
      ..writeByte(4)
      ..write(obj.pdfURL)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.rtfHTMLC)
      ..writeByte(8)
      ..write(obj.typeC)
      ..writeByte(9)
      ..write(obj.calendarId)
      ..writeByte(10)
      ..write(obj.sortOrder)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.deepLinkC)
      ..writeByte(13)
      ..write(obj.darkModeIconC)
      ..writeByte(14)
      ..write(obj.isSecure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
