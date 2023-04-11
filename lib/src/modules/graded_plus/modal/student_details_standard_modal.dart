// To parse this JSON data, do
//
//     final studentDetails = studentDetailsFromJson(jsonString);


import 'package:hive/hive.dart';
part 'student_details_standard_modal.g.dart';


// StudentDetails studentDetailsFromJson(String str) => StudentDetails.fromJson(json.decode(str));

// String studentDetailsToJson(StudentDetails data) => json.encode(data.toJson());

@HiveType(typeId: 30)
class StudentDetailsModal {
    StudentDetailsModal({
        this.email,
        this.name,
        this.studentId,
    });
    @HiveField(0)
    final String? email;
    @HiveField(1)
    final String? name;
    @HiveField(2)
    final String? studentId;

    factory StudentDetailsModal.fromJson(Map<String, dynamic> json) => StudentDetailsModal(
        email: json["email"]== null ? '' : json["email"],
        name: json["name"] == null ? '' : json["name"],
        studentId: json["studentId"] == null ? '' : json["studentId"],
    );

    Map<String, dynamic> toJson() => {
        "email": email== null ? '' : email,
        "name": name == null ? '' : name,
        "studentId": studentId == null ? '' : studentId,
    };
}
