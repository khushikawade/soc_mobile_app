// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationListAdapter extends TypeAdapter<NotificationList> {
  @override
  final int typeId = 7;

  @override
  NotificationList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationList(
      id: fields[0] as String?,
      contents: fields[1] as dynamic,
      headings: fields[2] as dynamic,
      url: fields[3] as dynamic,
      image: fields[4] as String?,
      completedAt: fields[5] as dynamic,
      thanksCount: fields[6] as dynamic,
      helpfulCount: fields[7] as dynamic,
      shareCount: fields[8] as dynamic,
      likeCount: fields[9] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationList obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contents)
      ..writeByte(2)
      ..write(obj.headings)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.completedAt)
      ..writeByte(6)
      ..write(obj.thanksCount)
      ..writeByte(7)
      ..write(obj.helpfulCount)
      ..writeByte(8)
      ..write(obj.shareCount)
      ..writeByte(9)
      ..write(obj.likeCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
