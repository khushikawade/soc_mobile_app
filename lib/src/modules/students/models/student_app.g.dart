// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_app.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAppAdapter extends TypeAdapter<StudentApp> {
  @override
  final int typeId = 5;

  @override
  StudentApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentApp(
      titleC: fields[0] as String?,
      appIconC: fields[1] as String?,
      appUrlC: fields[2] as String?,
      deepLinkC: fields[3] as String?,
      id: fields[4] as String?,
      name: fields[5] as String?,
      appFolderc: fields[6] as String?,
      sortOrder: fields[7] as dynamic,
      status: fields[8] as dynamic,
      isFolder: fields[9] as dynamic,
      darkModeIconC: fields[10] as String?,
      typeC: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentApp obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.titleC)
      ..writeByte(1)
      ..write(obj.appIconC)
      ..writeByte(2)
      ..write(obj.appUrlC)
      ..writeByte(3)
      ..write(obj.deepLinkC)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.appFolderc)
      ..writeByte(7)
      ..write(obj.sortOrder)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.isFolder)
      ..writeByte(10)
      ..write(obj.darkModeIconC)
      ..writeByte(11)
      ..write(obj.typeC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
