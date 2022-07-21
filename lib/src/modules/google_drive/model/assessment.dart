import 'package:hive/hive.dart';
part 'assessment.g.dart';

@HiveType(typeId: 16)
class HistoryAssessment {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? fileid;
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
  HistoryAssessment(
      {this.title,
      this.description,
      this.fileid,
      this.label,
      this.webContentLink,
      this.createdDate,
      this.modifiedDate,this.sessionId,this.isCreatedAsPremium});

  factory HistoryAssessment.fromJson(Map<String, dynamic> json) =>
      HistoryAssessment(
        title: json['title'] as String?,
        description: json['description'] as String?,
        fileid: json['id'] as String?,
        label: json['labels'],
        webContentLink: json['alternateLink'] as String?,
        createdDate: json['createdDate'] as String?,
        modifiedDate: json['modifiedDate'] as String?,
        sessionId: '',
        isCreatedAsPremium: "false",
      );
}
