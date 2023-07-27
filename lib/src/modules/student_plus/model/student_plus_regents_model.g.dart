// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_regents_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentRegentsModelAdapter extends TypeAdapter<StudentRegentsModel> {
  @override
  final int typeId = 58;

  @override
  StudentRegentsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentRegentsModel(
      id: fields[0] as String?,
      academicYearC: fields[1] as String?,
      createdById: fields[2] as String?,
      examC: fields[3] as String?,
      lastModifiedById: fields[4] as String?,
      osisC: fields[5] as String?,
      ownerId: fields[6] as String?,
      name: fields[7] as String?,
      resultC: fields[8] as String?,
      studentC: fields[9] as String?,
      createdAt: fields[10] as String?,
      updatedAt: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentRegentsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.academicYearC)
      ..writeByte(2)
      ..write(obj.createdById)
      ..writeByte(3)
      ..write(obj.examC)
      ..writeByte(4)
      ..write(obj.lastModifiedById)
      ..writeByte(5)
      ..write(obj.osisC)
      ..writeByte(6)
      ..write(obj.ownerId)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.resultC)
      ..writeByte(9)
      ..write(obj.studentC)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentRegentsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
