// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_grades_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusGradeModelAdapter extends TypeAdapter<StudentPlusGradeModel> {
  @override
  final int typeId = 42;

  @override
  StudentPlusGradeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusGradeModel(
      id: fields[0] as String?,
      academicYearC: fields[1] as String?,
      dbnC: fields[2] as String?,
      gradeC: fields[3] as String?,
      markTypeC: fields[4] as String?,
      markingPeriodC: fields[5] as String?,
      officialClassC: fields[6] as String?,
      osisC: fields[7] as String?,
      ownerId: fields[8] as String?,
      resultC: fields[9] as String?,
      schoolSubjectC: fields[10] as String?,
      sectionIdC: fields[11] as String?,
      studentC: fields[12] as String?,
      studentNameC: fields[13] as String?,
      subjectC: fields[14] as String?,
      name: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusGradeModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.academicYearC)
      ..writeByte(2)
      ..write(obj.dbnC)
      ..writeByte(3)
      ..write(obj.gradeC)
      ..writeByte(4)
      ..write(obj.markTypeC)
      ..writeByte(5)
      ..write(obj.markingPeriodC)
      ..writeByte(6)
      ..write(obj.officialClassC)
      ..writeByte(7)
      ..write(obj.osisC)
      ..writeByte(8)
      ..write(obj.ownerId)
      ..writeByte(9)
      ..write(obj.resultC)
      ..writeByte(10)
      ..write(obj.schoolSubjectC)
      ..writeByte(11)
      ..write(obj.sectionIdC)
      ..writeByte(12)
      ..write(obj.studentC)
      ..writeByte(13)
      ..write(obj.studentNameC)
      ..writeByte(14)
      ..write(obj.subjectC)
      ..writeByte(15)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusGradeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
