// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 8;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      title: fields[0] as dynamic,
      description: fields[1] as dynamic,
      link: fields[2] as dynamic,
      guid: fields[3] as dynamic,
      creator: fields[4] as dynamic,
      pubDate: fields[5] as dynamic,
      content: fields[6] as dynamic,
      mediaContent: fields[7] as dynamic,
      enclosure: fields[8] as dynamic,
      id: fields[9] as dynamic,
      completedAt: fields[16] as dynamic,
      completedAtTimestamp: fields[17] as dynamic,
      image: fields[15] as String?,
      likeCount: fields[10] as int?,
      thanksCount: fields[11] as int?,
      helpfulCount: fields[12] as int?,
      shareCount: fields[13] as int?,
      supportCount: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.guid)
      ..writeByte(4)
      ..write(obj.creator)
      ..writeByte(5)
      ..write(obj.pubDate)
      ..writeByte(6)
      ..write(obj.content)
      ..writeByte(7)
      ..write(obj.mediaContent)
      ..writeByte(8)
      ..write(obj.enclosure)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.likeCount)
      ..writeByte(11)
      ..write(obj.thanksCount)
      ..writeByte(12)
      ..write(obj.helpfulCount)
      ..writeByte(13)
      ..write(obj.shareCount)
      ..writeByte(14)
      ..write(obj.supportCount)
      ..writeByte(15)
      ..write(obj.image)
      ..writeByte(16)
      ..write(obj.completedAt)
      ..writeByte(17)
      ..write(obj.completedAtTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
