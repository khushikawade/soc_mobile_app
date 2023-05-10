import 'dart:math';
import 'package:hive/hive.dart';
part 'pbis_course_modal.g.dart';

@HiveType(typeId: 33)
class ClassroomCourse {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? descriptionHeading;
  @HiveField(3)
  String? ownerId;
  @HiveField(4)
  String? enrollmentCode;
  @HiveField(5)
  String? courseState;
  @HiveField(6)
  List<ClassroomStudents>? students;

  ClassroomCourse(
      {this.id,
      this.name,
      this.descriptionHeading,
      this.ownerId,
      this.enrollmentCode,
      this.courseState,
      this.students});

  ClassroomCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    descriptionHeading = json['descriptionHeading'] ?? '';
    ownerId = json['ownerId'] ?? '';
    enrollmentCode = json['enrollmentCode'] ?? '';
    courseState = json['courseState'] ?? '';
    if (json['students'] != null) {
      students = <ClassroomStudents>[];
      json['students'].forEach((v) {
        students!.add(new ClassroomStudents.fromJson(v));
      });
    } else {
      students = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['descriptionHeading'] = this.descriptionHeading;
    data['ownerId'] = this.ownerId;
    data['enrollmentCode'] = this.enrollmentCode;
    data['courseState'] = this.courseState;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    } else {
      data['students'] = [];
    }
    return data;
  }
}

@HiveType(typeId: 34)
class ClassroomStudents {
  @HiveField(0)
  ClassroomProfile? profile;

  ClassroomStudents({this.profile});

  ClassroomStudents.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null
        ? new ClassroomProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 35)
class ClassroomProfile {
  @HiveField(0)
  String? id;
  @HiveField(1)
  ClassroomProfileName? name;
  @HiveField(2)
  String? emailAddress;
  @HiveField(3)
  String? photoUrl;
  @HiveField(4)
  List<ClassroomPermissions>? permissions;
  @HiveField(5)
  int? engaged;
  @HiveField(6)
  int? niceWork;
  @HiveField(7)
  int? helpful;
  @HiveField(8)
  String? courseName;
  ClassroomProfile(
      {this.id,
      this.name,
      this.emailAddress,
      this.photoUrl,
      this.permissions,
      this.engaged,
      this.niceWork,
      this.helpful,
      this.courseName});

  ClassroomProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] != null
        ? new ClassroomProfileName.fromJson(json['name'])
        : null;
    emailAddress = json['emailAddress'] ?? '';
    photoUrl = json['photoUrl'].toString().contains('http')
        ? json['photoUrl']
        : 'https:' + json['photoUrl'] ?? '';
    // photoUrl =
    //     'https://source.unsplash.com/random/200x200?sig=${generateRandomUniqueNumber().toString()}';
    if (json['permissions'] != null) {
      permissions = <ClassroomPermissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new ClassroomPermissions.fromJson(v));
      });
    }
    engaged = 0;
    niceWork = 0;
    helpful = 0;
    courseName = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['emailAddress'] = this.emailAddress;
    data['photoUrl'] = this.photoUrl;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Set<int> usedNumbers = {};
  int generateRandomUniqueNumber() {
    var rng = Random();
    int number = 0;
    while (number == 0 ||
        number == 100 ||
        number == 200 ||
        usedNumbers.contains(number)) {
      number = rng.nextInt(899) + 100;
    }
    usedNumbers.add(number);
    return number;
  }
}

@HiveType(typeId: 36)
class ClassroomProfileName {
  @HiveField(0)
  String? givenName;
  @HiveField(1)
  String? familyName;
  @HiveField(2)
  String? fullName;

  ClassroomProfileName({this.givenName, this.familyName, this.fullName});

  ClassroomProfileName.fromJson(Map<String, dynamic> json) {
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

@HiveType(typeId: 37)
class ClassroomPermissions {
  @HiveField(0)
  String? permission;

  ClassroomPermissions({this.permission});

  ClassroomPermissions.fromJson(Map<String, dynamic> json) {
    permission = json['permission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permission'] = this.permission;
    return data;
  }
}
