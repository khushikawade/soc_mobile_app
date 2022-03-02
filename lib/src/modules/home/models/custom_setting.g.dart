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
      bannerColorC: fields[2] as String?,
      bannerImageC: fields[3] as String?,
      lastModifiedDate: fields[4] as String?,
      lastModifiedById: fields[5] as String?,
      ownerId: fields[6] as String?,
      name: fields[7] as String?,
      createdDate: fields[8] as String?,
      customAppC: fields[9] as String?,
      sectionIconC: fields[10] as String?,
      selectionTitleC: fields[11] as String?,
      sortOrderC: fields[12] as double?,
      standardSectionC: fields[13] as String?,
      typeOfSectionC: fields[14] as String?,
      isDeleted: fields[15] as bool?,
      systemModstamp: fields[16] as String?,
      lastActivityDate: fields[17] as dynamic,
      lastViewedDate: fields[18] as String?,
      lastReferencedDate: fields[19] as String?,
      connectionReceivedId: fields[20] as String?,
      connectionSentId: fields[21] as String?,
      schoolAppC: fields[22] as String?,
      status: fields[23] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CustomSetting obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.attributes)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.bannerColorC)
      ..writeByte(3)
      ..write(obj.bannerImageC)
      ..writeByte(4)
      ..write(obj.lastModifiedDate)
      ..writeByte(5)
      ..write(obj.lastModifiedById)
      ..writeByte(6)
      ..write(obj.ownerId)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.createdDate)
      ..writeByte(9)
      ..write(obj.customAppC)
      ..writeByte(10)
      ..write(obj.sectionIconC)
      ..writeByte(11)
      ..write(obj.selectionTitleC)
      ..writeByte(12)
      ..write(obj.sortOrderC)
      ..writeByte(13)
      ..write(obj.standardSectionC)
      ..writeByte(14)
      ..write(obj.typeOfSectionC)
      ..writeByte(15)
      ..write(obj.isDeleted)
      ..writeByte(16)
      ..write(obj.systemModstamp)
      ..writeByte(17)
      ..write(obj.lastActivityDate)
      ..writeByte(18)
      ..write(obj.lastViewedDate)
      ..writeByte(19)
      ..write(obj.lastReferencedDate)
      ..writeByte(20)
      ..write(obj.connectionReceivedId)
      ..writeByte(21)
      ..write(obj.connectionSentId)
      ..writeByte(22)
      ..write(obj.schoolAppC)
      ..writeByte(23)
      ..write(obj.status);
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
