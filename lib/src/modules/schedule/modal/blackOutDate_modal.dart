import 'package:hive/hive.dart';
part 'blackOutDate_modal.g.dart';

@HiveType(typeId: 22)
class BlackoutDate {
  BlackoutDate({
    this.id,
    // this.ownerId,
    // this.isDeleted,
    this.name,
    // this.createdDate,
    // this.createdById,
    // this.lastModifiedDate,
    // this.lastModifiedById,
    // this.systemModstamp,
    // this.lastActivityDate,
    // this.lastViewedDate,
    // this.lastReferencedDate,
    // this.connectionReceivedId,
    // this.connectionSentId,
    this.startDateC,
    this.endDateC,
    this.titleC,
    this.schoolYearC,
    this.scheduleSchoolTypeC,
  });
  @HiveField(0)
  String? id;
  // String? ownerId;
  // String? isDeleted;
  @HiveField(1)
  String? name;
  // String? createdDate;
  // String? createdById;
  // String? lastModifiedDate;
  // String? lastModifiedById;
  // String? systemModstamp;
  // dynamic lastActivityDate;
  // String? lastViewedDate;
  // String? lastReferencedDate;
  // dynamic connectionReceivedId;
  // dynamic connectionSentId;
  @HiveField(2)
  DateTime? startDateC;
  @HiveField(3)
  DateTime? endDateC;
  @HiveField(4)
  String? titleC;
  @HiveField(5)
  String? schoolYearC;
  @HiveField(6)
  String? scheduleSchoolTypeC;

  factory BlackoutDate.fromJson(Map<String?, dynamic> json) => BlackoutDate(
        id: json["Id"] == null ? null : json["Id"],
        // ownerId: json["OwnerId"] == null ? null : json["OwnerId"],
        // isDeleted: json["IsDeleted"] == null ? null : json["IsDeleted"],
        name: json["Name"] == null ? null : json["Name"],
        // createdDate: json["CreatedDate"] == null ? null : json["CreatedDate"],
        // createdById: json["CreatedById"] == null ? null : json["CreatedById"],
        // lastModifiedDate:
        //     json["LastModifiedDate"] == null ? null : json["LastModifiedDate"],
        // lastModifiedById:
        //     json["LastModifiedById"] == null ? null : json["LastModifiedById"],
        // systemModstamp:
        //     json["SystemModstamp"] == null ? null : json["SystemModstamp"],
        // lastActivityDate: json["LastActivityDate"],
        // lastViewedDate:
        //     json["LastViewedDate"] == null ? null : json["LastViewedDate"],
        // lastReferencedDate: json["LastReferencedDate"] == null
        //     ? null
        //     : json["LastReferencedDate"],
        // connectionReceivedId: json["ConnectionReceivedId"],
        // connectionSentId: json["ConnectionSentId"],
        startDateC: json["Start_Date__c"] == null
            ? null
            : DateTime.parse(json["Start_Date__c"]),
        endDateC: json["End_Date__c"] == null
            ? null
            : DateTime.parse(json["End_Date__c"]),
        titleC: json["Title__c"] == null ? null : json["Title__c"],
        schoolYearC:
            json["School_Year__c"] == null ? null : json["School_Year__c"],
        scheduleSchoolTypeC: json["Schedule_School_Type__c"] == null
            ? null
            : json["Schedule_School_Type__c"],
      );

  Map<String?, dynamic> toJson() => {
        "Id": id == null ? null : id,
        // "OwnerId": ownerId == null ? null : ownerId,
        // "IsDeleted": isDeleted == null ? null : isDeleted,
        "Name": name == null ? null : name,
        // "CreatedDate": createdDate == null ? null : createdDate,
        // "CreatedById": createdById == null ? null : createdById,
        // "LastModifiedDate": lastModifiedDate == null ? null : lastModifiedDate,
        // "LastModifiedById": lastModifiedById == null ? null : lastModifiedById,
        // "SystemModstamp": systemModstamp == null ? null : systemModstamp,
        // "LastActivityDate": lastActivityDate,
        // "LastViewedDate": lastViewedDate == null ? null : lastViewedDate,
        // "LastReferencedDate":
        //     lastReferencedDate == null ? null : lastReferencedDate,
        // "ConnectionReceivedId": connectionReceivedId,
        // "ConnectionSentId": connectionSentId,
        "Start_Date__c": startDateC == null
            ? null
            : "${startDateC!.year.toString().padLeft(4, '0')}-${startDateC!.month.toString().padLeft(2, '0')}-${startDateC!.day.toString().padLeft(2, '0')}",
        "End_Date__c": endDateC == null
            ? null
            : "${endDateC!.year.toString().padLeft(4, '0')}-${endDateC!.month.toString().padLeft(2, '0')}-${endDateC!.day.toString().padLeft(2, '0')}",
        "Title__c": titleC == null ? null : titleC,
        "School_Year__c": schoolYearC == null ? null : schoolYearC,
        "Schedule_School_Type__c":
            scheduleSchoolTypeC == null ? null : scheduleSchoolTypeC,
      };
}
