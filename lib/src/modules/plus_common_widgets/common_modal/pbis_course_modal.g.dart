// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pbis_course_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassroomCourseAdapter extends TypeAdapter<ClassroomCourse> {
  @override
  final int typeId = 33;

  @override
  ClassroomCourse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassroomCourse(
      id: fields[0] as String?,
      name: fields[1] as String?,
      descriptionHeading: fields[2] as String?,
      ownerId: fields[3] as String?,
      enrollmentCode: fields[4] as String?,
      courseState: fields[5] as String?,
      students: (fields[6] as List?)?.cast<ClassroomStudents>(),
      courseWorkId: fields[7] as String?,
      assessmentCId: fields[8] as String?,
      courseWorkURL: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassroomCourse obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.descriptionHeading)
      ..writeByte(3)
      ..write(obj.ownerId)
      ..writeByte(4)
      ..write(obj.enrollmentCode)
      ..writeByte(5)
      ..write(obj.courseState)
      ..writeByte(6)
      ..write(obj.students)
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
      other is ClassroomCourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassroomStudentsAdapter extends TypeAdapter<ClassroomStudents> {
  @override
  final int typeId = 34;

  @override
  ClassroomStudents read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassroomStudents(
      profile: fields[0] as ClassroomProfile?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassroomStudents obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.profile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomStudentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassroomProfileAdapter extends TypeAdapter<ClassroomProfile> {
  @override
  final int typeId = 35;

  @override
  ClassroomProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassroomProfile(
      id: fields[0] as String?,
      name: fields[1] as ClassroomProfileName?,
      emailAddress: fields[2] as String?,
      photoUrl: fields[3] as String?,
      permissions: (fields[4] as List?)?.cast<ClassroomPermissions>(),
      engaged: fields[5] as int?,
      niceWork: fields[6] as int?,
      helpful: fields[7] as int?,
      courseName: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassroomProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emailAddress)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.permissions)
      ..writeByte(5)
      ..write(obj.engaged)
      ..writeByte(6)
      ..write(obj.niceWork)
      ..writeByte(7)
      ..write(obj.helpful)
      ..writeByte(8)
      ..write(obj.courseName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassroomProfileNameAdapter extends TypeAdapter<ClassroomProfileName> {
  @override
  final int typeId = 36;

  @override
  ClassroomProfileName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassroomProfileName(
      givenName: fields[0] as String?,
      familyName: fields[1] as String?,
      fullName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassroomProfileName obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.givenName)
      ..writeByte(1)
      ..write(obj.familyName)
      ..writeByte(2)
      ..write(obj.fullName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomProfileNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassroomPermissionsAdapter extends TypeAdapter<ClassroomPermissions> {
  @override
  final int typeId = 37;

  @override
  ClassroomPermissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassroomPermissions(
      permission: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassroomPermissions obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.permission);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomPermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
