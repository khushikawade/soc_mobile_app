import 'package:hive/hive.dart';
part 'schedule_modal.g.dart';

@HiveType(typeId: 23)
class Schedule {
  Schedule(
      {this.id,
      // this.ownerId,
      // this.isDeleted,
      this.name,
      // this.createdDate,
      // this.createdById,
      // this.lastModifiedDate,
      // this.lastModifiedById,
      // this.systemModstamp,
      // this.lastViewedDate,
      // this.lastReferencedDate,
      // this.connectionReceivedId,
      // this.connectionSentId,
      this.osisC,
      this.studentNameC,
      this.gradeLevelC,
      this.classC,
      this.monRoomC,
      this.tuesRoomC,
      this.wedRoomC,
      this.thursRoomC,
      this.friRoomC,
      this.monPeriodC,
      this.tuesPeriodC,
      this.wedPeriodC,
      this.thursPeriodC,
      this.friPeriodC,
      this.mondaySubjectC,
      this.tuesdaySubjectC,
      this.wednesdaySubjectC,
      this.thursdaySubjectC,
      this.fridaySubjectC,
      this.monTeacherC,
      this.tuesTeacherC,
      this.wedTeacherC,
      this.thursTeacherC,
      this.friTeacherC,
      this.studentEmailC,
      this.mondayC,
      this.tuesdayC,
      this.wednesdayC,
      this.thursdayC,
      this.fridayC,
      this.scheduleC,
      this.monSubjAbbrC,
      this.tuesSubjAbbrC,
      this.wedSubjAbbrC,
      this.thursSubjAbbrC,
      this.friSubjAbbrC,
      this.monHexCodeC,
      this.tuesHexCodeC,
      this.wedHexCodeC,
      this.thursHexCodeC,
      this.friHexCodeC,
      this.mondayPeriodTimeC,
      this.tuesdayPeriodTimeC,
      this.wednesdayPeriodTimeC,
      this.thursdayPeriodTimeC,
      this.fridayPeriodTimeC,
      this.schoolC,
      this.schoolYearC,
      this.period1StartTimeC,
      this.period2StartTimeC,
      this.period3StartTimeC,
      this.period5StartTimeC,
      this.period6StartTimeC,
      this.period7StartTimeC,
      this.period8StartTimeC,
      this.period4StartTimeC,
      this.scheduleTitleC,
      this.period1EndTimeC,
      this.period2EndTimeC,
      this.period3EndTimeC,
      this.period4EndTimeC,
      this.period5EndTimeC,
      this.period6EndTimeC,
      this.period7EndTimeC,
      this.scheduleBoDatesC,
      this.period0EndTimeC,
      this.period0StartTimeC,
      this.period8EndTimeC,
      this.period9StartTimeC,
      this.period9EndTimeC,
      this.period10StartTimeC,
      this.period10EndTimeC,
      this.scheduleStartDatec,
      this.scheduleEndDatec});
  @HiveField(0)
  String? id;
  // String? ownerId;
  // String? isDeleted;
  @HiveField(1)
  String? name;
  // String? createdDate;
  // String? createdById;
  // String? lastModifiedDate;
  // String? lastModifiedById;
  // String? systemModstamp;
  // String? lastViewedDate;
  // String? lastReferencedDate;
  // dynamic connectionReceivedId;
  // dynamic connectionSentId;
  @HiveField(2)
  String? osisC;
  @HiveField(3)
  String? studentNameC;
  @HiveField(4)
  String? gradeLevelC;
  @HiveField(5)
  String? classC;
  @HiveField(6)
  String? monRoomC;
  @HiveField(7)
  String? tuesRoomC;
  @HiveField(8)
  String? wedRoomC;
  @HiveField(9)
  String? thursRoomC;
  @HiveField(10)
  String? friRoomC;
  @HiveField(11)
  String? monPeriodC;
  @HiveField(12)
  String? tuesPeriodC;
  @HiveField(13)
  String? wedPeriodC;
  @HiveField(14)
  String? thursPeriodC;
  @HiveField(15)
  String? friPeriodC;
  @HiveField(16)
  String? mondaySubjectC;
  @HiveField(17)
  String? tuesdaySubjectC;
  @HiveField(18)
  String? wednesdaySubjectC;
  @HiveField(19)
  String? thursdaySubjectC;
  @HiveField(20)
  String? fridaySubjectC;
  @HiveField(21)
  String? monTeacherC;
  @HiveField(22)
  String? tuesTeacherC;
  @HiveField(23)
  String? wedTeacherC;
  @HiveField(24)
  String? thursTeacherC;
  @HiveField(25)
  String? friTeacherC;
  @HiveField(26)
  String? studentEmailC;
  @HiveField(27)
  String? mondayC;
  @HiveField(28)
  String? tuesdayC;
  @HiveField(29)
  String? wednesdayC;
  @HiveField(30)
  String? thursdayC;
  @HiveField(31)
  String? fridayC;
  @HiveField(32)
  String? scheduleC;
  @HiveField(33)
  String? monSubjAbbrC;
  @HiveField(34)
  String? tuesSubjAbbrC;
  @HiveField(35)
  String? wedSubjAbbrC;
  @HiveField(36)
  String? thursSubjAbbrC;
  @HiveField(37)
  String? friSubjAbbrC;
  @HiveField(38)
  String? monHexCodeC;
  @HiveField(39)
  String? tuesHexCodeC;
  @HiveField(40)
  String? wedHexCodeC;
  @HiveField(41)
  String? thursHexCodeC;
  @HiveField(42)
  String? friHexCodeC;
  @HiveField(43)
  String? mondayPeriodTimeC;
  @HiveField(44)
  String? tuesdayPeriodTimeC;
  @HiveField(45)
  String? wednesdayPeriodTimeC;
  @HiveField(46)
  String? thursdayPeriodTimeC;
  @HiveField(47)
  String? fridayPeriodTimeC;
  @HiveField(48)
  String? schoolC;
  @HiveField(49)
  String? schoolYearC;
  @HiveField(50)
  String? period1StartTimeC;
  @HiveField(51)
  String? period2StartTimeC;
  @HiveField(52)
  String? period3StartTimeC;
  @HiveField(53)
  String? period5StartTimeC;
  @HiveField(54)
  String? period6StartTimeC;
  @HiveField(55)
  String? period7StartTimeC;
  @HiveField(56)
  String? period8StartTimeC;
  @HiveField(57)
  String? period4StartTimeC;
  @HiveField(58)
  String? scheduleTitleC;
  @HiveField(59)
  String? period1EndTimeC;
  @HiveField(60)
  String? period2EndTimeC;
  @HiveField(61)
  String? period3EndTimeC;
  @HiveField(62)
  String? period4EndTimeC;
  @HiveField(63)
  String? period5EndTimeC;
  @HiveField(64)
  String? period6EndTimeC;
  @HiveField(65)
  String? period7EndTimeC;
  @HiveField(66)
  String? scheduleBoDatesC;
  @HiveField(67)
  String? period0StartTimeC;
  @HiveField(68)
  String? period0EndTimeC;
  @HiveField(69)
  String? period8EndTimeC;
  @HiveField(70)
  String? period9StartTimeC;
  @HiveField(71)
  String? period9EndTimeC;
  @HiveField(72)
  String? period10StartTimeC;
  @HiveField(73)
  String? period10EndTimeC;
  @HiveField(74)
  String? scheduleEndDatec;
  @HiveField(75)
  String? scheduleStartDatec;

  factory Schedule.fromJson(Map<String?, dynamic> json) => Schedule(
        id: json["Id"] == null ? null : json["Id"],
        // ownerId: json["OwnerId"] == null ? null : json["OwnerId"],
        // isDeleted: json["IsDeleted"] == null ? null : json["IsDeleted"],
        name: json["Name"] == null ? null : json["Name"],
        // createdDate: json["CreatedDate"] == null ? null : json["CreatedDate"],
        // createdById: json["CreatedById"] == null ? null : json["CreatedById"],
        // lastModifiedDate:
        //     json["LastModifiedDate"] == null ? null : json["LastModifiedDate"],
        // lastModifiedById:
        //     json["LastModifiedById"] == null ? null : json["LastModifiedById"],
        // systemModstamp:
        //     json["SystemModstamp"] == null ? null : json["SystemModstamp"],
        // lastViewedDate:
        //     json["LastViewedDate"] == null ? null : json["LastViewedDate"],
        // lastReferencedDate: json["LastReferencedDate"] == null
        //     ? null
        //     : json["LastReferencedDate"],
        // connectionReceivedId: json["ConnectionReceivedId"],
        // connectionSentId: json["ConnectionSentId"],
        osisC: json["OSIS__c"] == null ? null : json["OSIS__c"],
        studentNameC:
            json["Student_Name__c"] == null ? null : json["Student_Name__c"],
        gradeLevelC:
            json["Grade_Level__c"] == null ? null : json["Grade_Level__c"],
        classC: json["Class__c"] == null ? null : json["Class__c"],
        monRoomC: json["Mon_Room__c"] == null ? null : json["Mon_Room__c"],
        tuesRoomC: json["Tues_Room__c"] == null ? null : json["Tues_Room__c"],
        wedRoomC: json["Wed_Room__c"] == null ? null : json["Wed_Room__c"],
        thursRoomC:
            json["Thurs_Room__c"] == null ? null : json["Thurs_Room__c"],
        friRoomC: json["Fri_Room__c"] == null ? null : json["Fri_Room__c"],
        monPeriodC:
            json["Mon_Period__c"] == null ? null : json["Mon_Period__c"],
        tuesPeriodC:
            json["Tues_Period__c"] == null ? null : json["Tues_Period__c"],
        wedPeriodC:
            json["Wed_Period__c"] == null ? null : json["Wed_Period__c"],
        thursPeriodC:
            json["Thurs_Period__c"] == null ? null : json["Thurs_Period__c"],
        friPeriodC:
            json["Fri_Period__c"] == null ? null : json["Fri_Period__c"],
        mondaySubjectC: json["Monday_Subject__c"] == null
            ? null
            : json["Monday_Subject__c"],
        tuesdaySubjectC: json["Tuesday_Subject__c"] == null
            ? null
            : json["Tuesday_Subject__c"],
        wednesdaySubjectC: json["Wednesday_Subject__c"] == null
            ? null
            : json["Wednesday_Subject__c"],
        thursdaySubjectC: json["Thursday_Subject__c"] == null
            ? null
            : json["Thursday_Subject__c"],
        fridaySubjectC: json["Friday_Subject__c"] == null
            ? null
            : json["Friday_Subject__c"],
        monTeacherC:
            json["Mon_Teacher__c"] == null ? null : json["Mon_Teacher__c"],
        tuesTeacherC:
            json["Tues_Teacher__c"] == null ? null : json["Tues_Teacher__c"],
        wedTeacherC:
            json["Wed_Teacher__c"] == null ? null : json["Wed_Teacher__c"],
        thursTeacherC:
            json["Thurs_Teacher__c"] == null ? null : json["Thurs_Teacher__c"],
        friTeacherC:
            json["Fri_Teacher__c"] == null ? null : json["Fri_Teacher__c"],
        studentEmailC:
            json["Student_Email__c"] == null ? null : json["Student_Email__c"],
        mondayC: json["Monday__c"] == null ? null : json["Monday__c"],
        tuesdayC: json["Tuesday__c"] == null ? null : json["Tuesday__c"],
        wednesdayC: json["Wednesday__c"] == null ? null : json["Wednesday__c"],
        thursdayC: json["Thursday__c"] == null ? null : json["Thursday__c"],
        fridayC: json["Friday__c"] == null ? null : json["Friday__c"],
        scheduleC: json["Schedule__c"] == null ? null : json["Schedule__c"],
        monSubjAbbrC:
            json["Mon_Subj_Abbr__c"] == null ? null : json["Mon_Subj_Abbr__c"],
        tuesSubjAbbrC: json["Tues_Subj_Abbr__c"] == null
            ? null
            : json["Tues_Subj_Abbr__c"],
        wedSubjAbbrC:
            json["Wed_Subj_Abbr__c"] == null ? null : json["Wed_Subj_Abbr__c"],
        thursSubjAbbrC: json["Thurs_Subj_Abbr__c"] == null
            ? null
            : json["Thurs_Subj_Abbr__c"],
        friSubjAbbrC:
            json["Fri_Subj_Abbr__c"] == null ? null : json["Fri_Subj_Abbr__c"],
        monHexCodeC:
            json["Mon_Hex_Code__c"] == null ? null : json["Mon_Hex_Code__c"],
        tuesHexCodeC:
            json["Tues_Hex_Code__c"] == null ? null : json["Tues_Hex_Code__c"],
        wedHexCodeC:
            json["Wed_Hex_Code__c"] == null ? null : json["Wed_Hex_Code__c"],
        thursHexCodeC: json["Thurs_Hex_Code__c"] == null
            ? null
            : json["Thurs_Hex_Code__c"],
        friHexCodeC:
            json["Fri_Hex_Code__c"] == null ? null : json["Fri_Hex_Code__c"],
        mondayPeriodTimeC: json["Monday_Period_Time__c"] == null
            ? null
            : json["Monday_Period_Time__c"],
        tuesdayPeriodTimeC: json["Tuesday_Period_Time__c"] == null
            ? null
            : json["Tuesday_Period_Time__c"],
        wednesdayPeriodTimeC: json["Wednesday_Period_Time__c"] == null
            ? null
            : json["Wednesday_Period_Time__c"],
        thursdayPeriodTimeC: json["Thursday_Period_Time__c"] == null
            ? null
            : json["Thursday_Period_Time__c"],
        fridayPeriodTimeC: json["Friday_Period_Time__c"] == null
            ? null
            : json["Friday_Period_Time__c"],
        schoolC: json["School__c"] == null ? null : json["School__c"],
        schoolYearC:
            json["School_Year__c"] == null ? null : json["School_Year__c"],
        period1StartTimeC: json["Period_1_Start_Time__c"] == null
            ? null
            : json["Period_1_Start_Time__c"],
        period2StartTimeC: json["Period_2_Start_Time__c"] == null
            ? null
            : json["Period_2_Start_Time__c"],
        period3StartTimeC: json["Period_3_Start_Time__c"] == null
            ? null
            : json["Period_3_Start_Time__c"],
        period5StartTimeC: json["Period_5_Start_Time__c"] == null
            ? null
            : json["Period_5_Start_Time__c"],
        period6StartTimeC: json["Period_6_Start_Time__c"] == null
            ? null
            : json["Period_6_Start_Time__c"],
        period7StartTimeC: json["Period_7_Start_Time__c"] == null
            ? null
            : json["Period_7_Start_Time__c"],
        period8StartTimeC: json["Period_8_Start_Time__c"] == null
            ? null
            : json["Period_8_Start_Time__c"],
        period4StartTimeC: json["Period_4_Start_Time__c"] == null
            ? null
            : json["Period_4_Start_Time__c"],
        scheduleTitleC: json["Schedule_Title__c"] == null
            ? null
            : json["Schedule_Title__c"],
        period1EndTimeC: json["Period_1_End_Time__c"] == null
            ? null
            : json["Period_1_End_Time__c"],
        period2EndTimeC: json["Period_2_End_Time__c"] == null
            ? null
            : json["Period_2_End_Time__c"],
        period3EndTimeC: json["Period_3_End_Time__c"] == null
            ? null
            : json["Period_3_End_Time__c"],
        period4EndTimeC: json["Period_4_End_Time__c"] == null
            ? null
            : json["Period_4_End_Time__c"],
        period5EndTimeC: json["Period_5_End_Time__c"] == null
            ? null
            : json["Period_5_End_Time__c"],
        period6EndTimeC: json["Period_6_End_Time__c"] == null
            ? null
            : json["Period_6_End_Time__c"],
        period7EndTimeC: json["Period_7_End_Time__c"] == null
            ? null
            : json["Period_7_End_Time__c"],
        scheduleBoDatesC: json["Schedule_BO_Dates__c"] == null
            ? null
            : json["Schedule_BO_Dates__c"],
        period0StartTimeC: json["Period_0_Start_Time__c"] == null
            ? null
            : json["Period_0_Start_Time__c"],
        period0EndTimeC: json["Period_0_End_Time__c"] == null
            ? null
            : json["Period_0_End_Time__c"],

        period8EndTimeC: json["Period_8_End_Time__c"] == null
            ? null
            : json["Period_8_End_Time__c"],

        period9StartTimeC: json["Period_9_Start_Time__c"] == null
            ? null
            : json["Period_9_Start_Time__c"],

        period9EndTimeC: json["Period_9_End_Time__c"] == null
            ? null
            : json["Period_9_End_Time__c"],

        period10EndTimeC: json["Period_10_End_Time__c"] == null
            ? null
            : json["Period_10_End_Time__c"],

        period10StartTimeC: json["Period_10_Start_Time__c"] == null
            ? null
            : json["Period_10_Start_Time__c"],
        scheduleStartDatec: json["Schedule_Start_Date__c"] == null
            ? null
            : json["Schedule_Start_Date__c"],
        scheduleEndDatec: json["Schedule_End_Date__c"] == null
            ? null
            : json["Schedule_End_Date__c"],
      );

  Map<String?, dynamic> toJson() => {
        "Id": id == null ? null : id,
        // "OwnerId": ownerId == null ? null : ownerId,
        // "IsDeleted": isDeleted == null ? null : isDeleted,
        "Name": name == null ? null : name,
        // "CreatedDate": createdDate == null ? null : createdDate,
        // "CreatedById": createdById == null ? null : createdById,
        // "LastModifiedDate": lastModifiedDate == null ? null : lastModifiedDate,
        // "LastModifiedById": lastModifiedById == null ? null : lastModifiedById,
        // "SystemModstamp": systemModstamp == null ? null : systemModstamp,
        // "LastViewedDate": lastViewedDate == null ? null : lastViewedDate,
        // "LastReferencedDate":
        //     lastReferencedDate == null ? null : lastReferencedDate,
        // "ConnectionReceivedId": connectionReceivedId,
        // "ConnectionSentId": connectionSentId,
        "OSIS__c": osisC == null ? null : osisC,
        "Student_Name__c": studentNameC == null ? null : studentNameC,
        "Grade_Level__c": gradeLevelC == null ? null : gradeLevelC,
        "Class__c": classC == null ? null : classC,
        "Mon_Room__c": monRoomC == null ? null : monRoomC,
        "Tues_Room__c": tuesRoomC == null ? null : tuesRoomC,
        "Wed_Room__c": wedRoomC == null ? null : wedRoomC,
        "Thurs_Room__c": thursRoomC == null ? null : thursRoomC,
        "Fri_Room__c": friRoomC == null ? null : friRoomC,
        "Mon_Period__c": monPeriodC == null ? null : monPeriodC,
        "Tues_Period__c": tuesPeriodC == null ? null : tuesPeriodC,
        "Wed_Period__c": wedPeriodC == null ? null : wedPeriodC,
        "Thurs_Period__c": thursPeriodC == null ? null : thursPeriodC,
        "Fri_Period__c": friPeriodC == null ? null : friPeriodC,
        "Monday_Subject__c": mondaySubjectC == null ? null : mondaySubjectC,
        "Tuesday_Subject__c": tuesdaySubjectC == null ? null : tuesdaySubjectC,
        "Wednesday_Subject__c":
            wednesdaySubjectC == null ? null : wednesdaySubjectC,
        "Thursday_Subject__c":
            thursdaySubjectC == null ? null : thursdaySubjectC,
        "Friday_Subject__c": fridaySubjectC == null ? null : fridaySubjectC,
        "Mon_Teacher__c": monTeacherC == null ? null : monTeacherC,
        "Tues_Teacher__c": tuesTeacherC == null ? null : tuesTeacherC,
        "Wed_Teacher__c": wedTeacherC == null ? null : wedTeacherC,
        "Thurs_Teacher__c": thursTeacherC == null ? null : thursTeacherC,
        "Fri_Teacher__c": friTeacherC == null ? null : friTeacherC,
        "Student_Email__c": studentEmailC == null ? null : studentEmailC,
        "Monday__c": mondayC == null ? null : mondayC,
        "Tuesday__c": tuesdayC == null ? null : tuesdayC,
        "Wednesday__c": wednesdayC == null ? null : wednesdayC,
        "Thursday__c": thursdayC == null ? null : thursdayC,
        "Friday__c": fridayC == null ? null : fridayC,
        "Schedule__c": scheduleC == null ? null : scheduleC,
        "Mon_Subj_Abbr__c": monSubjAbbrC == null ? null : monSubjAbbrC,
        "Tues_Subj_Abbr__c": tuesSubjAbbrC == null ? null : tuesSubjAbbrC,
        "Wed_Subj_Abbr__c": wedSubjAbbrC == null ? null : wedSubjAbbrC,
        "Thurs_Subj_Abbr__c": thursSubjAbbrC == null ? null : thursSubjAbbrC,
        "Fri_Subj_Abbr__c": friSubjAbbrC == null ? null : friSubjAbbrC,
        "Mon_Hex_Code__c": monHexCodeC == null ? null : monHexCodeC,
        "Tues_Hex_Code__c": tuesHexCodeC == null ? null : tuesHexCodeC,
        "Wed_Hex_Code__c": wedHexCodeC == null ? null : wedHexCodeC,
        "Thurs_Hex_Code__c": thursHexCodeC == null ? null : thursHexCodeC,
        "Fri_Hex_Code__c": friHexCodeC == null ? null : friHexCodeC,
        "Monday_Period_Time__c":
            mondayPeriodTimeC == null ? null : mondayPeriodTimeC,
        "Tuesday_Period_Time__c":
            tuesdayPeriodTimeC == null ? null : tuesdayPeriodTimeC,
        "Wednesday_Period_Time__c":
            wednesdayPeriodTimeC == null ? null : wednesdayPeriodTimeC,
        "Thursday_Period_Time__c":
            thursdayPeriodTimeC == null ? null : thursdayPeriodTimeC,
        "Friday_Period_Time__c":
            fridayPeriodTimeC == null ? null : fridayPeriodTimeC,
        "School__c": schoolC == null ? null : schoolC,
        "School_Year__c": schoolYearC == null ? null : schoolYearC,
        "Period_1_Start_Time__c":
            period1StartTimeC == null ? null : period1StartTimeC,
        "Period_2_Start_Time__c":
            period2StartTimeC == null ? null : period2StartTimeC,
        "Period_3_Start_Time__c":
            period3StartTimeC == null ? null : period3StartTimeC,
        "Period_5_Start_Time__c":
            period5StartTimeC == null ? null : period5StartTimeC,
        "Period_6_Start_Time__c":
            period6StartTimeC == null ? null : period6StartTimeC,
        "Period_7_Start_Time__c":
            period7StartTimeC == null ? null : period7StartTimeC,
        "Period_8_Start_Time__c":
            period8StartTimeC == null ? null : period8StartTimeC,
        "Period_4_Start_Time__c":
            period4StartTimeC == null ? null : period4StartTimeC,
        "Schedule_Title__c": scheduleTitleC == null ? null : scheduleTitleC,
        "Period_1_End_Time__c":
            period1EndTimeC == null ? null : period1EndTimeC,
        "Period_2_End_Time__c":
            period2EndTimeC == null ? null : period2EndTimeC,
        "Period_3_End_Time__c":
            period3EndTimeC == null ? null : period3EndTimeC,
        "Period_4_End_Time__c":
            period4EndTimeC == null ? null : period4EndTimeC,
        "Period_5_End_Time__c":
            period5EndTimeC == null ? null : period5EndTimeC,
        "Period_6_End_Time__c":
            period6EndTimeC == null ? null : period6EndTimeC,
        "Period_7_End_Time__c":
            period7EndTimeC == null ? null : period7EndTimeC,
        "Schedule_BO_Dates__c":
            scheduleBoDatesC == null ? null : scheduleBoDatesC,
        "Period_0_Start_Time__c":
            period0StartTimeC == null ? null : period0StartTimeC,
        "Period_0_End_Time__c":
            period0EndTimeC == null ? null : period0EndTimeC,
      };
}
