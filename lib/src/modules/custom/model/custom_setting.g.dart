// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomSettingAdapter extends TypeAdapter<CustomSetting> {
  @override
  final int typeId = 11;

  @override
  CustomSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomSetting(
      attributes: fields[0] as Attributes?,
      id: fields[1] as String?,
      customBannerColorC: fields[2] as String?,
      customBannerImageC: fields[3] as String?,
      name: fields[4] as String?,
      mobileAppSectionC: fields[5] as String?,
      sectionIconC: fields[6] as String?,
      selectionTitleC: fields[7] as String?,
      sortOrderC: fields[8] as double?,
      systemReferenceC: fields[9] as String?,
      sectionTypeC: fields[10] as String?,
      mobileAppC: fields[12] as String?,
      status: fields[13] as dynamic,
      appUrlC: fields[14] as dynamic,
      pdfURL: fields[15] as dynamic,
      rtfHTMLC: fields[16] as dynamic,
      calendarId: fields[17] as dynamic,
      sectionTemplate: fields[11] as String?,
      rssFeed: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomSetting obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.attributes)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.customBannerColorC)
      ..writeByte(3)
      ..write(obj.customBannerImageC)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.mobileAppSectionC)
      ..writeByte(6)
      ..write(obj.sectionIconC)
      ..writeByte(7)
      ..write(obj.selectionTitleC)
      ..writeByte(8)
      ..write(obj.sortOrderC)
      ..writeByte(9)
      ..write(obj.systemReferenceC)
      ..writeByte(10)
      ..write(obj.sectionTypeC)
      ..writeByte(11)
      ..write(obj.sectionTemplate)
      ..writeByte(12)
      ..write(obj.mobileAppC)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.appUrlC)
      ..writeByte(15)
      ..write(obj.pdfURL)
      ..writeByte(16)
      ..write(obj.rtfHTMLC)
      ..writeByte(17)
      ..write(obj.calendarId)
      ..writeByte(18)
      ..write(obj.rssFeed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
