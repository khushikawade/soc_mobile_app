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
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as String?,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as dynamic,
      fields[10] as String?,
      fields[11] as String?,
      fields[12] as dynamic,
      fields[13] as String?,
      fields[14] as String?,
      fields[15] as String?,
      fields[16] as String?,
      fields[17] as String?,
      fields[18] as String?,
      fields[19] as String?,
      fields[20] as String?,
      fields[21] as dynamic,
      fields[22] as dynamic,
      fields[23] as dynamic,
      fields[24] as dynamic,
      fields[25] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Recent obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.hiveobjid)
      ..writeByte(1)
      ..write(obj.titleC)
      ..writeByte(2)
      ..write(obj.appIconUrlC)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.objectName)
      ..writeByte(7)
      ..write(obj.rtfHTMLC)
      ..writeByte(8)
      ..write(obj.typeC)
      ..writeByte(9)
      ..write(obj.statusC)
      ..writeByte(10)
      ..write(obj.urlC)
      ..writeByte(11)
      ..write(obj.pdfURL)
      ..writeByte(12)
      ..write(obj.sortOrder)
      ..writeByte(13)
      ..write(obj.deepLink)
      ..writeByte(14)
      ..write(obj.appURLC)
      ..writeByte(15)
      ..write(obj.calendarId)
      ..writeByte(16)
      ..write(obj.emailC)
      ..writeByte(17)
      ..write(obj.imageUrlC)
      ..writeByte(18)
      ..write(obj.phoneC)
      ..writeByte(19)
      ..write(obj.webURLC)
      ..writeByte(20)
      ..write(obj.address)
      ..writeByte(21)
      ..write(obj.geoLocation)
      ..writeByte(22)
      ..write(obj.descriptionC)
      ..writeByte(23)
      ..write(obj.latitude)
      ..writeByte(24)
      ..write(obj.longitude)
      ..writeByte(25)
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
