// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plus_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentPlusDetailsModelAdapter
    extends TypeAdapter<StudentPlusDetailsModel> {
  @override
  final int typeId = 31;

  @override
  StudentPlusDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentPlusDetailsModel(
      firstNameC: fields[0] as String?,
      gradeC: fields[1] as String?,
      lastNameC: fields[2] as String?,
      parentPhoneC: fields[3] as String?,
      schoolC: fields[4] as String?,
      studentIdC: fields[5] as String?,
      id: fields[6] as String?,
      emailC: fields[7] as String?,
      ellC: fields[8] as String?,
      ellProficiencyC: fields[9] as String?,
      classC: fields[10] as String?,
      iepProgramC: fields[11] as String?,
      genderFullC: fields[12] as String?,
      dobC: fields[13] as String?,
      nysElaScore2022C: fields[21] as String?,
      nysMathScore2022C: fields[22] as String?,
      nysElaScore2021C: fields[19] as String?,
      nysMathScore2021C: fields[20] as String?,
      nysElaScore2019C: fields[17] as String?,
      nysMathScore2019C: fields[18] as String?,
      nysMathPredictionC: fields[23] as String?,
      nysElaPredictionC: fields[24] as String?,
      ELACurrentSyBOY: fields[34] as String?,
      ELACurrentSyBOYPercentile: fields[38] as String?,
      ELACurrentSyEOY: fields[36] as String?,
      ELACurrentSyEOYPercentile: fields[40] as String?,
      ELACurrentSyMOY: fields[35] as String?,
      ELACurrentSyMOYPercentile: fields[39] as String?,
      ELAPreviousSyEOY: fields[33] as String?,
      ELAPreviousSyEOYPercentile: fields[37] as String?,
      ethnicityNameC: fields[16] as String?,
      iepYesNoC: fields[14] as String?,
      mathCurrentSyBOY: fields[26] as String?,
      mathCurrentSyBOYPercentile: fields[30] as String?,
      mathCurrentSyEOY: fields[28] as String?,
      mathCurrentSyEOYPercentile: fields[32] as String?,
      mathCurrentSyMOY: fields[27] as String?,
      mathCurrentSyMOYPercentile: fields[31] as String?,
      mathPreviousSyEOY: fields[25] as String?,
      mathPreviousSyEOYPercentile: fields[29] as String?,
      teacherProperC: fields[15] as String?,
      mathCurrentBOYOverallRelativePlace: fields[42] as String?,
      mathCurrentEOYOverallRelativePlace: fields[44] as String?,
      mathCurrentMOYOverallRelativePlace: fields[43] as String?,
      mathPreviousEOYOverallRelPlace: fields[41] as String?,
      ELACurrentBOYOverallRelativePlace: fields[46] as String?,
      ELACurrentEOYOverallRelativePlace: fields[48] as String?,
      ELACurrentMOYOverallRelativePlace: fields[47] as String?,
      ELAPreviousEOYOverallRelPlace: fields[45] as String?,
      currentAttendance: fields[49] as String?,
      age: fields[50] as String?,
      grade19_20: fields[51] as String?,
      grade20_21: fields[52] as String?,
      grade21_22: fields[53] as String?,
      studentPhoto: fields[54] as String?,
      studentGooglePresentationUrl: fields[55] as String?,
      studentGooglePresentationId: fields[56] as String?,
      MAPELACurrentSyBOY: fields[66] as String?,
      MAPELACurrentSyBOYPercentile: fields[70] as String?,
      MAPELACurrentSyEOY: fields[68] as String?,
      MAPELACurrentSyEOYPercentile: fields[72] as String?,
      MAPELACurrentSyMOY: fields[67] as String?,
      MAPELACurrentSyMOYPercentile: fields[71] as String?,
      MAPELAPreviousSyEOY: fields[65] as String?,
      MAPELAPreviousSyEOYPercentile: fields[69] as String?,
      MAPmathCurrentSyBOY: fields[58] as String?,
      MAPmathCurrentSyBOYPercentile: fields[62] as String?,
      MAPmathCurrentSyEOY: fields[60] as String?,
      MAPmathCurrentSyEOYPercentile: fields[64] as String?,
      MAPmathCurrentSyMOY: fields[59] as String?,
      MAPmathCurrentSyMOYPercentile: fields[63] as String?,
      MAPmathPreviousSyEOY: fields[57] as String?,
      MAPmathPreviousSyEOYPercentile: fields[61] as String?,
      studentClassroomCourseId: fields[73] as String?,
      nysElaScore2023C: fields[75] as String?,
      nysMathScore2023C: fields[76] as String?,
      grade22_23: fields[77] as String?,
      sex: fields[78] as String?,
      studentClassroomId: fields[74] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusDetailsModel obj) {
    writer
      ..writeByte(79)
      ..writeByte(0)
      ..write(obj.firstNameC)
      ..writeByte(1)
      ..write(obj.gradeC)
      ..writeByte(2)
      ..write(obj.lastNameC)
      ..writeByte(3)
      ..write(obj.parentPhoneC)
      ..writeByte(4)
      ..write(obj.schoolC)
      ..writeByte(5)
      ..write(obj.studentIdC)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.emailC)
      ..writeByte(8)
      ..write(obj.ellC)
      ..writeByte(9)
      ..write(obj.ellProficiencyC)
      ..writeByte(10)
      ..write(obj.classC)
      ..writeByte(11)
      ..write(obj.iepProgramC)
      ..writeByte(12)
      ..write(obj.genderFullC)
      ..writeByte(13)
      ..write(obj.dobC)
      ..writeByte(14)
      ..write(obj.iepYesNoC)
      ..writeByte(15)
      ..write(obj.teacherProperC)
      ..writeByte(16)
      ..write(obj.ethnicityNameC)
      ..writeByte(17)
      ..write(obj.nysElaScore2019C)
      ..writeByte(18)
      ..write(obj.nysMathScore2019C)
      ..writeByte(19)
      ..write(obj.nysElaScore2021C)
      ..writeByte(20)
      ..write(obj.nysMathScore2021C)
      ..writeByte(21)
      ..write(obj.nysElaScore2022C)
      ..writeByte(22)
      ..write(obj.nysMathScore2022C)
      ..writeByte(23)
      ..write(obj.nysMathPredictionC)
      ..writeByte(24)
      ..write(obj.nysElaPredictionC)
      ..writeByte(25)
      ..write(obj.mathPreviousSyEOY)
      ..writeByte(26)
      ..write(obj.mathCurrentSyBOY)
      ..writeByte(27)
      ..write(obj.mathCurrentSyMOY)
      ..writeByte(28)
      ..write(obj.mathCurrentSyEOY)
      ..writeByte(29)
      ..write(obj.mathPreviousSyEOYPercentile)
      ..writeByte(30)
      ..write(obj.mathCurrentSyBOYPercentile)
      ..writeByte(31)
      ..write(obj.mathCurrentSyMOYPercentile)
      ..writeByte(32)
      ..write(obj.mathCurrentSyEOYPercentile)
      ..writeByte(33)
      ..write(obj.ELAPreviousSyEOY)
      ..writeByte(34)
      ..write(obj.ELACurrentSyBOY)
      ..writeByte(35)
      ..write(obj.ELACurrentSyMOY)
      ..writeByte(36)
      ..write(obj.ELACurrentSyEOY)
      ..writeByte(37)
      ..write(obj.ELAPreviousSyEOYPercentile)
      ..writeByte(38)
      ..write(obj.ELACurrentSyBOYPercentile)
      ..writeByte(39)
      ..write(obj.ELACurrentSyMOYPercentile)
      ..writeByte(40)
      ..write(obj.ELACurrentSyEOYPercentile)
      ..writeByte(41)
      ..write(obj.mathPreviousEOYOverallRelPlace)
      ..writeByte(42)
      ..write(obj.mathCurrentBOYOverallRelativePlace)
      ..writeByte(43)
      ..write(obj.mathCurrentMOYOverallRelativePlace)
      ..writeByte(44)
      ..write(obj.mathCurrentEOYOverallRelativePlace)
      ..writeByte(45)
      ..write(obj.ELAPreviousEOYOverallRelPlace)
      ..writeByte(46)
      ..write(obj.ELACurrentBOYOverallRelativePlace)
      ..writeByte(47)
      ..write(obj.ELACurrentMOYOverallRelativePlace)
      ..writeByte(48)
      ..write(obj.ELACurrentEOYOverallRelativePlace)
      ..writeByte(49)
      ..write(obj.currentAttendance)
      ..writeByte(50)
      ..write(obj.age)
      ..writeByte(51)
      ..write(obj.grade19_20)
      ..writeByte(52)
      ..write(obj.grade20_21)
      ..writeByte(53)
      ..write(obj.grade21_22)
      ..writeByte(54)
      ..write(obj.studentPhoto)
      ..writeByte(55)
      ..write(obj.studentGooglePresentationUrl)
      ..writeByte(56)
      ..write(obj.studentGooglePresentationId)
      ..writeByte(57)
      ..write(obj.MAPmathPreviousSyEOY)
      ..writeByte(58)
      ..write(obj.MAPmathCurrentSyBOY)
      ..writeByte(59)
      ..write(obj.MAPmathCurrentSyMOY)
      ..writeByte(60)
      ..write(obj.MAPmathCurrentSyEOY)
      ..writeByte(61)
      ..write(obj.MAPmathPreviousSyEOYPercentile)
      ..writeByte(62)
      ..write(obj.MAPmathCurrentSyBOYPercentile)
      ..writeByte(63)
      ..write(obj.MAPmathCurrentSyMOYPercentile)
      ..writeByte(64)
      ..write(obj.MAPmathCurrentSyEOYPercentile)
      ..writeByte(65)
      ..write(obj.MAPELAPreviousSyEOY)
      ..writeByte(66)
      ..write(obj.MAPELACurrentSyBOY)
      ..writeByte(67)
      ..write(obj.MAPELACurrentSyMOY)
      ..writeByte(68)
      ..write(obj.MAPELACurrentSyEOY)
      ..writeByte(69)
      ..write(obj.MAPELAPreviousSyEOYPercentile)
      ..writeByte(70)
      ..write(obj.MAPELACurrentSyBOYPercentile)
      ..writeByte(71)
      ..write(obj.MAPELACurrentSyMOYPercentile)
      ..writeByte(72)
      ..write(obj.MAPELACurrentSyEOYPercentile)
      ..writeByte(73)
      ..write(obj.studentClassroomCourseId)
      ..writeByte(74)
      ..write(obj.studentClassroomId)
      ..writeByte(75)
      ..write(obj.nysElaScore2023C)
      ..writeByte(76)
      ..write(obj.nysMathScore2023C)
      ..writeByte(77)
      ..write(obj.grade22_23)
      ..writeByte(78)
      ..write(obj.sex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentPlusDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
