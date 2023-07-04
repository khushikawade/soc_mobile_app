// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_plus_common_behavior_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PBISPlusCommonBehaviorModalAdapter
    extends TypeAdapter<PBISPlusCommonBehaviorModal> {
  @override
  final int typeId = 54;

  @override
  PBISPlusCommonBehaviorModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PBISPlusCommonBehaviorModal(
      id: fields[0] as String?,
      activeStatusC: fields[1] as String?,
      behaviorTitleC: fields[2] as String?,
      mobileAppC: fields[3] as String?,
      pBISBehaviorIconURLC: fields[4] as String?,
      pBISBehaviorSortOrderC: fields[5] as String?,
      name: fields[6] as String?,
      pBISSoundC: fields[7] as String?,
      createdById: fields[8] as String?,
      lastModifiedById: fields[9] as String?,
      ownerId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PBISPlusCommonBehaviorModal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activeStatusC)
      ..writeByte(2)
      ..write(obj.behaviorTitleC)
      ..writeByte(3)
      ..write(obj.mobileAppC)
      ..writeByte(4)
      ..write(obj.pBISBehaviorIconURLC)
      ..writeByte(5)
      ..write(obj.pBISBehaviorSortOrderC)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.pBISSoundC)
      ..writeByte(8)
      ..write(obj.createdById)
      ..writeByte(9)
      ..write(obj.lastModifiedById)
      ..writeByte(10)
      ..write(obj.ownerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PBISPlusCommonBehaviorModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
