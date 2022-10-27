import 'package:Soc/src/services/utility.dart';
import 'package:hive/hive.dart';
part 'shared_list.g.dart';

@HiveType(typeId: 2)
class SharedList {
  @HiveField(0)
  String? titleC;
  @HiveField(1)
  String? appIconC;
  @HiveField(2)
  String? appIconUrlC;
  @HiveField(3)
  String? appUrlC;
  @HiveField(4)
  String? pdfURL;
  @HiveField(5)
  String? id;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? rtfHTMLC;
  @HiveField(8)
  String? typeC;
  @HiveField(9)
  String? calendarId;
  @HiveField(10)
  final sortOrder;
  @HiveField(11)
  final status;
  @HiveField(12)
  String? deepLinkC;
  @HiveField(13)
  String? darkModeIconC;
  @HiveField(14)
  String? isSecure;
  @HiveField(15)
  String? submenuBannerImageC;
  @HiveField(16)
  String? submenuBannerColorC;
  @HiveField(17)
  double? submenuBannerHeightC;

  SharedList(
      {
      // this.attributes,
      this.titleC,
      this.appIconC,
      this.appUrlC,
      this.pdfURL,
      this.id,
      this.name,
      this.rtfHTMLC,
      this.appIconUrlC,
      this.typeC,
      this.calendarId,
      this.sortOrder,
      this.status,
      this.deepLinkC,
      this.darkModeIconC,
      this.isSecure,
      this.submenuBannerImageC,
      this.submenuBannerColorC,
      this.submenuBannerHeightC});

  factory SharedList.fromJson(Map<String, dynamic> json) => SharedList(
      titleC: Utility.utf8convert(json['Title__c'] as String?),
      appIconC: json['App_Icon__c'] as String?,
      appIconUrlC: json['App_Icon_URL__c'] as String?,
      appUrlC: json['URL__c'] as String?,
      pdfURL: json['PDF_URL__c'] as String?,
      id: json['Id'] as String?,
      name: json['Name'] as String?,
      rtfHTMLC: json['RTF_HTML__c'] as String?,
      typeC: json['Type__c'] as String?,
      calendarId: json['Calendar_Id__c'] as String?,
      sortOrder: double.parse(json['Sort_Order__c'] ?? '100'),
      status: json['Active_Status__c'] ?? 'Show',
      deepLinkC: json['Deep_Link__c'] as String?,
      darkModeIconC: json['Dark_Mode_Icon__c'],
      isSecure: json['Is_Secure__c'],
      submenuBannerImageC: json['Submenu_Banner_Image_URL__c'],
      submenuBannerColorC: json['Submenu_Banner_Hex_Color__c'],
      submenuBannerHeightC: double.parse(json['Banner_Height_Factor__c'] != null
          ? json['Banner_Height_Factor__c'].toString()
          : "12.0"));

  Map<String, dynamic> toJson() => {
        // 'attributes': attributes?.toJson(),
        'Title__c': titleC,
        'App_Icon__c': appIconC,
        'URL__c': appUrlC,
        'PDF_URL__c': pdfURL,
        'Id': id,
        'Name': name,
        'RTF_HTML__c': rtfHTMLC,
        'Type__c': typeC,
        'Calendar_Id__c': calendarId,
        'Sort_Order__c': sortOrder,
        'App_Icon_URL__c': appIconUrlC,
        'Active_Status__c': status,
        'Deep_Link__c': deepLinkC,
        'Dark_Mode_Icon__c': darkModeIconC,
        'Is_Secure__c': isSecure,
        'Submenu_Banner_Image_URL__c': submenuBannerImageC,
        'Submenu_Banner_Hex_Color__c': submenuBannerColorC,
        'Banner_Height_Factor__c': submenuBannerHeightC
      };
}
