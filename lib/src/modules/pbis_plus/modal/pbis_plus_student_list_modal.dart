import 'package:Soc/src/services/utility.dart';
import 'package:hive/hive.dart';
part 'pbis_plus_student_list_modal.g.dart';

@HiveType(typeId: 45)
class PBISPlusStudentList extends HiveObject {
  @HiveField(0)
  String? studentId;
  @HiveField(1)
  StudentName? names;
  @HiveField(2)
  String? iconUrlC;
  @HiveField(3)
  PBISStudentNotes? notes;

  PBISPlusStudentList({
    this.studentId,
    this.names,
    this.iconUrlC,
    this.notes,
    // this.date,
  });

  PBISPlusStudentList.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'] ?? '';
    names =
        json['names'] != null ? new StudentName.fromJson(json['names']) : null;
    notes = json['notes'] != null
        ? new PBISStudentNotes.fromJson(json['notes'])
        : null;
    ;
    iconUrlC = json['iconUrlC'].toString().contains('http')
        ? json['iconUrlC']
        : 'https:' + json['iconUrlC'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentName'] = this.names;
    data['notes'] = this.notes;
    data['iconUrlC'] = this.iconUrlC;
    // data['date'] = this.date;
    return data;
  }
}

@HiveType(typeId: 49)
class StudentName {
  @HiveField(0)
  String? givenName;
  @HiveField(1)
  String? familyName;
  @HiveField(2)
  String? fullName;

  StudentName({this.givenName, this.familyName, this.fullName});

  StudentName.fromJson(Map<String, dynamic> json) {
    givenName = json['givenName'] ?? '';
    familyName = json['familyName'] ?? '';
    fullName = json['fullName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['givenName'] = this.givenName;
    data['familyName'] = this.familyName;
    data['fullName'] = this.fullName;
    return data;
  }
}

@HiveType(typeId: 50)
class PBISStudentNotes {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? studentName;
  @HiveField(2)
  String? studentEmail;
  @HiveField(3)
  String? teacherC;
  @HiveField(4)
  String? schoolAppC;
  @HiveField(5)
  String? notes;
  @HiveField(6)
  String? date;
  @HiveField(7)
  String? time;
  @HiveField(8)
  String? weekday;

  PBISStudentNotes({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.teacherC,
    required this.schoolAppC,
    required this.notes,
    required this.date,
    required this.time,
    required this.weekday,
  });

  factory PBISStudentNotes.fromJson(Map<String, dynamic> json) =>
      PBISStudentNotes(
          id: json["Id"],
          studentName: json["Student_Name"],
          studentEmail: json["Student_Email"],
          teacherC: json["Teacher__c"],
          schoolAppC: json["School_App__c"],
          notes: json["Notes"],
          date: Utility.getTimefromUtc(json["CreatedAt"], "D"),
          time: Utility.getTimefromUtc(json["CreatedAt"], "T"),
          weekday: Utility.getTimefromUtc(json["CreatedAt"], "WD"));

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Student_Name": studentName,
        "Student_Email": studentEmail,
        "Teacher__c": teacherC,
        "School_App__c": schoolAppC,
        "Notes": notes,
        "date": date ?? "",
        "time": time ?? "",
        "weekday": weekday ?? "",
      };
}
