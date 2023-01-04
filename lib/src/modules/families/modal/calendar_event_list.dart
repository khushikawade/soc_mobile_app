import 'package:hive/hive.dart';
part 'calendar_event_list.g.dart';

@HiveType(typeId: 14)
class CalendarEventList {
  @HiveField(0)
  String? kind;
  @HiveField(1)
  String? etag;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? status;
  @HiveField(4)
  String? htmlLink;
  @HiveField(5)
  String? created;
  @HiveField(6)
  String? updated;
  @HiveField(7)
  String? summary;
  // Creator? creator;
  // Organizer? organizer;
  @HiveField(8)
  String? description;
  // Start? start;
  @HiveField(9)
  final start;
  // End? end;
  @HiveField(10)
  final end;
  @HiveField(11)
  String? iCalUid;
  @HiveField(12)
  int? sequence;
  @HiveField(13)
  String? eventType;
  @HiveField(14)
  String? month;
  @HiveField(15)
  final originalStartTime;
  @HiveField(16)
  String? monthString;

  CalendarEventList(
      {this.kind,
      this.etag,
      this.id,
      this.status,
      this.htmlLink,
      this.created,
      this.updated,
      this.summary,
      // this.creator,
      // this.organizer,
      this.description,
      this.start,
      this.end,
      this.iCalUid,
      this.sequence,
      this.eventType,
      this.month,
      this.originalStartTime,
      this.monthString});

  factory CalendarEventList.fromJson(Map<String, dynamic> json) =>
      CalendarEventList(
          kind: json['kind'] as String?,
          etag: json['etag'] as String?,
          id: json['id'] as String?,
          status: json['status'] as String?,
          htmlLink: json['htmlLink'] as String?,
          summary: json['summary'] as String?,
          description: json['description'] as String?,
          start: json['start'] ?? null,
          originalStartTime: json['originalStartTime'] ?? null,
          end: json['end'],
          iCalUid: json['iCalUID'] as String?,
          sequence: json['sequence'] as int?,
          eventType: json['eventType'] as String?,
          month: "",
          monthString: '');

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'etag': etag,
        'id': id,
        'status': status,
        'htmlLink': htmlLink,
        'created': created,
        'updated': updated,
        'summary': summary,
        'description': description,
        'start': start, //?.toJson(),
        'originalStartTime': originalStartTime,
        'end': end, //?.toJson(),
        'iCalUID': iCalUid,
        'sequence': sequence,
        'eventType': eventType,
        '': month
      };
}
