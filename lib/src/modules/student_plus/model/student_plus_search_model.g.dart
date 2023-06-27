// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusSearchModelAdapter
    extends TypeAdapter<StudentPlusSearchModel> {
  @override
  final int typeId = 39;

  @override
  StudentPlusSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusSearchModel(
      id: fields[0] as String?,
      firstNameC: fields[1] as String?,
      lastNameC: fields[2] as String?,
      classC: fields[3] as String?,
      studentIDC: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusSearchModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstNameC)
      ..writeByte(2)
      ..write(obj.lastNameC)
      ..writeByte(3)
      ..write(obj.classC)
      ..writeByte(4)
      ..write(obj.studentIDC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
