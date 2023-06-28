import 'package:hive/hive.dart';
part 'pbis_plus_student_notes_modal.g.dart';

@HiveType(typeId: 45)
class PBISPlusStudentNotes extends HiveObject {
  @HiveField(0)
  StudentName? names;
  @HiveField(1)
  String? iconUrlC;
  @HiveField(2)
  String? notesComments;
  @HiveField(3)
  String? date;

  PBISPlusStudentNotes({
    this.names,
    this.iconUrlC,
    this.notesComments,
    this.date,
  });

  PBISPlusStudentNotes.fromJson(Map<String, dynamic> json) {
    names =
        json['names'] != null ? new StudentName.fromJson(json['names']) : null;
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
    data['studentName'] = this.names;
    data['notesComments'] = this.notesComments;
    data['iconUrlC'] = this.iconUrlC;
    data['date'] = this.date;
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
