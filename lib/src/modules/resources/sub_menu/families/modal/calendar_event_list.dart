class CalendarEventList {
  String? kind;
  String? etag;
  String? id;
  String? status;
  String? htmlLink;
  String? created;
  String? updated;
  String? summary;
  // Creator? creator;
  // Organizer? organizer;
  String? description;
  // Start? start;
  final start;
  // End? end;
  final end;
  String? iCalUid;
  int? sequence;
  String? eventType;

  CalendarEventList({
    this.kind,
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
  });

  factory CalendarEventList.fromJson(Map<String, dynamic> json) =>
      CalendarEventList(
        kind: json['kind'] as String?,
        etag: json['etag'] as String?,
        id: json['id'] as String?,
        status: json['status'] as String?,
        htmlLink: json['htmlLink'] as String?,
        // created: json['created'] as String?,
        // updated: json['updated'] as String?,
        summary: json['summary'] as String?,
        // creator: json['creator'] == null
        //     ? null
        //     : Creator.fromJson(json['creator'] as Map<String, dynamic>),
        // organizer: json['organizer'] == null
        //     ? null
        //     : Organizer.fromJson(json['organizer'] as Map<String, dynamic>),
        description: json['description'] as String?,
        start: json['start'],
        //  json['start'] == null
        //     ? null
        //     : Start.fromJson(json['start'] as Map<String, dynamic>),
        end: json['end'],
        // == null
        //     ? null
        //     : End.fromJson(json['end'] as Map<String, dynamic>),
        iCalUid: json['iCalUID'] as String?,
        sequence: json['sequence'] as int?,
        eventType: json['eventType'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'etag': etag,
        'id': id,
        'status': status,
        'htmlLink': htmlLink,
        'created': created,
        'updated': updated,
        'summary': summary,
        // 'creator': creator,
        // 'organizer': organizer,
        // 'start': start,
        // 'end': end,
        // 'creator': creator?.toJson(),
        // 'organizer': organizer?.toJson(),
        'description': description,
        'start': start, //?.toJson(),
        'end': end, //?.toJson(),
        'iCalUID': iCalUid,
        'sequence': sequence,
        'eventType': eventType,
      };
}
