import 'package:hive/hive.dart';
part 'recent_google_file.g.dart';

@HiveType(typeId: 18)
class RecentGoogleFileSearch {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? fileId;
  @HiveField(3)
  final label;
  @HiveField(4)
  String? webContentLink;
  @HiveField(5)
  String? createdDate;
  @HiveField(6)
  String? modifiedDate;
  @HiveField(7)
  String? sessionId;
  @HiveField(8)
  String? isCreatedAsPremium;
  @HiveField(9)
  int? hiveobjid;
  @HiveField(10)
  String? assessmentType;
  @HiveField(11)
  String? assessmentId;
  @HiveField(12)
  String? classroomCourseId;
  @HiveField(13)
  String? classroomCourseWorkId;
  @HiveField(14)
  String? classroomCourseWorkUrl;
  RecentGoogleFileSearch(
      {this.title,
      this.description,
      this.fileId,
      this.label,
      this.webContentLink,
      this.createdDate,
      this.modifiedDate,
      this.sessionId,
      this.isCreatedAsPremium,
      this.hiveobjid,
      this.assessmentType,
      this.assessmentId,
      this.classroomCourseId,
      this.classroomCourseWorkId,
      this.classroomCourseWorkUrl});
}
