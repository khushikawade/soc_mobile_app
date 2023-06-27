import 'dart:convert';
import 'package:hive/hive.dart';
part 'student_plus_info_model.g.dart';

// To parse this JSON data, do
//
//     final studentInfoModelDetails = studentInfoModelDetailsFromJson(jsonString);

StudentPlusDetailsModel studentInfoModelDetailsFromJson(String str) =>
    StudentPlusDetailsModel.fromJson(json.decode(str));

String studentInfoModelDetailsToJson(StudentPlusDetailsModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 31)
// To parse this JSON data, do
//
//     final studentInfoModelDetails = studentInfoModelDetailsFromJson(jsonString);

// To parse this JSON data, do
//
//     final StudentPlusDetailsModel = StudentPlusDetailsModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final StudentPlusDetailsModel = StudentPlusDetailsModelFromJson(jsonString);

class StudentPlusDetailsModel {
  StudentPlusDetailsModel(
      {this.firstNameC,
      this.gradeC,
      this.lastNameC,
      this.parentPhoneC,
      this.schoolC,
      this.studentIdC,
      this.id,
      this.emailC,
      this.ellC,
      this.ellProficiencyC,
      this.classC,
      this.iepProgramC,
      this.genderFullC,
      this.dobC,
      this.nysElaScore2022C,
      this.nysMathScore2022C,
      this.nysElaScore2021C,
      this.nysMathScore2021C,
      this.nysElaScore2019C,
      this.nysMathScore2019C,
      this.nysMath2023PredictionC,
      this.nysEla2023PredictionC,
      this.ELACurrentSyBOY,
      this.ELACurrentSyBOYPercentile,
      this.ELACurrentSyEOY,
      this.ELACurrentSyEOYPercentile,
      this.ELACurrentSyMOY,
      this.ELACurrentSyMOYPercentile,
      this.ELAPreviousSyEOY,
      this.ELAPreviousSyEOYPercentile,
      this.ethnicityNameC,
      this.iepYesNoC,
      this.mathCurrentSyBOY,
      this.mathCurrentSyBOYPercentile,
      this.mathCurrentSyEOY,
      this.mathCurrentSyEOYPercentile,
      this.mathCurrentSyMOY,
      this.mathCurrentSyMOYPercentile,
      this.mathPreviousSyEOY,
      this.mathPreviousSyEOYPercentile,
      this.teacherProperC,
      this.mathCurrentBOYOverallRelativePlace,
      this.mathCurrentEOYOverallRelativePlace,
      this.mathCurrentMOYOverallRelativePlace,
      this.mathPreviousEOYOverallRelPlace,
      this.ELACurrentBOYOverallRelativePlace,
      this.ELACurrentEOYOverallRelativePlace,
      this.ELACurrentMOYOverallRelativePlace,
      this.ELAPreviousEOYOverallRelPlace,
      this.currentAttendance,
      this.age,
      this.grade19_20,
      this.grade20_21,
      this.grade21_22,
      this.studentPhoto,
      this.studentGooglePresentationUrl,
      this.studentGooglePresentationId});

  /* --------------------- Field use to show student info --------------------- */
  @HiveField(0)
  final String? firstNameC;
  @HiveField(1)
  final String? gradeC;
  @HiveField(2)
  final String? lastNameC;
  @HiveField(3)
  final String? parentPhoneC;
  @HiveField(4)
  final String? schoolC;
  @HiveField(5)
  final String? studentIdC;
  @HiveField(6)
  final String? id;
  @HiveField(7)
  final String? emailC;
  @HiveField(8)
  final String? ellC;
  @HiveField(9)
  final String? ellProficiencyC;
  @HiveField(10)
  final String? classC;
  @HiveField(11)
  final String? iepProgramC;
  @HiveField(12)
  final String? genderFullC;
  @HiveField(13)
  final String? dobC;
  @HiveField(14)
  final String? iepYesNoC;
  @HiveField(15)
  final String? teacherProperC;
  @HiveField(16)
  final String? ethnicityNameC;

  /* ----------------------------- NYS Graph Value ---------------------------- */
  @HiveField(17)
  final String? nysElaScore2019C;
  @HiveField(18)
  final String? nysMathScore2019C;
  @HiveField(19)
  final String? nysElaScore2021C;
  @HiveField(20)
  final String? nysMathScore2021C;
  @HiveField(21)
  final String? nysElaScore2022C;
  @HiveField(22)
  final String? nysMathScore2022C;
  @HiveField(23)
  final String? nysMath2023PredictionC;
  @HiveField(24)
  final String? nysEla2023PredictionC;

  /* ------------------ Field use in Exams Page - iReady Math ----------------- */
  @HiveField(25)
  final String? mathPreviousSyEOY;
  @HiveField(26)
  final String? mathCurrentSyBOY;
  @HiveField(27)
  final String? mathCurrentSyMOY;
  @HiveField(28)
  final String? mathCurrentSyEOY;
  @HiveField(29)
  final String? mathPreviousSyEOYPercentile;
  @HiveField(30)
  final String? mathCurrentSyBOYPercentile;
  @HiveField(31)
  final String? mathCurrentSyMOYPercentile;
  @HiveField(32)
  final String? mathCurrentSyEOYPercentile;

  /* ------------------ Exams Page - iReady ELA ----------------- */
  @HiveField(33)
  final String? ELAPreviousSyEOY;
  @HiveField(34)
  final String? ELACurrentSyBOY;
  @HiveField(35)
  final String? ELACurrentSyMOY;
  @HiveField(36)
  final String? ELACurrentSyEOY;
  @HiveField(37)
  final String? ELAPreviousSyEOYPercentile;
  @HiveField(38)
  final String? ELACurrentSyBOYPercentile;
  @HiveField(39)
  final String? ELACurrentSyMOYPercentile;
  @HiveField(40)
  final String? ELACurrentSyEOYPercentile;

  /* ------------------------- iReady Math color code ------------------------- */
  @HiveField(41)
  final String? mathPreviousEOYOverallRelPlace;
  @HiveField(42)
  final String? mathCurrentBOYOverallRelativePlace;
  @HiveField(43)
  final String? mathCurrentMOYOverallRelativePlace;
  @HiveField(44)
  final String? mathCurrentEOYOverallRelativePlace;

  /* ------------------------- iReady Math color code ------------------------- */
  @HiveField(45)
  final String? ELAPreviousEOYOverallRelPlace;
  @HiveField(46)
  final String? ELACurrentBOYOverallRelativePlace;
  @HiveField(47)
  final String? ELACurrentMOYOverallRelativePlace;
  @HiveField(48)
  final String? ELACurrentEOYOverallRelativePlace;

  @HiveField(49)
  final String? currentAttendance;

  @HiveField(50)
  final String? age;
  @HiveField(51)
  final String? grade19_20;
  @HiveField(52)
  final String? grade20_21;
  @HiveField(53)
  final String? grade21_22;
  @HiveField(54)
  final String? studentPhoto;

  @HiveField(55)
  String? studentGooglePresentationUrl;
  @HiveField(56)
  String? studentGooglePresentationId;

  factory StudentPlusDetailsModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusDetailsModel(
          firstNameC: json["First_Name__c"],
          gradeC: json["Grade__c"],
          lastNameC: json["last_Name__c"],
          parentPhoneC: json["Parent_Phone__c"],
          schoolC: json["School__c"],
          studentIdC: json["Student_ID__c"],
          id: json["Id"],
          emailC: json["Email__c"],
          ellC: json["ELL__c"],
          ellProficiencyC: json["ELL_Proficiency__c"],
          classC: json["Class__c"],
          iepProgramC: json["IEP_Program__c"],
          genderFullC: json["Gender_Full__c"],
          dobC: json["DOB__c"],
          age: json["Age__c"],

          /* ------------------------ field use to show grades ------------------------ */
          grade19_20: json["Grade_19_20__c"],
          grade20_21: json["Grade_20_21__c"],
          grade21_22: json["Grade_21_22__c"],

          /* ---------------------- Fields use to show NYS graph ---------------------- */
          nysElaScore2019C: json["NYS_ELA_2019__c"],
          nysMathScore2019C: json["NYS_Math_2019__c"],
          nysElaScore2021C: json["NYS_ELA_2021__c"],
          nysMathScore2021C: json["NYS_Math_2021__c"],
          nysElaScore2022C: json["NYS_ELA_PR_Score_2022__c"],
          nysMathScore2022C: json["NYS_Math_PR_Score_2022__c"],
          nysMath2023PredictionC: json["NYS_Math_2023_Prediction__c"],
          nysEla2023PredictionC: json["NYS_ELA_2023_Prediction__c"],

          /* ------------------ Field use in Exams Page - iReady Math ----------------- */
          mathPreviousSyEOY: json["iReady_Math_EOY_21_22_ORP_Place_STUDENT__c"],
          mathCurrentSyBOY: json["IReady_Math_BOY_ORP_STUDENT__c"],
          mathCurrentSyMOY: json["IReady_Math_MOY_ORP_STUDENT__c"],
          mathCurrentSyEOY: json["IReady_Math_EOY_ORP_STUDENT__c"],
          mathPreviousSyEOYPercentile:
              json["iReady_Math_EOY_21_22_Percentile__c"],
          mathCurrentSyBOYPercentile: json["IReady_MATH_BOY_Percentile__c"],
          mathCurrentSyMOYPercentile: json["IReady_MATH_MOY_Percentile__c"],
          mathCurrentSyEOYPercentile: json["IReady_MATH_EOY_Percentile__c"],

          /* ------------------ Field use in Exams Page - iReady Math ----------------- */
          ELAPreviousSyEOY: json["iReady_ELA_EOY_21_22_ORP_STUDENT__c"],
          ELACurrentSyBOY: json["IReady_ELA_BOY_ORP_STUDENT__c"],
          ELACurrentSyMOY: json["IReady_ELA_MOY_ORP_STUDENT__c"],
          ELACurrentSyEOY: json["IReady_ELA_EOY_ORP_STUDENT__c"],
          ELAPreviousSyEOYPercentile:
              json["iReady_ELA_EOY_21_22_Percentile__c"],
          ELACurrentSyBOYPercentile: json["IReady_ELA_BOY_Percentile__c"],
          ELACurrentSyMOYPercentile: json["IReady_ELA_MOY_Percentile__c"],
          ELACurrentSyEOYPercentile: json["IReady_ELA_EOY_Percentile__c"],
          iepYesNoC: json["IEP_Yes_No__c"],
          teacherProperC: json["Teacher_Proper__c"],
          ethnicityNameC: json["Ethnicity_Name__c"],

          /* ------------------------- iReady Math color code ------------------------- */
          mathPreviousEOYOverallRelPlace: json[
              "iReady_Math_EOY_21_22_Overall_Rel_Place__c"], //iReady_Math_EOY_21_22_ORP_Place_STUDENT__c
          mathCurrentBOYOverallRelativePlace:
              json["IReady_Math_BOY_Overall_Relative_Place__c"],
          mathCurrentMOYOverallRelativePlace:
              json["Math_IReady_Overall_Relative_Place_MOY__c"],
          mathCurrentEOYOverallRelativePlace:
              json["IReady_Math_EOY_Overall_Relative_Place__c"],

          /* ------------------------- iReady ELA color code ------------------------- */
          ELAPreviousEOYOverallRelPlace:
              json["iReady_ELA_EOY_21_22_Overall_Rel_Place__c"],
          ELACurrentBOYOverallRelativePlace:
              json["IReady_ELA_BOY_Overall_Relative_Place__c"],
          ELACurrentMOYOverallRelativePlace:
              json["ELA_IReady_Overall_Relative_Place_MOY__c"],
          ELACurrentEOYOverallRelativePlace:
              json["IReady_ELA_EOY_Overall_Relative_Place__c"],
          currentAttendance: json["Current_Attendance__c"],
          studentPhoto: json['Student_photo__c'],
          studentGooglePresentationId: json['Google_Presentation_Id'] ?? '',
          studentGooglePresentationUrl: json['Google_Presentation_URL'] ?? '');

  get nysElaPrScore2021C => null;

  get nysElaPrScore2022C => null;

  get nysMathScore2020C => null;

  get nysElaPrScore2020C => null;

  Map<String, String?> toJson() => {
        "First_Name__c": firstNameC,
        "Grade__c": gradeC,
        "last_Name__c": lastNameC,
        "Parent_Phone__c": parentPhoneC,
        "School__c": schoolC,
        "Student_ID__c": studentIdC,
        "Id": id,
        "Email__c": emailC,
        "ELL__c": ellC,
        "ELL_Proficiency__c": ellProficiencyC,
        "Class__c": classC,
        "IEP_Program__c": iepProgramC,
        "Gender_Full__c": genderFullC,
        "DOB__c": dobC,
        "NYS_ELA_2019__c": nysElaScore2019C,
        "NYS_Math_2019__c": nysMathScore2019C,
        "NYS_ELA_PR_Score_2022__c": nysElaScore2022C,
        "NYS_Math_PR_Score_2022__c": nysMathScore2022C,
        "NYS_ELA_2021__c": nysElaScore2021C,
        "NYS_Math_2021__c": nysMathScore2021C,
        "NYS_Math_2023_Prediction__c": nysMath2023PredictionC,
        "NYS_ELA_2023_Prediction__c": nysEla2023PredictionC,

        /* ------------------ Field use in Exams Page - iReady Math ----------------- */
        "iReady_Math_EOY_21_22_ORP_Place_STUDENT__c": mathPreviousSyEOY,
        "IReady_Math_BOY_ORP_STUDENT__c": mathCurrentSyBOY,
        "IReady_Math_MOY_ORP_STUDENT__c": mathCurrentSyMOY,
        "IReady_Math_EOY_ORP_STUDENT__c": mathCurrentSyEOY,
        "iReady_Math_EOY_21_22_Percentile__c": mathPreviousSyEOYPercentile,
        "IReady_MATH_BOY_Percentile__c": mathCurrentSyBOYPercentile,
        "IReady_MATH_MOY_Percentile__c": mathCurrentSyMOYPercentile,
        "IReady_MATH_EOY_Percentile__c": mathCurrentSyEOYPercentile,

        /* ------------------ Field use in Exams Page - iReady ELA ----------------- */
        "iReady_ELA_EOY_21_22_ORP_STUDENT__c": ELAPreviousSyEOY,
        "IReady_ELA_BOY_ORP_STUDENT__c": ELACurrentSyBOY,
        "IReady_ELA_MOY_ORP_STUDENT__c": ELACurrentSyMOY,
        "IReady_ELA_EOY_ORP_STUDENT__c": ELACurrentSyEOY,
        "iReady_ELA_EOY_21_22_Percentile__c": ELAPreviousSyEOYPercentile,
        "IReady_ELA_BOY_Percentile__c": ELACurrentSyBOYPercentile,
        "IReady_ELA_MOY_Percentile__c": ELACurrentSyMOYPercentile,
        "IReady_ELA_EOY_Percentile__c": ELACurrentSyEOYPercentile,
        "IEP_Yes_No__c": iepYesNoC,
        "Teacher_Proper__c": teacherProperC,
        "Ethnicity_Name__c": ethnicityNameC,

        /* ------------------------- iReady Math color code ------------------------- */
        "iReady_Math_EOY_21_22_Overall_Rel_Place__c":
            mathPreviousEOYOverallRelPlace,
        "IReady_Math_BOY_Overall_Relative_Place__c":
            mathCurrentBOYOverallRelativePlace,
        "Math_IReady_Overall_Relative_Place_MOY__c":
            mathCurrentMOYOverallRelativePlace,
        "IReady_Math_EOY_Overall_Relative_Place__c":
            mathCurrentEOYOverallRelativePlace,

        /* ------------------------- iReady ELA color code ------------------------- */
        "iReady_ELA_EOY_21_22_Overall_Rel_Place__c":
            ELAPreviousEOYOverallRelPlace,
        "IReady_ELA_BOY_Overall_Relative_Place__c":
            ELACurrentBOYOverallRelativePlace,
        "ELA_IReady_Overall_Relative_Place_MOY__c":
            ELACurrentMOYOverallRelativePlace,
        "IReady_ELA_EOY_Overall_Relative_Place__c":
            ELACurrentEOYOverallRelativePlace,
        "Current_Attendance__c": currentAttendance,
        "Age__c": age,
        /* ------------------------ field use to show grades ------------------------ */
        "Grade_19_20__c": grade19_20,
        "Grade_20_21__c": grade20_21,
        "Grade_21_22__c": grade21_22,
        "Student_photo__c": studentPhoto,
        "Google_Presentation_Id": studentGooglePresentationId,
        "Google_Presentation_URL": studentGooglePresentationId
      };
}

class StudentPlusInfoModel {
  String label;
  String value;
  StudentPlusInfoModel({
    required this.label,
    required this.value,
  });
// A (B5FFC5)
// B (FCD1CB)
// C (E6E4F9)
// D (FEE8D0)
// E (EBD2FF)
// F (B5E0FF) Optional
}

class MyData {
  final DateTime date;
  final double value;

  MyData({
    required this.date,
    required this.value,
  });
}
// class StudentWorkModel {
//   final String date;
//   final String assignment;
//   final String teacher;
//   final String score;
//   final String studentWork;

//   StudentWorkModel({
//     required this.date,
//     required this.assignment,
//     required this.score,
//     required this.studentWork,
//     required this.teacher,
//   });
// }

