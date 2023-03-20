// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_detail_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentDetailsAdapter extends TypeAdapter<AssessmentDetails> {
  @override
  final int typeId = 17;

  @override
  AssessmentDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentDetails(
      dateC: fields[1] as String?,
      nameC: fields[2] as String?,
      rubricC: fields[3] as String?,
      schoolC: fields[4] as String?,
      schoolYearC: fields[5] as String?,
      standardC: fields[6] as String?,
      subjectC: fields[7] as String?,
      teacherC: fields[8] as String?,
      typeC: fields[9] as String?,
      assessmentId: fields[10] as String?,
      id: fields[11] as String?,
      googlefileId: fields[12] as String?,
      sessionId: fields[13] as String?,
      teacherEmail: fields[14] as String?,
      teacherContactId: fields[15] as String?,
      createdAsPremium: fields[16] as String?,
      assessmentType: fields[17] as String?,
      classroomCourseId: fields[18] as String?,
      classroomCourseWorkId: fields[19] as String?,
    )..name = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, AssessmentDetails obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dateC)
      ..writeByte(2)
      ..write(obj.nameC)
      ..writeByte(3)
      ..write(obj.rubricC)
      ..writeByte(4)
      ..write(obj.schoolC)
      ..writeByte(5)
      ..write(obj.schoolYearC)
      ..writeByte(6)
      ..write(obj.standardC)
      ..writeByte(7)
      ..write(obj.subjectC)
      ..writeByte(8)
      ..write(obj.teacherC)
      ..writeByte(9)
      ..write(obj.typeC)
      ..writeByte(10)
      ..write(obj.assessmentId)
      ..writeByte(11)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.googlefileId)
      ..writeByte(13)
      ..write(obj.sessionId)
      ..writeByte(14)
      ..write(obj.teacherEmail)
      ..writeByte(15)
      ..write(obj.teacherContactId)
      ..writeByte(16)
      ..write(obj.createdAsPremium)
      ..writeByte(17)
      ..write(obj.assessmentType)
      ..writeByte(18)
      ..write(obj.classroomCourseId)
      ..writeByte(19)
      ..write(obj.classroomCourseWorkId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
