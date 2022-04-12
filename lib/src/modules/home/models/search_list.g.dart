// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchListAdapter extends TypeAdapter<SearchList> {
  @override
  final int typeId = 12;

  @override
  SearchList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchList(
      titleC: fields[0] as String?,
      appIconUrlC: fields[1] as dynamic,
      appURLC: fields[2] as dynamic,
      urlC: fields[3] as dynamic,
      id: fields[4] as String?,
      rtfHTMLC: fields[5] as String?,
      descriptionC: fields[6] as dynamic,
      emailC: fields[7] as String?,
      imageUrlC: fields[8] as String?,
      phoneC: fields[9] as String?,
      webURLC: fields[10] as String?,
      address: fields[11] as String?,
      geoLocation: fields[12] as dynamic,
      statusC: fields[13] as dynamic,
      sortOrder: fields[14] as double?,
      name: fields[15] as String?,
      typeC: fields[16] as String?,
      pdfURL: fields[17] as String?,
      deepLink: fields[18] as String?,
      calendarId: fields[19] as String?,
      objectName: fields[20] as String?,
      latitude: fields[21] as dynamic,
      longitude: fields[23] as dynamic,
      darkModeIconC: fields[24] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SearchList obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.titleC)
      ..writeByte(1)
      ..write(obj.appIconUrlC)
      ..writeByte(2)
      ..write(obj.appURLC)
      ..writeByte(3)
      ..write(obj.urlC)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.rtfHTMLC)
      ..writeByte(6)
      ..write(obj.descriptionC)
      ..writeByte(7)
      ..write(obj.emailC)
      ..writeByte(8)
      ..write(obj.imageUrlC)
      ..writeByte(9)
      ..write(obj.phoneC)
      ..writeByte(10)
      ..write(obj.webURLC)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.geoLocation)
      ..writeByte(13)
      ..write(obj.statusC)
      ..writeByte(14)
      ..write(obj.sortOrder)
      ..writeByte(15)
      ..write(obj.name)
      ..writeByte(16)
      ..write(obj.typeC)
      ..writeByte(17)
      ..write(obj.pdfURL)
      ..writeByte(18)
      ..write(obj.deepLink)
      ..writeByte(19)
      ..write(obj.calendarId)
      ..writeByte(20)
      ..write(obj.objectName)
      ..writeByte(21)
      ..write(obj.latitude)
      ..writeByte(23)
      ..write(obj.longitude)
      ..writeByte(24)
      ..write(obj.darkModeIconC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
