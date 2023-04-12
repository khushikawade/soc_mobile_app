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
      dateOfBirthC: fields[0] as dynamic,
      dbnC: fields[1] as String?,
      firstNameC: fields[2] as String?,
      gradeC: fields[3] as String?,
      lastNameC: fields[4] as String?,
      messageC: fields[5] as dynamic,
      parentPhoneC: fields[6] as String?,
      schoolC: fields[7] as String?,
      schoolYearC: fields[8] as dynamic,
      studentIdC: fields[9] as String?,
      id: fields[10] as String?,
      isDeleted: fields[11] as String?,
      createdByGradedC: fields[12] as String?,
      teacherAddedC: fields[13] as String?,
      emailC: fields[14] as dynamic,
      dateOfBirthFormulaC: fields[15] as String?,
      grC: fields[16] as String?,
      ellC: fields[17] as String?,
      ellProficiencyC: fields[18] as String?,
      ethnicityCodeC: fields[19] as String?,
      genderC: fields[20] as String?,
      iepC: fields[21] as String?,
      nysElaScore2022C: fields[22] as String?,
      classC: fields[23] as String?,
      admittanceDateC: fields[24] as dynamic,
      hispanicCodeC: fields[25] as String?,
      sexC: fields[26] as String?,
      accountIdC: fields[27] as String?,
      locC: fields[28] as String?,
      teacherC: fields[29] as String?,
      academicYearC: fields[30] as String?,
      dobResiC: fields[31] as String?,
      grade1920C: fields[32] as String?,
      grade2021C: fields[33] as String?,
      grade2122C: fields[34] as String?,
      iReadyMathMoyOverallPlacementC: fields[35] as String?,
      firstNameInitcapC: fields[36] as String?,
      lastNameInitcapC: fields[37] as String?,
      ethnicityNameC: fields[38] as String?,
      hispanicC: fields[39] as String?,
      sexNameC: fields[40] as String?,
      housingStatusNameC: fields[41] as dynamic,
      temporaryResidencyFlagC: fields[42] as String?,
      iepTextC: fields[43] as String?,
      teacherProperC: fields[44] as String?,
      iepStatusC: fields[45] as String?,
      lepFlagTextC: fields[46] as String?,
      ellAdmissionDateC: fields[47] as dynamic,
      dobC: fields[48] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentPlusDetailsModel obj) {
    writer
      ..writeByte(49)
      ..writeByte(0)
      ..write(obj.dateOfBirthC)
      ..writeByte(1)
      ..write(obj.dbnC)
      ..writeByte(2)
      ..write(obj.firstNameC)
      ..writeByte(3)
      ..write(obj.gradeC)
      ..writeByte(4)
      ..write(obj.lastNameC)
      ..writeByte(5)
      ..write(obj.messageC)
      ..writeByte(6)
      ..write(obj.parentPhoneC)
      ..writeByte(7)
      ..write(obj.schoolC)
      ..writeByte(8)
      ..write(obj.schoolYearC)
      ..writeByte(9)
      ..write(obj.studentIdC)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.isDeleted)
      ..writeByte(12)
      ..write(obj.createdByGradedC)
      ..writeByte(13)
      ..write(obj.teacherAddedC)
      ..writeByte(14)
      ..write(obj.emailC)
      ..writeByte(15)
      ..write(obj.dateOfBirthFormulaC)
      ..writeByte(16)
      ..write(obj.grC)
      ..writeByte(17)
      ..write(obj.ellC)
      ..writeByte(18)
      ..write(obj.ellProficiencyC)
      ..writeByte(19)
      ..write(obj.ethnicityCodeC)
      ..writeByte(20)
      ..write(obj.genderC)
      ..writeByte(21)
      ..write(obj.iepC)
      ..writeByte(22)
      ..write(obj.nysElaScore2022C)
      ..writeByte(23)
      ..write(obj.classC)
      ..writeByte(24)
      ..write(obj.admittanceDateC)
      ..writeByte(25)
      ..write(obj.hispanicCodeC)
      ..writeByte(26)
      ..write(obj.sexC)
      ..writeByte(27)
      ..write(obj.accountIdC)
      ..writeByte(28)
      ..write(obj.locC)
      ..writeByte(29)
      ..write(obj.teacherC)
      ..writeByte(30)
      ..write(obj.academicYearC)
      ..writeByte(31)
      ..write(obj.dobResiC)
      ..writeByte(32)
      ..write(obj.grade1920C)
      ..writeByte(33)
      ..write(obj.grade2021C)
      ..writeByte(34)
      ..write(obj.grade2122C)
      ..writeByte(35)
      ..write(obj.iReadyMathMoyOverallPlacementC)
      ..writeByte(36)
      ..write(obj.firstNameInitcapC)
      ..writeByte(37)
      ..write(obj.lastNameInitcapC)
      ..writeByte(38)
      ..write(obj.ethnicityNameC)
      ..writeByte(39)
      ..write(obj.hispanicC)
      ..writeByte(40)
      ..write(obj.sexNameC)
      ..writeByte(41)
      ..write(obj.housingStatusNameC)
      ..writeByte(42)
      ..write(obj.temporaryResidencyFlagC)
      ..writeByte(43)
      ..write(obj.iepTextC)
      ..writeByte(44)
      ..write(obj.teacherProperC)
      ..writeByte(45)
      ..write(obj.iepStatusC)
      ..writeByte(46)
      ..write(obj.lepFlagTextC)
      ..writeByte(47)
      ..write(obj.ellAdmissionDateC)
      ..writeByte(48)
      ..write(obj.dobC);
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
