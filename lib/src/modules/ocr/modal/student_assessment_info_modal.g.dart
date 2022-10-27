// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_assessment_info_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAssessmentInfoAdapter extends TypeAdapter<StudentAssessmentInfo> {
  @override
  final int typeId = 21;

  @override
  StudentAssessmentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentAssessmentInfo(
      studentName: fields[0] as String?,
      studentId: fields[1] as String?,
      studentGrade: fields[2] as String?,
      pointpossible: fields[3] as String?,
      grade: fields[4] as String?,
      subject: fields[5] as String?,
      learningStandard: fields[6] as String?,
      subLearningStandard: fields[7] as String?,
      scoringRubric: fields[8] as String?,
      customRubricImage: fields[9] as String?,
      assessmentImage: fields[10] as String?,
      className: fields[11] as String?,
      questionImgUrl: fields[12] as String?,
      isSavedOnDashBoard: fields[13] as bool?,
      assessmentImgPath: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentAssessmentInfo obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.studentName)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.studentGrade)
      ..writeByte(3)
      ..write(obj.pointpossible)
      ..writeByte(4)
      ..write(obj.grade)
      ..writeByte(5)
      ..write(obj.subject)
      ..writeByte(6)
      ..write(obj.learningStandard)
      ..writeByte(7)
      ..write(obj.subLearningStandard)
      ..writeByte(8)
      ..write(obj.scoringRubric)
      ..writeByte(9)
      ..write(obj.customRubricImage)
      ..writeByte(10)
      ..write(obj.assessmentImage)
      ..writeByte(11)
      ..write(obj.className)
      ..writeByte(12)
      ..write(obj.questionImgUrl)
      ..writeByte(13)
      ..write(obj.isSavedOnDashBoard)
      ..writeByte(14)
      ..write(obj.assessmentImgPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAssessmentInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
