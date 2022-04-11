import '../../home/models/attributes.dart';
import 'package:hive/hive.dart';
part 'custom_setting.g.dart';

@HiveType(typeId: 11)
class CustomSetting {
  @HiveField(0)
  Attributes? attributes;
  @HiveField(1)
  String? id;
  @HiveField(2)
  final String? customBannerColorC;
  @HiveField(3)
  final String? customBannerImageC;
  // @HiveField(4)
  // String? lastModifiedDate;
  // @HiveField(5)
  // String? lastModifiedById;
  // @HiveField(6)
  // String? ownerId;
  @HiveField(4)
  String? name;
  // @HiveField(8)
  // String? createdDate;
  @HiveField(5)
  String? mobileAppSectionC;
  @HiveField(6)
  String? sectionIconC;
  @HiveField(7)
  String? sectionTitleC;
  @HiveField(8)
  double? sortOrderC;
  @HiveField(9)
  String? systemReferenceC;
  @HiveField(10)
  String? sectionTypeC;
   @HiveField(11)
  String? sectionTemplate;
  // @HiveField(15)
  // bool? isDeleted;
  // @HiveField(16)
  // String? systemModstamp;
  // @HiveField(17)
  // dynamic lastActivityDate;
  // @HiveField(18)
  // String? lastViewedDate;
  // @HiveField(19)
  // String? lastReferencedDate;
  // @HiveField(20)
  // String? connectionReceivedId;
  // @HiveField(21)
  // String? connectionSentId;
  @HiveField(12)
  String? mobileAppC;
  @HiveField(13)
  final status;
  @HiveField(14)
  final appUrlC;
  @HiveField(15)
  final pdfURL;
  @HiveField(16)
  final rtfHTMLC;
  @HiveField(17)
  final calendarId;
  @HiveField(18)
  String? rssFeed;
  // String? gridViewC;

  CustomSetting(
      {this.attributes,
      this.id,
      this.customBannerColorC,
      this.customBannerImageC,
      // this.lastModifiedDate,
      // this.lastModifiedById,
      // this.ownerId,
      this.name,
      // this.createdDate,
      this.mobileAppSectionC,
      this.sectionIconC,
      this.sectionTitleC,
      this.sortOrderC,
      this.systemReferenceC,
      this.sectionTypeC,
      // this.isDeleted,
      // this.systemModstamp,
      // this.lastActivityDate,
      // this.lastViewedDate,
      // this.lastReferencedDate,
      // this.connectionReceivedId,
      // this.connectionSentId,
      this.mobileAppC,
      this.status,
      this.appUrlC,
      this.pdfURL,
      this.rtfHTMLC,
      this.calendarId,
      this.sectionTemplate,
      this.rssFeed});

  factory CustomSetting.fromJson(Map<String, dynamic> json) => CustomSetting(
        attributes: json['attributes'] == null
            ? null
            : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        id: json['Id'] as String?,
        customBannerColorC: json['Banner_color__c'],
        customBannerImageC: json['Banner_Image_URL__c'],
        // lastModifiedDate: json['LastModifiedDate'],
        // lastModifiedById: json['LastModifiedById'],
        // ownerId: json['OwnerId'],
        name: json['Name'],
        // createdDate: json['CreatedDate'],
        sectionIconC: json['Section_Icon__c'],
        sectionTitleC: json['Section_Title__c'],
        sortOrderC: double.parse(json['Sort_Order__c'] ?? '100'),
        systemReferenceC: json['Standard_section__c'],
        sectionTypeC: json['Type_of_section__c'],
        // lastActivityDate: json['LastActivityDate'],
        // isDeleted: json['IsDeleted'].toString().toLowerCase() == 'true'
        //     ? true
        //     : false as bool?,
        mobileAppSectionC: json['Custom_App_Section__c'],
        // systemModstamp: json['SystemModstamp'],
        // lastViewedDate: json['LastViewedDate'],
        // lastReferencedDate: json['LastReferencedDate'],
        // connectionReceivedId: json['ConnectionReceivedId'],
        // connectionSentId: json['ConnectionSentId'],
        mobileAppC: json['School_App__c'],
        status: json['Active_Status__c'] ?? 'Show',
        appUrlC: json['URL__c'] as String?,
        pdfURL: json['PDF_URL__c'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        calendarId: json['Calendar_Id__c'] as String?,
        sectionTemplate: json['Type_of_page__c'] as String?,
        rssFeed: json['RSS_Feed_XML__c'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Id': id,
        'Banner_color__c': customBannerColorC,
        'Banner_Image_URL__c': customBannerImageC,
        // 'LastModifiedDate': lastModifiedDate,
        // 'LastModifiedById': lastModifiedById,
        // 'OwnerId': ownerId,
        // 'IsDeleted': isDeleted,
        'Name': name,
        // 'CreatedDate': createdDate,
        // 'LastActivityDate': lastActivityDate,
        // 'LastViewedDate': lastViewedDate,
        // 'LastReferencedDate': lastReferencedDate,
        'School_App__c': mobileAppC,
        'Section_Icon__c': sectionIconC,
        'Section_Title__c': sectionTitleC,
        'Sort_Order__c': sortOrderC,
        'Standard_section__c': systemReferenceC,
        'Type_of_section__c': sectionTypeC,
        'Custom_App_Section__c': mobileAppSectionC,
        // 'SystemModstamp': systemModstamp,
        // 'ConnectionReceivedId': connectionReceivedId,
        // 'ConnectionSentId': connectionSentId,
        'Active_Status__c': status,
        'URL__c': appUrlC,
        'PDF_URL__c': pdfURL,
        'RTF_HTML__c': rtfHTMLC,
        'Calendar_Id__c': calendarId,
        'Type_of_page__c': sectionTemplate,
        'RSS_Feed_XML__c': rssFeed
      };

  CustomSetting copyWith(
      {Attributes? attributes,
      String? id,
      final String? customBannerColorC,
      final String? customBannerImageC,
      String? lastModifiedDate,
      String? lastModifiedById,
      String? ownerId,
      String? name,
      String? createdDate,
      String? mobileAppSectionC,
      String? sectionIconC,
      String? selectionTitleC,
      double? sortOrderC,
      String? systemReferenceC,
      String? sectionTypeC,
      bool? isDeleted,
      String? systemModstamp,
      dynamic lastActivityDate,
      String? lastViewedDate,
      String? lastReferencedDate,
      String? connectionReceivedId,
      String? connectionSentId,
      String? mobileAppC,
      final status,
      String? appUrlC,
      String? pdfURL,
      String? rtfHTMLC,
      String? calendarId,
      String? sectionTemplate,
      String? rssFeed}) {
    return CustomSetting(
        attributes: attributes ?? this.attributes,
        id: id ?? this.id,
        customBannerColorC: customBannerColorC ?? this.customBannerColorC,
        customBannerImageC: customBannerImageC ?? this.customBannerImageC,
        // ownerId: ownerId ?? this.ownerId,
        // isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        // createdDate: createdDate ?? this.createdDate,
        // lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
        // lastModifiedById: lastModifiedById ?? this.lastModifiedById,
        // systemModstamp: systemModstamp ?? this.systemModstamp,
        // lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        // lastViewedDate: lastViewedDate ?? this.lastViewedDate,
        // lastReferencedDate: lastReferencedDate ?? this.lastReferencedDate,
        mobileAppC: mobileAppC ?? this.mobileAppC,
        sectionIconC: sectionIconC ?? this.sectionIconC,
        sectionTitleC: sectionTitleC ?? this.sectionTitleC,
        sortOrderC: sortOrderC ?? this.sortOrderC,
        systemReferenceC: systemReferenceC ?? this.systemReferenceC,
        sectionTypeC: sectionTypeC ?? this.sectionTypeC,
        mobileAppSectionC: mobileAppSectionC ?? this.mobileAppSectionC,
        // connectionReceivedId: connectionReceivedId ?? this.connectionReceivedId,
        // connectionSentId: connectionSentId ?? this.connectionSentId,
        status: status ?? this.status,
        appUrlC: appUrlC ?? this.appUrlC,
        pdfURL: pdfURL ?? this.pdfURL,
        rtfHTMLC: rtfHTMLC ?? this.rtfHTMLC,
        calendarId: calendarId ?? this.calendarId,
        sectionTemplate: sectionTemplate ?? this.sectionTemplate,
        rssFeed: rssFeed ?? this.rssFeed);
  }
}
