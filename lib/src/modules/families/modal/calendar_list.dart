import 'package:Soc/src/modules/families/modal/calendar_attribute.dart';

class CalendarList {
  CalendarAttributes? attributes;
  String? titleC;
  String? startDate;
  String? endDate;
  String? inviteLink;
  String? description;

  CalendarList(
      {this.attributes,
      this.titleC,
      this.startDate,
      this.endDate,
      this.inviteLink,
      this.description});

  factory CalendarList.fromJson(Map<String, dynamic> json) => CalendarList(
        attributes: json['attributes'] == null
            ? null
            : CalendarAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>),
        titleC: json['Title__c'] as String?,
        startDate: json['Start_Date__c'] as String?,
        endDate: json['End_Date__c'] as String?,
        inviteLink: json['Invite_Link__c'] as String?,
        description: json['Description__c'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'Start_Date__c': startDate,
        'End_Date__c': endDate,
        'Invite_Link__c': inviteLink,
        'Description__c': description,
      };
}
