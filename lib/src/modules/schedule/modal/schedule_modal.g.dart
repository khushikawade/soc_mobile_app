// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 23;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule(
      id: fields[0] as String?,
      name: fields[1] as String?,
      osisC: fields[2] as String?,
      studentNameC: fields[3] as String?,
      gradeLevelC: fields[4] as String?,
      classC: fields[5] as String?,
      monRoomC: fields[6] as String?,
      tuesRoomC: fields[7] as String?,
      wedRoomC: fields[8] as String?,
      thursRoomC: fields[9] as String?,
      friRoomC: fields[10] as String?,
      monPeriodC: fields[11] as String?,
      tuesPeriodC: fields[12] as String?,
      wedPeriodC: fields[13] as String?,
      thursPeriodC: fields[14] as String?,
      friPeriodC: fields[15] as String?,
      mondaySubjectC: fields[16] as String?,
      tuesdaySubjectC: fields[17] as String?,
      wednesdaySubjectC: fields[18] as String?,
      thursdaySubjectC: fields[19] as String?,
      fridaySubjectC: fields[20] as String?,
      monTeacherC: fields[21] as String?,
      tuesTeacherC: fields[22] as String?,
      wedTeacherC: fields[23] as String?,
      thursTeacherC: fields[24] as String?,
      friTeacherC: fields[25] as String?,
      studentEmailC: fields[26] as String?,
      mondayC: fields[27] as String?,
      tuesdayC: fields[28] as String?,
      wednesdayC: fields[29] as String?,
      thursdayC: fields[30] as String?,
      fridayC: fields[31] as String?,
      scheduleC: fields[32] as String?,
      monSubjAbbrC: fields[33] as String?,
      tuesSubjAbbrC: fields[34] as String?,
      wedSubjAbbrC: fields[35] as String?,
      thursSubjAbbrC: fields[36] as String?,
      friSubjAbbrC: fields[37] as String?,
      monHexCodeC: fields[38] as String?,
      tuesHexCodeC: fields[39] as String?,
      wedHexCodeC: fields[40] as String?,
      thursHexCodeC: fields[41] as String?,
      friHexCodeC: fields[42] as String?,
      mondayPeriodTimeC: fields[43] as String?,
      tuesdayPeriodTimeC: fields[44] as String?,
      wednesdayPeriodTimeC: fields[45] as String?,
      thursdayPeriodTimeC: fields[46] as String?,
      fridayPeriodTimeC: fields[47] as String?,
      schoolC: fields[48] as String?,
      schoolYearC: fields[49] as String?,
      period1StartTimeC: fields[50] as String?,
      period2StartTimeC: fields[51] as String?,
      period3StartTimeC: fields[52] as String?,
      period5StartTimeC: fields[53] as String?,
      period6StartTimeC: fields[54] as String?,
      period7StartTimeC: fields[55] as String?,
      period8StartTimeC: fields[56] as String?,
      period4StartTimeC: fields[57] as String?,
      scheduleTitleC: fields[58] as String?,
      period1EndTimeC: fields[59] as String?,
      period2EndTimeC: fields[60] as String?,
      period3EndTimeC: fields[61] as String?,
      period4EndTimeC: fields[62] as String?,
      period5EndTimeC: fields[63] as String?,
      period6EndTimeC: fields[64] as String?,
      period7EndTimeC: fields[65] as String?,
      scheduleBoDatesC: fields[66] as String?,
      period0EndTimeC: fields[68] as String?,
      period0StartTimeC: fields[67] as String?,
      period8EndTimeC: fields[69] as String?,
      period9StartTimeC: fields[70] as String?,
      period9EndTimeC: fields[71] as String?,
      period10StartTimeC: fields[72] as String?,
      period10EndTimeC: fields[73] as String?,
      scheduleStartDatec: fields[75] as String?,
      scheduleEndDatec: fields[74] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(76)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.osisC)
      ..writeByte(3)
      ..write(obj.studentNameC)
      ..writeByte(4)
      ..write(obj.gradeLevelC)
      ..writeByte(5)
      ..write(obj.classC)
      ..writeByte(6)
      ..write(obj.monRoomC)
      ..writeByte(7)
      ..write(obj.tuesRoomC)
      ..writeByte(8)
      ..write(obj.wedRoomC)
      ..writeByte(9)
      ..write(obj.thursRoomC)
      ..writeByte(10)
      ..write(obj.friRoomC)
      ..writeByte(11)
      ..write(obj.monPeriodC)
      ..writeByte(12)
      ..write(obj.tuesPeriodC)
      ..writeByte(13)
      ..write(obj.wedPeriodC)
      ..writeByte(14)
      ..write(obj.thursPeriodC)
      ..writeByte(15)
      ..write(obj.friPeriodC)
      ..writeByte(16)
      ..write(obj.mondaySubjectC)
      ..writeByte(17)
      ..write(obj.tuesdaySubjectC)
      ..writeByte(18)
      ..write(obj.wednesdaySubjectC)
      ..writeByte(19)
      ..write(obj.thursdaySubjectC)
      ..writeByte(20)
      ..write(obj.fridaySubjectC)
      ..writeByte(21)
      ..write(obj.monTeacherC)
      ..writeByte(22)
      ..write(obj.tuesTeacherC)
      ..writeByte(23)
      ..write(obj.wedTeacherC)
      ..writeByte(24)
      ..write(obj.thursTeacherC)
      ..writeByte(25)
      ..write(obj.friTeacherC)
      ..writeByte(26)
      ..write(obj.studentEmailC)
      ..writeByte(27)
      ..write(obj.mondayC)
      ..writeByte(28)
      ..write(obj.tuesdayC)
      ..writeByte(29)
      ..write(obj.wednesdayC)
      ..writeByte(30)
      ..write(obj.thursdayC)
      ..writeByte(31)
      ..write(obj.fridayC)
      ..writeByte(32)
      ..write(obj.scheduleC)
      ..writeByte(33)
      ..write(obj.monSubjAbbrC)
      ..writeByte(34)
      ..write(obj.tuesSubjAbbrC)
      ..writeByte(35)
      ..write(obj.wedSubjAbbrC)
      ..writeByte(36)
      ..write(obj.thursSubjAbbrC)
      ..writeByte(37)
      ..write(obj.friSubjAbbrC)
      ..writeByte(38)
      ..write(obj.monHexCodeC)
      ..writeByte(39)
      ..write(obj.tuesHexCodeC)
      ..writeByte(40)
      ..write(obj.wedHexCodeC)
      ..writeByte(41)
      ..write(obj.thursHexCodeC)
      ..writeByte(42)
      ..write(obj.friHexCodeC)
      ..writeByte(43)
      ..write(obj.mondayPeriodTimeC)
      ..writeByte(44)
      ..write(obj.tuesdayPeriodTimeC)
      ..writeByte(45)
      ..write(obj.wednesdayPeriodTimeC)
      ..writeByte(46)
      ..write(obj.thursdayPeriodTimeC)
      ..writeByte(47)
      ..write(obj.fridayPeriodTimeC)
      ..writeByte(48)
      ..write(obj.schoolC)
      ..writeByte(49)
      ..write(obj.schoolYearC)
      ..writeByte(50)
      ..write(obj.period1StartTimeC)
      ..writeByte(51)
      ..write(obj.period2StartTimeC)
      ..writeByte(52)
      ..write(obj.period3StartTimeC)
      ..writeByte(53)
      ..write(obj.period5StartTimeC)
      ..writeByte(54)
      ..write(obj.period6StartTimeC)
      ..writeByte(55)
      ..write(obj.period7StartTimeC)
      ..writeByte(56)
      ..write(obj.period8StartTimeC)
      ..writeByte(57)
      ..write(obj.period4StartTimeC)
      ..writeByte(58)
      ..write(obj.scheduleTitleC)
      ..writeByte(59)
      ..write(obj.period1EndTimeC)
      ..writeByte(60)
      ..write(obj.period2EndTimeC)
      ..writeByte(61)
      ..write(obj.period3EndTimeC)
      ..writeByte(62)
      ..write(obj.period4EndTimeC)
      ..writeByte(63)
      ..write(obj.period5EndTimeC)
      ..writeByte(64)
      ..write(obj.period6EndTimeC)
      ..writeByte(65)
      ..write(obj.period7EndTimeC)
      ..writeByte(66)
      ..write(obj.scheduleBoDatesC)
      ..writeByte(67)
      ..write(obj.period0StartTimeC)
      ..writeByte(68)
      ..write(obj.period0EndTimeC)
      ..writeByte(69)
      ..write(obj.period8EndTimeC)
      ..writeByte(70)
      ..write(obj.period9StartTimeC)
      ..writeByte(71)
      ..write(obj.period9EndTimeC)
      ..writeByte(72)
      ..write(obj.period10StartTimeC)
      ..writeByte(73)
      ..write(obj.period10EndTimeC)
      ..writeByte(74)
      ..write(obj.scheduleEndDatec)
      ..writeByte(75)
      ..write(obj.scheduleStartDatec);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
