import 'package:hive/hive.dart';
part 'student_google_presentation_detail_modal.g.dart';

@HiveType(typeId: 44)
class StudentGooglePresentationDetailModal {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? studentC;
  @HiveField(2)
  String? teacherC;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? dBNC;
  @HiveField(5)
  String? schoolAppC;
  @HiveField(6)
  String? googlePresentationId;
  @HiveField(7)
  String? googlePresentationURL;
  @HiveField(8)
  String? createdAt;
  @HiveField(9)
  String? updatedAt;
  @HiveField(10)
  String? studentRecordId;
  @HiveField(11)
  StudentGooglePresentationDetailModal(
      {this.id,
      this.studentC,
      this.teacherC,
      this.title,
      this.dBNC,
      this.schoolAppC,
      this.googlePresentationId,
      this.googlePresentationURL,
      this.createdAt,
      this.updatedAt,
      this.studentRecordId});

  StudentGooglePresentationDetailModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    studentC = json['Student__c'];
    teacherC = json['Teacher__c'];
    title = json['Title'];
    dBNC = json['DBN__c'];
    schoolAppC = json['School_App__c'];
    googlePresentationId = json['Google_Presentation_Id'];
    googlePresentationURL = json['Google_Presentation_URL'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    studentRecordId = json['Student_Record_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Student__c'] = this.studentC;
    data['Teacher__c'] = this.teacherC;
    data['Title'] = this.title;
    data['DBN__c'] = this.dBNC;
    data['School_App__c'] = this.schoolAppC;
    data['Google_Presentation_Id'] = this.googlePresentationId;
    data['Google_Presentation_URL'] = this.googlePresentationURL;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['Student_Record_Id'] = this.studentRecordId;
    return data;
  }
}
