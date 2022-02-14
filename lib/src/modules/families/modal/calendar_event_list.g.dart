// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarEventListAdapter extends TypeAdapter<CalendarEventList> {
  @override
  final int typeId = 13;

  @override
  CalendarEventList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEventList(
      kind: fields[0] as String?,
      etag: fields[1] as String?,
      id: fields[2] as String?,
      status: fields[3] as String?,
      htmlLink: fields[4] as String?,
      created: fields[5] as String?,
      updated: fields[6] as String?,
      summary: fields[7] as String?,
      description: fields[8] as String?,
      start: fields[9] as dynamic,
      end: fields[10] as dynamic,
      iCalUid: fields[11] as String?,
      sequence: fields[12] as int?,
      eventType: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarEventList obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.kind)
      ..writeByte(1)
      ..write(obj.etag)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.htmlLink)
      ..writeByte(5)
      ..write(obj.created)
      ..writeByte(6)
      ..write(obj.updated)
      ..writeByte(7)
      ..write(obj.summary)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.start)
      ..writeByte(10)
      ..write(obj.end)
      ..writeByte(11)
      ..write(obj.iCalUid)
      ..writeByte(12)
      ..write(obj.sequence)
      ..writeByte(13)
      ..write(obj.eventType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
