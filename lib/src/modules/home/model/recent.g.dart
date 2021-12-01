// GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'recent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
//  part of 'package:Soc/src/modules/home/model/recent.dart';
//  'package:hive/hive.dart';

import 'package:hive/hive.dart';
import 'package:Soc/src/modules/home/model/recent.dart';

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
      fields[6] as String?,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as String?,
      fields[10] as String?,
      fields[11] as String?,
      fields[12],
      fields[13] as String?,
      fields[14] as String?,
      fields[15] as String?,
      fields[16] as String?,
      fields[17] as String?,
      fields[18],
      fields[19],
      fields[20],
      fields[21] as String?,
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
      ..write(obj.deepLink)
      ..writeByte(10)
      ..write(obj.schoolId)
      ..writeByte(11)
      ..write(obj.dept)
      ..writeByte(12)
      ..write(obj.descriptionC)
      ..writeByte(13)
      ..write(obj.emailC)
      ..writeByte(14)
      ..write(obj.imageUrlC)
      ..writeByte(15)
      ..write(obj.phoneC)
      ..writeByte(16)
      ..write(obj.webURLC)
      ..writeByte(17)
      ..write(obj.address)
      ..writeByte(18)
      ..write(obj.geoLocation)
      ..writeByte(19)
      ..write(obj.statusC)
      ..writeByte(20)
      ..write(obj.sortOrder)
      ..writeByte(21)
      ..write(obj.calendarId);
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
