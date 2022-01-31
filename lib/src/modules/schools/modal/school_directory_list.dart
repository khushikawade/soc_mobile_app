import 'package:hive/hive.dart';
part 'school_directory_list.g.dart';

@HiveType(typeId: 4)
class SchoolDirectoryList {
  // SubAttributes? attributes;
  @HiveField(0)
  String? titleC;
  @HiveField(1)
  String? imageUrlC;
  @HiveField(2)
  String? address;
  @HiveField(3)
  String? phoneC;
  @HiveField(4)
  String? rtfHTMLC;
  @HiveField(5)
  String? emailC;
  @HiveField(6)
  final geoLocation;
  @HiveField(7)
  String? urlC;
  @HiveField(8)
  String? id;
  @HiveField(9)
  final sortOrder;
  @HiveField(10)
  final statusC;
  @HiveField(11)
  dynamic latitude;
  @HiveField(12)
  dynamic longitude;

  SchoolDirectoryList(
      {this.titleC,
      this.imageUrlC,
      this.address,
      this.phoneC,
      this.rtfHTMLC,
      this.emailC,
      this.geoLocation,
      this.urlC,
      this.id,
      this.sortOrder,
      this.statusC,
      this.latitude,
      this.longitude});

  factory SchoolDirectoryList.fromJson(Map<String, dynamic> json) =>
      SchoolDirectoryList(
          titleC: json['Title__c'] as String?,
          imageUrlC: json['Image_URL__c'] as String?,
          address: json['Contact_Address__c'] as String?,
          phoneC: json['phoneC__c'] as String?,
          rtfHTMLC: json['RTF_HTML__c'] as String?,
          emailC: json['emailC__c'] as String?,
          geoLocation: json['Contact_Office_Location__c'],
          urlC: json['Website_URL__c'] as String?,
          id: json['Id'] as String?,
          sortOrder: json['Sort_Order__c'],
          statusC: json['Active_Status__c'],
          latitude: json['Contact_Office_Location__Latitude__s'],
          longitude: json['Contact_Office_Location__Longitude__s']);

  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'Image_URL__c': imageUrlC,
        'Contact_Address__c': address,
        'phoneC__c': phoneC,
        'RTF_HTML__c': rtfHTMLC,
        'emailC__c': emailC,
        'Contact_Office_Location__c': geoLocation,
        'Website_URL__c': urlC,
        'Id': id,
        'Sort_Order__c': sortOrder,
        'Active_Status__c': statusC,
        'Contact_Office_Location__Latitude__s': latitude,
        'Contact_Office_Location__Longitude__s': longitude
      };
}
