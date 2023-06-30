// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_course_work_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusCourseWorkModelAdapter
    extends TypeAdapter<StudentPlusCourseWorkModel> {
  @override
  final int typeId = 51;

  @override
  StudentPlusCourseWorkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusCourseWorkModel(
      courseId: fields[0] as String?,
      id: fields[1] as String?,
      title: fields[2] as String?,
      description: fields[3] as String?,
      state: fields[4] as String?,
      alternateLink: fields[5] as String?,
      creationTime: fields[6] as DateTime?,
      updateTime: fields[7] as DateTime?,
      maxPoints: fields[8] as int?,
      workType: fields[9] as String?,
      submissionModificationMode: fields[10] as String?,
      associatedWithDeveloper: fields[11] as bool?,
      creatorUserId: fields[12] as String?,
      studentWorkSubmission:
          (fields[13] as List?)?.cast<StudentWorkSubmission>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusCourseWorkModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.alternateLink)
      ..writeByte(6)
      ..write(obj.creationTime)
      ..writeByte(7)
      ..write(obj.updateTime)
      ..writeByte(8)
      ..write(obj.maxPoints)
      ..writeByte(9)
      ..write(obj.workType)
      ..writeByte(10)
      ..write(obj.submissionModificationMode)
      ..writeByte(11)
      ..write(obj.associatedWithDeveloper)
      ..writeByte(12)
      ..write(obj.creatorUserId)
      ..writeByte(13)
      ..write(obj.studentWorkSubmission);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusCourseWorkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentWorkSubmissionAdapter extends TypeAdapter<StudentWorkSubmission> {
  @override
  final int typeId = 53;

  @override
  StudentWorkSubmission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentWorkSubmission(
      courseId: fields[0] as String?,
      courseWorkId: fields[1] as String?,
      id: fields[2] as String?,
      userId: fields[3] as String?,
      creationTime: fields[4] as DateTime?,
      updateTime: fields[5] as DateTime?,
      state: fields[6] as String?,
      assignedGrade: fields[7] as int?,
      alternateLink: fields[8] as String?,
      courseWorkType: fields[9] as String?,
      assignmentSubmission: fields[10] as AssignmentSubmission?,
      associatedWithDeveloper: fields[11] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentWorkSubmission obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.courseWorkId)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.creationTime)
      ..writeByte(5)
      ..write(obj.updateTime)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.assignedGrade)
      ..writeByte(8)
      ..write(obj.alternateLink)
      ..writeByte(9)
      ..write(obj.courseWorkType)
      ..writeByte(10)
      ..write(obj.assignmentSubmission)
      ..writeByte(11)
      ..write(obj.associatedWithDeveloper);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentWorkSubmissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssignmentSubmissionAdapter extends TypeAdapter<AssignmentSubmission> {
  @override
  final int typeId = 46;

  @override
  AssignmentSubmission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentSubmission(
      attachments: (fields[0] as List?)?.cast<Attachment>(),
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentSubmission obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentSubmissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentAdapter extends TypeAdapter<Attachment> {
  @override
  final int typeId = 47;

  @override
  Attachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attachment(
      link: fields[0] as Link?,
    );
  }

  @override
  void write(BinaryWriter writer, Attachment obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkAdapter extends TypeAdapter<Link> {
  @override
  final int typeId = 52;

  @override
  Link read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Link(
      url: fields[0] as String?,
      title: fields[1] as String?,
      thumbnailUrl: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Link obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnailUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
