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
  HistoryAssessment({this.title, this.description, this.fileid, this.label});

  factory HistoryAssessment.fromJson(Map<String, dynamic> json) =>
      HistoryAssessment(
          title: json['title'] as String?,
          description: json['description'] as String?,
          fileid: json['id'] as String?,
          label: json['labels']);
}
