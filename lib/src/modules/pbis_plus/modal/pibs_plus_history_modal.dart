import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:hive/hive.dart';

part 'pibs_plus_history_modal.g.dart';

@HiveType(typeId: 38)
class PBISPlusHistoryModal {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? createdAt;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? uRL;
  @HiveField(4)
  String? teacherEmail;
  @HiveField(5)
  String? schoolId;
  @HiveField(6)
  String? classroomCourse;
  @HiveField(7)
  String? title;
  PBISPlusHistoryModal(
      {this.id,
      this.createdAt,
      this.type,
      this.uRL,
      this.teacherEmail,
      this.schoolId});

  PBISPlusHistoryModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? 0;
    createdAt = PBISPlusUtility.convertDateString(json['CreatedAt']);
    type = json['Type'] ?? '';
    uRL = json['URL'] ?? '';
    teacherEmail = json['Teacher_Email'] ?? '';
    schoolId = json['School_Id'] ?? '';
    classroomCourse = json['Classroom_Course'] ?? '';
    title = json['Title'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['Type'] = this.type;
    data['URL'] = this.uRL;
    data['Teacher_Email'] = this.teacherEmail;
    data['School_Id'] = this.schoolId;
    data['Classroom_Course'] = this.classroomCourse;
    data['Title'] = this.title;
    return data;
  }

  // String generateRandomDate() {
  //   Random random = Random();
  //   int year =
  //       random.nextInt(100) + 1923; // Generate a year between 1923 and 2022
  //   int month = random.nextInt(12) + 1; // Generate a month between 1 and 12
  //   int day = random.nextInt(31) + 1; // Generate a day between 1 and 31

  //   DateTime date = DateTime(year, month, day);
  //   String formattedDate = DateFormat('dd/MM/yyyy').format(date);

  //   return formattedDate;
  // }
}
