// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_classroom_courses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoogleClassroomCoursesAdapter
    extends TypeAdapter<GoogleClassroomCourses> {
  @override
  final int typeId = 9;

  @override
  GoogleClassroomCourses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoogleClassroomCourses(
      courseId: fields[0] as String?,
      name: fields[1] as String?,
      section: fields[2] as String?,
      descriptionHeading: fields[3] as String?,
      room: fields[4] as String?,
      studentList: (fields[5] as List?)?.cast<dynamic>(),
      enrollmentCode: fields[6] as String?,
      courseWorkId: fields[7] as String?,
      assessmentCId: fields[8] as String?,
      courseWorkURL: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GoogleClassroomCourses obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.section)
      ..writeByte(3)
      ..write(obj.descriptionHeading)
      ..writeByte(4)
      ..write(obj.room)
      ..writeByte(5)
      ..write(obj.studentList)
      ..writeByte(6)
      ..write(obj.enrollmentCode)
      ..writeByte(7)
      ..write(obj.courseWorkId)
      ..writeByte(8)
      ..write(obj.assessmentCId)
      ..writeByte(9)
      ..write(obj.courseWorkURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoogleClassroomCoursesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
