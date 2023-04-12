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
  StudentPlusDetailsModel({
    this.firstNameC,
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
  });

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

  factory StudentPlusDetailsModel.fromJson(Map<String, dynamic> json) => StudentPlusDetailsModel(
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

      /* ---------------------- Fields use to show NYS graph ---------------------- */
      nysElaScore2019C: json["NYS_ELA_2019__c"],
      nysMathScore2019C: json["NYS_Math_2019__c"],
      nysElaScore2021C: json["NYS_ELA_Score_2021__c"],
      nysMathScore2021C: json["NYS_Math_Score_2021__c"],
      nysElaScore2022C: json["NYS_ELA_Score_2022__c"],
      nysMathScore2022C: json["NYS_Math_Score_2022__c"],
      nysMath2023PredictionC: json["NYS_Math_2023_Prediction__c"],
      nysEla2023PredictionC: json["NYS_ELA_2023_Prediction__c"],

      /* ------------------ Field use in Exams Page - iReady Math ----------------- */
      mathPreviousSyEOY: json["iReady_Math_EOY_21_22_Score__c"],
      mathCurrentSyBOY: json["iReady_Math_BOY_Score__c"],
      mathCurrentSyMOY: json["iReady_Math_MOY_Score__c"],
      mathCurrentSyEOY: json["iReady_Math_EOY_Score__c"],
      mathPreviousSyEOYPercentile: json["iReady_Math_EOY_21_22_Percentile__c"],
      mathCurrentSyBOYPercentile: json["IReady_MATH_BOY_Percentile__c"],
      mathCurrentSyMOYPercentile: json["IReady_MATH_MOY_Percentile__c"],
      mathCurrentSyEOYPercentile: json["IReady_MATH_EOY_Percentile__c"],

      /* ------------------ Field use in Exams Page - iReady Math ----------------- */
      ELAPreviousSyEOY: json["iReady_ELA_EOY_21_22_Score__c"],
      ELACurrentSyBOY: json["iReady_ELA_BOY_Score__c"],
      ELACurrentSyMOY: json["iReady_ELA_MOY_Score__c"],
      ELACurrentSyEOY: json["iReady_ELA_EOY_Score__c"],
      ELAPreviousSyEOYPercentile: json["iReady_ELA_EOY_21_22_Percentile__c"],
      ELACurrentSyBOYPercentile: json["IReady_ELA_BOY_Percentile__c"],
      ELACurrentSyMOYPercentile: json["IReady_ELA_MOY_Percentile__c"],
      ELACurrentSyEOYPercentile: json["IReady_ELA_EOY_Percentile__c"],
      iepYesNoC: json["IEP_Yes_No__c"],
      teacherProperC: json["Teacher_Proper__c"],
      ethnicityNameC: json["Ethnicity_Name__c"]);

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
        "NYS_ELA_2022__c": nysElaScore2022C,
        "NYS_Math_2022__c": nysMathScore2022C,
        "NYS_ELA_2021__c": nysElaScore2021C,
        "NYS_Math_2021__c": nysMathScore2021C,
        "NYS_Math_2023_Prediction__c": nysMath2023PredictionC,
        "NYS_ELA_2023_Prediction__c": nysEla2023PredictionC,

        /* ------------------ Field use in Exams Page - iReady Math ----------------- */
        "iReady_Math_EOY_21_22_Score__c": mathPreviousSyEOY,
        "iReady_Math_BOY_Score__c": mathCurrentSyBOY,
        "iReady_Math_MOY_Score__c": mathCurrentSyMOY,
        "iReady_Math_EOY_Score__c": mathCurrentSyEOY,
        "iReady_Math_EOY_21_22_Percentile__c": mathPreviousSyEOYPercentile,
        "IReady_MATH_BOY_Percentile__c": mathCurrentSyBOYPercentile,
        "IReady_MATH_MOY_Percentile__c": mathCurrentSyMOYPercentile,
        "IReady_MATH_EOY_Percentile__c": mathCurrentSyEOYPercentile,

        /* ------------------ Field use in Exams Page - iReady ELA ----------------- */
        "iReady_ELA_EOY_21_22_Score__c": ELAPreviousSyEOY,
        "iReady_ELA_BOY_Score__c": ELACurrentSyBOY,
        "iReady_ELA_MOY_Score__c": ELACurrentSyMOY,
        "iReady_ELA_EOY_Score__c": ELACurrentSyEOY,
        "iReady_ELA_EOY_21_22_Percentile__c": ELAPreviousSyEOYPercentile,
        "IReady_ELA_BOY_Percentile__c": ELACurrentSyBOYPercentile,
        "IReady_ELA_MOY_Percentile__c": ELACurrentSyMOYPercentile,
        "IReady_ELA_EOY_Percentile__c": ELACurrentSyEOYPercentile,
        "IEP_Yes_No__c": iepYesNoC,
        "Teacher_Proper__c": teacherProperC,
        "Ethnicity_Name__c": ethnicityNameC,
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
