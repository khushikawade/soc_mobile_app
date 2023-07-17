import 'dart:math';
// import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_genric_behavior_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_total_Behavior_modal.dart';
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
  @HiveField(7)
  String? courseWorkId; //used in GRADED+
  @HiveField(8)
  String? assessmentCId; //used in GRADED+
  @HiveField(9)
  String? courseWorkURL; //used in GRADED+
  @HiveField(10)
  bool? isBehviourLoading;

  ClassroomCourse(
      {this.id,
      this.name,
      this.descriptionHeading,
      this.ownerId,
      this.enrollmentCode,
      this.courseState,
      this.students,
      this.courseWorkId,
      this.assessmentCId,
      this.courseWorkURL,
      this.isBehviourLoading = true});

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
  // @HiveField(5)
  // PBISPlusGenericBehaviorModal? behavior1;
  // @HiveField(6)
  // PBISPlusGenericBehaviorModal? behavior2;
  // @HiveField(7)
  // PBISPlusGenericBehaviorModal? behavior3;
  // @HiveField(8)
  // PBISPlusGenericBehaviorModal? behavior4;
  // @HiveField(9)
  // PBISPlusGenericBehaviorModal? behavior5;
  // @HiveField(10)
  // PBISPlusGenericBehaviorModal? behavior6;

  @HiveField(8)
  String? courseName;
  @HiveField(9)
  String? courseId;
  @HiveField(10)
  List<BehaviorList>? behaviorList;
  ClassroomProfile(
      {this.id,
      this.name,
      this.emailAddress,
      this.photoUrl,
      this.permissions,
      this.engaged,
      this.niceWork,
      this.helpful,
      // this.behavior1,
      // this.behavior2,
      // this.behavior3,
      // this.behavior4,
      // this.behavior5,
      // this.behavior6,
      this.courseName,
      this.courseId,
      this.behaviorList});

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
    // behavior1 = json['behavior1'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    // behavior2 = json['behavior2'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    // behavior3 = json['behaviou3'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    // behavior4 = json['behavior4'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    // behavior5 = json['behavior5'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    // behavior6 = json['behavior6'] != null
    //     ? PBISPlusGenericBehaviorModal.fromJson(json['name'])
    //     : null;
    engaged = 0;
    niceWork = 0;
    helpful = 0;
    courseName = '';
    courseId = '';
    behaviorList = [];
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

// @HiveType(typeId: 44)
// class BehaviorList {
//   String? id;
//   String? name;
//   int? score;

//   BehaviorList({this.id, this.name, this.score});

//   BehaviorList.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     name = json['Name'];
//     score = json['Score'] ?? 0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Id'] = this.id;
//     data['Name'] = this.name;
//     data['Score'] = this.score;
//     return data;
//   }
// }

@HiveType(typeId: 44)
class BehaviorList {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? iconURL;
  @HiveField(3)
  bool? defaultBehavior;
  @HiveField(4)
  int? behaviorCount;

  BehaviorList(
      {this.id,
      this.name,
      this.iconURL,
      this.defaultBehavior,
      this.behaviorCount});

  BehaviorList.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? "";
    name = json['Name'] ?? '';
    iconURL = json['Icon_URL'] ?? '';
    defaultBehavior = json['Default'] == "true" ? true : false;
    behaviorCount = json['Behavior_Count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Icon_URL'] = this.iconURL;
    data['Default'] = this.defaultBehavior;
    data['Behavior_Count'] = this.behaviorCount;
    return data;
  }
}
