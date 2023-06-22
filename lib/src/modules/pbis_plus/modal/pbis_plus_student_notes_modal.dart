import 'package:hive/hive.dart';
part 'pbis_plus_student_notes_modal.g.dart';

@HiveType(typeId: 45)
class PBISPlusStudentNotes extends HiveObject {
  @HiveField(0)
  String? studentName;
  @HiveField(1)
  String? iconUrlC;
  @HiveField(2)
  String? notesComments;
  @HiveField(3)
  String? date;

  PBISPlusStudentNotes({
    this.studentName,
    this.iconUrlC,
    this.notesComments,
    this.date,
  });

  PBISPlusStudentNotes.fromJson(Map<String, dynamic> json) {
    studentName = json['studentName'] ?? '';
    notesComments = json['notesComments'] ?? '';
    iconUrlC = json['iconUrlC'].toString().contains('http')
        ? json['iconUrlC']
        : 'https:' + json['iconUrlC'] ?? '';
    // photoUrl =
    //     'https://source.unsplash.com/random/200x200?sig=${generateRandomUniqueNumber().toString()}';
    date = json['date'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentName'] = this.studentName;
    data['notesComments'] = this.notesComments;
    data['iconUrlC'] = this.iconUrlC;
    data['date'] = this.date;
    return data;
  }
}
