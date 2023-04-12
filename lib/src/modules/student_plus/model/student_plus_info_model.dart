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

class StudentPlusDetailsModel {
  StudentPlusDetailsModel({
    this.dateOfBirthC,
    this.dbnC,
    this.firstNameC,
    this.gradeC,
    this.lastNameC,
    this.messageC,
    this.parentPhoneC,
    this.schoolC,
    this.schoolYearC,
    this.studentIdC,
    this.id,
    this.isDeleted,
    this.createdByGradedC,
    this.teacherAddedC,
    this.emailC,
    this.dateOfBirthFormulaC,
    this.grC,
    this.ellC,
    this.ellProficiencyC,
    this.ethnicityCodeC,
    this.genderC,
    this.iepC,
    this.nysElaScore2022C,
    this.classC,
    this.admittanceDateC,
    this.hispanicCodeC,
    this.sexC,
    this.accountIdC,
    this.locC,
    this.teacherC,
    this.academicYearC,
    this.dobResiC,
    this.grade1920C,
    this.grade2021C,
    this.grade2122C,
    this.iReadyMathMoyOverallPlacementC,
    this.firstNameInitcapC,
    this.lastNameInitcapC,
    this.ethnicityNameC,
    this.hispanicC,
    this.sexNameC,
    this.housingStatusNameC,
    this.temporaryResidencyFlagC,
    this.iepTextC,
    this.teacherProperC,
    this.iepStatusC,
    this.lepFlagTextC,
    this.ellAdmissionDateC,
    this.dobC,
  });
  @HiveField(0)
  final dynamic dateOfBirthC;
  @HiveField(1)
  final String? dbnC;
  @HiveField(2)
  final String? firstNameC;
  @HiveField(3)
  final String? gradeC;
  @HiveField(4)
  final String? lastNameC;
  @HiveField(5)
  final dynamic messageC;
  @HiveField(6)
  final String? parentPhoneC;
  @HiveField(7)
  final String? schoolC;
  @HiveField(8)
  final dynamic schoolYearC;
  @HiveField(9)
  final String? studentIdC;
  @HiveField(10)
  final String? id;
  @HiveField(11)
  final String? isDeleted;
  @HiveField(12)
  final String? createdByGradedC;
  @HiveField(13)
  final String? teacherAddedC;
  @HiveField(14)
  final dynamic emailC;
  @HiveField(15)
  final String? dateOfBirthFormulaC;
  @HiveField(16)
  final String? grC;
  @HiveField(17)
  final String? ellC;
  @HiveField(18)
  final String? ellProficiencyC;
  @HiveField(19)
  final String? ethnicityCodeC;
  @HiveField(20)
  final String? genderC;
  @HiveField(21)
  final String? iepC;
  @HiveField(22)
  final String? nysElaScore2022C;
  @HiveField(23)
  final String? classC;
  @HiveField(24)
  final dynamic admittanceDateC;
  @HiveField(25)
  final String? hispanicCodeC;
  @HiveField(26)
  final String? sexC;
  @HiveField(27)
  final String? accountIdC;
  @HiveField(28)
  final String? locC;
  @HiveField(29)
  final String? teacherC;
  @HiveField(30)
  final String? academicYearC;
  @HiveField(31)
  final String? dobResiC;
  @HiveField(32)
  final String? grade1920C;
  @HiveField(33)
  final String? grade2021C;
  @HiveField(34)
  final String? grade2122C;
  @HiveField(35)
  final String? iReadyMathMoyOverallPlacementC;
  @HiveField(36)
  final String? firstNameInitcapC;
  @HiveField(37)
  final String? lastNameInitcapC;
  @HiveField(38)
  final String? ethnicityNameC;
  @HiveField(39)
  final String? hispanicC;
  @HiveField(40)
  final String? sexNameC;
  @HiveField(41)
  final dynamic housingStatusNameC;
  @HiveField(42)
  final String? temporaryResidencyFlagC;
  @HiveField(43)
  final String? iepTextC;
  @HiveField(44)
  final String? teacherProperC;
  @HiveField(45)
  final String? iepStatusC;
  @HiveField(46)
  final String? lepFlagTextC;
  @HiveField(47)
  final dynamic ellAdmissionDateC;
  @HiveField(48)
  final DateTime? dobC;

  factory StudentPlusDetailsModel.fromJson(Map<String, dynamic> json) =>
      StudentPlusDetailsModel(
        dateOfBirthC: json["Date_of_Birth__c"],
        dbnC: json["DBN__c"],
        firstNameC: json["First_Name__c"],
        gradeC: json["Grade__c"],
        lastNameC: json["last_Name__c"],
        messageC: json["message__c"],
        parentPhoneC: json["Parent_Phone__c"],
        schoolC: json["School__c"],
        schoolYearC: json["School_Year__c"],
        studentIdC: json["Student_ID__c"],
        id: json["Id"],
        isDeleted: json["IsDeleted"],
        createdByGradedC: json["Created_by_Graded__c"],
        teacherAddedC: json["Teacher_added__c"],
        emailC: json["Email__c"],
        dateOfBirthFormulaC: json["Date_of_Birth_Formula__c"],
        grC: json["GR__c"],
        ellC: json["ELL__c"],
        ellProficiencyC: json["ELL_Proficiency__c"],
        ethnicityCodeC: json["Ethnicity_Code__c"],
        genderC: json["Gender__c"],
        iepC: json["IEP__c"],
        nysElaScore2022C: json["NYS_ELA_Score_2022__c"],
        classC: json["Class__c"],
        admittanceDateC: json["Admittance_Date__c"],
        hispanicCodeC: json["Hispanic_Code__c"],
        sexC: json["Sex__c"],
        accountIdC: json["Account_ID__c"],
        locC: json["LOC__c"],
        teacherC: json["Teacher__c"],
        academicYearC: json["Academic_Year__c"],
        dobResiC: json["DOB_RESI__c"],
        grade1920C: json["Grade_19_20__c"],
        grade2021C: json["Grade_20_21__c"],
        grade2122C: json["Grade_21_22__c"],
        iReadyMathMoyOverallPlacementC:
            json["IReady_Math_MOY_Overall_Placement__c"],
        firstNameInitcapC: json["First_Name_INITCAP__c"],
        lastNameInitcapC: json["Last_Name_INITCAP__c"],
        ethnicityNameC: json["Ethnicity_Name__c"],
        hispanicC: json["Hispanic__c"],
        sexNameC: json["Sex_Name__c"],
        housingStatusNameC: json["Housing_Status_Name__c"],
        temporaryResidencyFlagC: json["Temporary_Residency_Flag__c"],
        iepTextC: json["IEP_Text__c"],
        teacherProperC: json["Teacher_Proper__c"],
        iepStatusC: json["IEP_Status__c"],
        lepFlagTextC: json["LEP_Flag_text__c"],
        ellAdmissionDateC: json["ELL_Admission_Date__c"],
        dobC: json["DOB__c"] == null ? null : DateTime.parse(json["DOB__c"]),
      );

  Map<String, dynamic> toJson() => {
        "Date_of_Birth__c": dateOfBirthC,
        "DBN__c": dbnC,
        "First_Name__c": firstNameC,
        "Grade__c": gradeC,
        "last_Name__c": lastNameC,
        "message__c": messageC,
        "Parent_Phone__c": parentPhoneC,
        "School__c": schoolC,
        "School_Year__c": schoolYearC,
        "Student_ID__c": studentIdC,
        "Id": id,
        "IsDeleted": isDeleted,
        "Created_by_Graded__c": createdByGradedC,
        "Teacher_added__c": teacherAddedC,
        "Email__c": emailC,
        "Date_of_Birth_Formula__c": dateOfBirthFormulaC,
        "GR__c": grC,
        "ELL__c": ellC,
        "ELL_Proficiency__c": ellProficiencyC,
        "Ethnicity_Code__c": ethnicityCodeC,
        "Gender__c": genderC,
        "IEP__c": iepC,
        "NYS_ELA_Score_2022__c": nysElaScore2022C,
        "Class__c": classC,
        "Admittance_Date__c": admittanceDateC,
        "Hispanic_Code__c": hispanicCodeC,
        "Sex__c": sexC,
        "Account_ID__c": accountIdC,
        "LOC__c": locC,
        "Teacher__c": teacherC,
        "Academic_Year__c": academicYearC,
        "DOB_RESI__c": dobResiC,
        "Grade_19_20__c": grade1920C,
        "Grade_20_21__c": grade2021C,
        "Grade_21_22__c": grade2122C,
        "IReady_Math_MOY_Overall_Placement__c": iReadyMathMoyOverallPlacementC,
        "First_Name_INITCAP__c": firstNameInitcapC,
        "Last_Name_INITCAP__c": lastNameInitcapC,
        "Ethnicity_Name__c": ethnicityNameC,
        "Hispanic__c": hispanicC,
        "Sex_Name__c": sexNameC,
        "Housing_Status_Name__c": housingStatusNameC,
        "Temporary_Residency_Flag__c": temporaryResidencyFlagC,
        "IEP_Text__c": iepTextC,
        "Teacher_Proper__c": teacherProperC,
        "IEP_Status__c": iepStatusC,
        "LEP_Flag_text__c": lepFlagTextC,
        "ELL_Admission_Date__c": ellAdmissionDateC,
        "DOB__c":
            "${dobC!.year.toString().padLeft(4, '0')}-${dobC!.month.toString().padLeft(2, '0')}-${dobC!.day.toString().padLeft(2, '0')}",
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

