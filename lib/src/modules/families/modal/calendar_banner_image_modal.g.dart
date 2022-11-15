// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_banner_image_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarBannerImageModalAdapter
    extends TypeAdapter<CalendarBannerImageModal> {
  @override
  final int typeId = 24;

  @override
  CalendarBannerImageModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarBannerImageModal(
      id: fields[1] as String?,
      name: fields[2] as String?,
      monthC: fields[3] as String?,
      monthImageC: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarBannerImageModal obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.monthC)
      ..writeByte(5)
      ..write(obj.monthImageC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarBannerImageModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
