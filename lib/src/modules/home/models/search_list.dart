import 'package:Soc/src/services/utility.dart';
import 'package:hive/hive.dart';
part 'search_list.g.dart';

@HiveType(typeId: 12)
class SearchList {
  @HiveField(0)
  String? titleC;
  @HiveField(1)
  dynamic appIconUrlC;
  @HiveField(2)
  dynamic appURLC;
  @HiveField(3)
  dynamic urlC;
  @HiveField(4)
  String? id;
  @HiveField(5)
  String? rtfHTMLC;
  @HiveField(6)
  dynamic descriptionC;
  @HiveField(7)
  String? emailC;
  @HiveField(8)
  String? imageUrlC;
  @HiveField(9)
  String? phoneC;
  @HiveField(10)
  String? webURLC;
  @HiveField(11)
  String? address;
  @HiveField(12)
  var geoLocation;
  @HiveField(13)
  var statusC;
  @HiveField(14)
  double? sortOrder;
  @HiveField(15)
  String? name;
  @HiveField(16)
  String? typeC;
  @HiveField(17)
  String? pdfURL;
  @HiveField(18)
  String? deepLink;
  @HiveField(19)
  String? calendarId;
  @HiveField(20)
  String? objectName;
  @HiveField(21)
  dynamic latitude;
  @HiveField(23)
  dynamic longitude;

  SearchList(
      {this.titleC,
      this.appIconUrlC,
      this.appURLC,
      this.urlC,
      this.id,
      this.rtfHTMLC,
      this.descriptionC,
      this.emailC,
      this.imageUrlC,
      this.phoneC,
      this.webURLC,
      this.address,
      this.geoLocation,
      this.statusC,
      this.sortOrder,
      this.name,
      this.typeC,
      this.pdfURL,
      this.deepLink,
      this.calendarId,
      this.objectName,
      this.latitude,
      this.longitude});

  factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
      titleC: Utility.utf8convert(json['Title__c'] as String?),
      appIconUrlC: json['Icon_URL'] as String?,
      appURLC: json['App_URL__c'] as String?,
      urlC: json['URL__c'] as String?,
      id: json['Id'] as String?,
      rtfHTMLC: json['RTF_HTML__c'] as String?,
      descriptionC: json['Description__c'],
      emailC: json['Email__c'] as String?,
      imageUrlC: json['Image_URL__c'] as String?,
      phoneC: json['Phone__c'] as String?,
      webURLC: json['Website_URL__c'] as String?,
      address: json['Contact_Address__c'] as String?,
      geoLocation: json['Contact_Office_Location__c'],
      statusC: json['Active_Status__c'],
      sortOrder: double.parse(json['Sort_Order__c'] ?? "0.0"),
      name: json['Name'] as String?,
      typeC: json['Type__c'] as String?,
      pdfURL: json['PDF_URL__c'] as String?,
      deepLink: json['Deep_Link__c'] as String?,
      calendarId: json['Calendar_Id__c'] as String?,
      objectName: json['ObjectName'] as String?,
      latitude: json['Contact_Office_Location__Latitude__s'],
      longitude: json['Contact_Office_Location__Longitude__s']);

  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'Icon_URL': appIconUrlC,
        "App_URL__c": appURLC,
        'URL__c': urlC,
        'Id': id,
        'RTF_HTML__c': rtfHTMLC,
        'Description__c': descriptionC,
        'Email__c': emailC,
        'Image_URL__c': imageUrlC,
        'Phone__c': phoneC,
        'Website_URL__c': webURLC,
        'Contact_Address__c': address,
        'Contact_Office_Location__c': geoLocation,
        'Active_Status__c': statusC,
        'Sort_Order__c': sortOrder,
        'Name': name,
        'PDF_URL__c': pdfURL,
        'Type__c': typeC,
        'Deep_Link__c': deepLink,
        'Calendar_Id__c': calendarId,
        'ObjectName': objectName,
        'Contact_Office_Location__Latitude__s': latitude,
        'Contact_Office_Location__Longitude__s': longitude
      };
}
