import 'package:Soc/src/services/utility.dart';
import 'package:hive/hive.dart';
part 'assessment.g.dart';

@HiveType(typeId: 16)
class HistoryAssessment {
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
  String? assessmentType;
  @HiveField(10)
  String? assessmentId;
  @HiveField(11)
  String? presentationLink;
  HistoryAssessment(
      {this.title,
      this.description,
      this.fileId,
      this.label,
      this.webContentLink,
      this.createdDate,
      this.modifiedDate,
      this.sessionId,
      this.assessmentId,
      this.isCreatedAsPremium,
      this.presentationLink,
      this.assessmentType});

  factory HistoryAssessment.fromJson(Map<String, dynamic> json) =>
      HistoryAssessment(
        title: Utility.utf8convert(json['title'] as String?),
        description: json['description'] as String?,
        fileId: json['id'] as String?,
        label: json['labels'],
        webContentLink: json['alternateLink'] as String?,
        createdDate: json['createdDate'] as String?,
        modifiedDate: json['modifiedDate'] as String?,
        sessionId: '',
        isCreatedAsPremium: "false",
        assessmentType: "Constructed Response",
        assessmentId: json['Assessment_Id'] as String?,
      );
}
