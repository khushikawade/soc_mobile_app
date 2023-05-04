// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_details_standard_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentDetailsModalAdapter extends TypeAdapter<StudentDetailsModal> {
  @override
  final int typeId = 30;

  @override
  StudentDetailsModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentDetailsModal(
      email: fields[0] as String?,
      name: fields[1] as String?,
      studentId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentDetailsModal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.studentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentDetailsModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
