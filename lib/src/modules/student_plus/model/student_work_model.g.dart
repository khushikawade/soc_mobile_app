// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_work_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusWorkModelAdapter extends TypeAdapter<StudentPlusWorkModel> {
  @override
  final int typeId = 32;

  @override
  StudentPlusWorkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusWorkModel(
      assessmentId: fields[0] as String?,
      nameC: fields[1] as String?,
      rubricC: fields[2] as String?,
      dateC: fields[3] as String?,
      schoolC: fields[4] as String?,
      teacherEmail: fields[5] as String?,
      studentC: fields[6] as String?,
      studentNameC: fields[7] as String?,
      resultC: fields[8] as String?,
      assessmentImageC: fields[9] as String?,
      assessmentQueImageC: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusWorkModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.assessmentId)
      ..writeByte(1)
      ..write(obj.nameC)
      ..writeByte(2)
      ..write(obj.rubricC)
      ..writeByte(3)
      ..write(obj.dateC)
      ..writeByte(4)
      ..write(obj.schoolC)
      ..writeByte(5)
      ..write(obj.teacherEmail)
      ..writeByte(6)
      ..write(obj.studentC)
      ..writeByte(7)
      ..write(obj.studentNameC)
      ..writeByte(8)
      ..write(obj.resultC)
      ..writeByte(9)
      ..write(obj.assessmentImageC)
      ..writeByte(10)
      ..write(obj.assessmentQueImageC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusWorkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
