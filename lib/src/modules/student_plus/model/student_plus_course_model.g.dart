// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_course_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusCourseModelAdapter
    extends TypeAdapter<StudentPlusCourseModel> {
  @override
  final int typeId = 43;

  @override
  StudentPlusCourseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusCourseModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      descriptionHeading: fields[2] as String?,
      ownerId: fields[3] as String?,
      creationTime: fields[4] as DateTime?,
      updateTime: fields[5] as DateTime?,
      enrollmentCode: fields[6] as String?,
      courseState: fields[7] as String?,
      alternateLink: fields[8] as String?,
      teacherGroupEmail: fields[9] as String?,
      courseGroupEmail: fields[10] as String?,
      teacherFolder: fields[11] as TeacherFolder?,
      guardiansEnabled: fields[12] as bool?,
      calendarId: fields[13] as String?,
      room: fields[15] as String?,
      section: fields[14] as String?,
      studentUserId: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusCourseModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.descriptionHeading)
      ..writeByte(3)
      ..write(obj.ownerId)
      ..writeByte(4)
      ..write(obj.creationTime)
      ..writeByte(5)
      ..write(obj.updateTime)
      ..writeByte(6)
      ..write(obj.enrollmentCode)
      ..writeByte(7)
      ..write(obj.courseState)
      ..writeByte(8)
      ..write(obj.alternateLink)
      ..writeByte(9)
      ..write(obj.teacherGroupEmail)
      ..writeByte(10)
      ..write(obj.courseGroupEmail)
      ..writeByte(11)
      ..write(obj.teacherFolder)
      ..writeByte(12)
      ..write(obj.guardiansEnabled)
      ..writeByte(13)
      ..write(obj.calendarId)
      ..writeByte(14)
      ..write(obj.section)
      ..writeByte(15)
      ..write(obj.room)
      ..writeByte(16)
      ..write(obj.studentUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusCourseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
