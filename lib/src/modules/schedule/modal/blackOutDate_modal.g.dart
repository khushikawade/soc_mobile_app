// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blackOutDate_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlackoutDateAdapter extends TypeAdapter<BlackoutDate> {
  @override
  final int typeId = 22;

  @override
  BlackoutDate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlackoutDate(
      id: fields[0] as String?,
      name: fields[1] as String?,
      startDateC: fields[2] as DateTime?,
      endDateC: fields[3] as DateTime?,
      titleC: fields[4] as String?,
      schoolYearC: fields[5] as String?,
      scheduleSchoolTypeC: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlackoutDate obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startDateC)
      ..writeByte(3)
      ..write(obj.endDateC)
      ..writeByte(4)
      ..write(obj.titleC)
      ..writeByte(5)
      ..write(obj.schoolYearC)
      ..writeByte(6)
      ..write(obj.scheduleSchoolTypeC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlackoutDateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
