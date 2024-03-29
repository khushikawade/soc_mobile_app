import 'attributes.dart';
import 'package:hive/hive.dart';
part 'app_setting.g.dart';

@HiveType(typeId: 0)
class AppSetting {
  @HiveField(0)
  Attributes? attributes;
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? ownerId;
  @HiveField(3)
  bool? isDeleted;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? createdDate;
  @HiveField(6)
  String? createdById;
  @HiveField(7)
  String? lastModifiedDate;
  @HiveField(8)
  String? lastModifiedById;
  @HiveField(9)
  String? systemModstamp;
  @HiveField(10)
  dynamic lastActivityDate;
  @HiveField(11)
  String? lastViewedDate;
  @HiveField(12)
  String? lastReferencedDate;
  @HiveField(13)
  String? schoolNameC; //Account Id
  @HiveField(14)
  String? contactNameC;
  @HiveField(15)
  String? appIconC;
  @HiveField(16)
  dynamic splashScreenC;
  @HiveField(17)
  String? primaryColorC;
  @HiveField(18)
  String? backgroundColorC;
  @HiveField(19)
  String? secondaryColorC;
  @HiveField(20)
  String? fontColorC;
  @HiveField(21)
  dynamic appLogoC;
  @HiveField(22)
  dynamic fullLogoC;
  @HiveField(23)
  String? bottomNavigationC;
  @HiveField(24)
  String? appBuildStatusC;
  @HiveField(25)
  String? appInformationC;
  @HiveField(26)
  String? contactEmailC;
  @HiveField(27)
  String? contactPhoneC;
  @HiveField(28)
  String? contactAddressC;
  @HiveField(29)
  String? socialapiurlc;
  @HiveField(30)
  dynamic contactOfficeLocationLatitudeS;
  @HiveField(31)
  dynamic contactOfficeLocationLongitudeS;
  @HiveField(32)
  dynamic bannerHeightFactor;
  @HiveField(33)
  final String? familyBannerImageC;
  @HiveField(34)
  final String? staffBannerImageC;
  @HiveField(35)
  final String? studentBannerImageC;
  @HiveField(36)
  final String? aboutBannerImageC;
  @HiveField(37)
  final String? schoolBannerImageC;
  @HiveField(38)
  final String? resourcesBannerImageC;
  @HiveField(39)
  final dynamic playStoreUrlC;
  @HiveField(40)
  final dynamic appStoreUrlC;
  @HiveField(41)
  final dynamic bannerHeightFactorC;
  @HiveField(42)
  final String? familyBannerColorC;
  @HiveField(43)
  final String? staffBannerColorC;
  @HiveField(44)
  final String? studentBannerColorC;
  @HiveField(45)
  final String? aboutBannerColorC;
  @HiveField(46)
  final String? schoolBannerColorC;
  @HiveField(47)
  final String? resourcesBannerColorC;
  @HiveField(48)
  final String? contactImageC;
  @HiveField(49)
  final isTestSchool;
  @HiveField(50)
  bool? isCustomApp;
  @HiveField(51)
  bool? disableDarkMode;
  @HiveField(52)
  String? authenticationURL;
  @HiveField(53)
  String? enableGraded;
  @HiveField(54)
  String? darkmodeIconColor;
  @HiveField(55)
  String? parentCoordinatorEmailc;
  @HiveField(56)
  String? calendarId;
  @HiveField(57)
  String? calendarBannerImage;
  @HiveField(58)
  String? calendarBannerColor;
  @HiveField(59)
  String? dashboardUrlC;
  @HiveField(60)
  String? enableGoogleSSO;

  @HiveField(61)
  String? enablenycDocLogin;
  @HiveField(62)
  String? nycDocLoginUrl; //NYCDOE

  AppSetting(
      {this.attributes,
      this.id,
      this.ownerId,
      this.isDeleted,
      this.name,
      this.createdDate,
      this.createdById,
      this.lastModifiedDate,
      this.lastModifiedById,
      this.systemModstamp,
      this.lastActivityDate,
      this.lastViewedDate,
      this.lastReferencedDate,
      this.schoolNameC,
      this.contactNameC,
      this.appIconC,
      this.splashScreenC,
      this.primaryColorC,
      this.backgroundColorC,
      this.secondaryColorC,
      this.fontColorC,
      this.appLogoC,
      this.fullLogoC,
      this.bottomNavigationC,
      this.appBuildStatusC,
      this.appInformationC,
      this.contactEmailC,
      this.contactPhoneC,
      this.contactAddressC,
      this.socialapiurlc,
      this.contactOfficeLocationLatitudeS,
      this.contactOfficeLocationLongitudeS,
      this.bannerHeightFactor,
      this.familyBannerImageC,
      this.staffBannerImageC,
      this.studentBannerImageC,
      this.aboutBannerImageC,
      this.schoolBannerImageC,
      this.resourcesBannerImageC,
      this.playStoreUrlC,
      this.appStoreUrlC,
      this.bannerHeightFactorC,
      this.familyBannerColorC,
      this.staffBannerColorC,
      this.studentBannerColorC,
      this.aboutBannerColorC,
      this.schoolBannerColorC,
      this.resourcesBannerColorC,
      this.contactImageC,
      this.isTestSchool,
      this.isCustomApp,
      this.disableDarkMode,
      this.authenticationURL,
      this.enableGraded,
      this.darkmodeIconColor,
      this.parentCoordinatorEmailc,
      this.calendarId,
      this.calendarBannerImage,
      // this.calendarBannerColor,this.dashboardUrlC//Dashboard_URL__c
      this.calendarBannerColor,
      this.dashboardUrlC,
      this.enableGoogleSSO,
      this.enablenycDocLogin,
      this.nycDocLoginUrl});

  factory AppSetting.fromJson(Map<String, dynamic> json) => AppSetting(
      attributes: json['attributes'] == null
          ? null
          : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
      id: json['Id'] as String?,
      ownerId: json['OwnerId'] as String?,
      isDeleted: json['IsDeleted'].toString().toLowerCase() == 'true'
          ? true
          : false as bool?,
      name: json['Name'] as String?,
      createdDate: json['CreatedDate'] as String?,
      createdById: json['CreatedById'] as String?,
      lastModifiedDate: json['LastModifiedDate'] as String?,
      lastModifiedById: json['LastModifiedById'] as String?,
      systemModstamp: json['SystemModstamp'] as String?,
      lastActivityDate: json['LastActivityDate'],
      lastViewedDate: json['LastViewedDate'] as String?,
      lastReferencedDate: json['LastReferencedDate'] as String?,
      schoolNameC: json['School_Name__c'] as String?,
      contactNameC: json['Contact_Name__c'] as String?,
      appIconC: json['App_Icon__c'] as String?,
      splashScreenC: json['Splash_Screen__c'],
      primaryColorC: json['Primary_Color__c'] as String?,
      backgroundColorC: json['Background_Color__c'] as String?,
      secondaryColorC: json['Secondary_Color__c'] as String?,
      fontColorC: json['Font_Color__c'] as String?,
      appLogoC: json['App_Logo__c'],
      fullLogoC: json['Full_Logo__c'],
      bottomNavigationC: json['Bottom_Navigation__c'] as String?,
      appBuildStatusC: json['App_Build_Status__c'] as String?,
      appInformationC: json['App_Information__c'] as String?,
      contactEmailC: json['Contact_Email__c'] as String?,
      contactPhoneC: json['Contact_Phone__c'] as String?,
      contactAddressC: json['Contact_Address__c'] as String?,
      socialapiurlc: json['Social_API_URL__c'] as String?,
      contactOfficeLocationLatitudeS: double.parse(
          json['Contact_Office_Location__Latitude__s'] != null
              ? json['Contact_Office_Location__Latitude__s'].toString()
              : "0.0"),
      contactOfficeLocationLongitudeS: double.parse(
          json['Contact_Office_Location__Longitude__s'] != null
              ? json['Contact_Office_Location__Longitude__s'].toString()
              : "0.0"),
      bannerHeightFactor: double.parse(json['Banner_Height_Factor__c'] != null
          ? json['Banner_Height_Factor__c'].toString()
          : "12.0"),
      familyBannerImageC: json['Family_Banner_Image__c'] as String?,
      staffBannerImageC: json['Staff_Banner_Image__c'] as String?,
      studentBannerImageC: json['Student_Banner_Image__c'] as String?,
      aboutBannerImageC: json['About_Banner_Image__c'] as String?,
      schoolBannerImageC: json['School_Banner_Image__c'] as String?,
      resourcesBannerImageC: json['Resources_Banner_Image__c'] as String?,
      playStoreUrlC: json['Play_Store_URL__c'] as String?,
      appStoreUrlC: json['App_Store_URL__c'] as String?,
      bannerHeightFactorC: double.parse(json['Banner_Height_Factor__c'] != null
          ? json['Banner_Height_Factor__c'].toString()
          : "12.0"),
      familyBannerColorC: json['Family_Banner_Color__c'] as String?,
      staffBannerColorC: json['Staff_Banner_Color__c'] as String?,
      studentBannerColorC: json['Student_Banner_Color__c'] as String?,
      aboutBannerColorC: json['About_Banner_Color__c'] as String?,
      schoolBannerColorC: json['School_Banner_Color__c'] as String?,
      resourcesBannerColorC: json['Resources_Banner_Color__c'] as String?,
      contactImageC: json['Contact_Image__c'] as String?,
      isTestSchool: json['Test_School__c'].toString().toLowerCase() == 'true'
          ? true
          : false as bool?,
      isCustomApp:
          json['Needs_Custom_App__c'].toString().toLowerCase() == 'true'
              ? true
              : false as bool?,
      disableDarkMode: json['Disable_Dark_Mode__c'].toString().toLowerCase() == 'true' ? true : false as bool?,
      authenticationURL: json['Authentication_URL__c'] as String?,
      enableGraded: json['Enable_GradEd__c'] as String?,
      darkmodeIconColor: json['Dark_Mode_Icon_Color__c'] as String?,
      parentCoordinatorEmailc: json['Parent_Coordinator_Email__c'] as String?,
      calendarId: json['Calendar_Id__c'],
      calendarBannerImage: json['Calendar_Banner_Image__c'],
      calendarBannerColor: json['Calendar_Banner_Color__c'],
      dashboardUrlC: json['Dashboard_URL__c'],
      enableGoogleSSO: json['Enable_Google_SSO__c'] as String?,
      enablenycDocLogin: json["Enable_NYC_DOE__c"],
      nycDocLoginUrl: json['NYC_DOE_Google_Login_URL__c']);

  Map<String, dynamic> toJson() => {
        'attributes': attributes?.toJson(),
        'Id': id,
        'OwnerId': ownerId,
        'IsDeleted': isDeleted,
        'Name': name,
        'CreatedDate': createdDate,
        'CreatedById': createdById,
        'LastModifiedDate': lastModifiedDate,
        'LastModifiedById': lastModifiedById,
        'SystemModstamp': systemModstamp,
        'LastActivityDate': lastActivityDate,
        'LastViewedDate': lastViewedDate,
        'LastReferencedDate': lastReferencedDate,
        'School_Name__c': schoolNameC,
        'Contact_Name__c': contactNameC,
        'App_Icon__c': appIconC,
        'Splash_Screen__c': splashScreenC,
        'Primary_Color__c': primaryColorC,
        'Background_Color__c': backgroundColorC,
        'Secondary_Color__c': secondaryColorC,
        'Font_Color__c': fontColorC,
        'App_Logo__c': appLogoC,
        'Full_Logo__c': fullLogoC,
        'Bottom_Navigation__c': bottomNavigationC,
        'App_Build_Status__c': appBuildStatusC,
        'App_Information__c': appInformationC,
        'Contact_Email__c': contactEmailC,
        'Contact_Phone__c': contactPhoneC,
        'Contact_Address__c': contactAddressC,
        'Social_API_URL__c': socialapiurlc,
        'Contact_Office_Location__Latitude__s': contactOfficeLocationLatitudeS,
        'Contact_Office_Location__Longitude__s':
            contactOfficeLocationLongitudeS,
        'Family_Banner_Image__c': familyBannerImageC,
        'Staff_Banner_Image__c': staffBannerImageC,
        'Student_Banner_Image__c': studentBannerImageC,
        'About_Banner_Image__c': aboutBannerImageC,
        'School_Banner_Image__c': schoolBannerImageC,
        'Resources_Banner_Image__c': resourcesBannerImageC,
        'Play_Store_URL__c': playStoreUrlC,
        'App_Store_URL__c': appStoreUrlC,
        'Banner_Height_Factor__c': bannerHeightFactorC,
        'Family_Banner_Color__c': familyBannerColorC,
        'Staff_Banner_Color__c': staffBannerColorC,
        'Student_Banner_Color__c': studentBannerColorC,
        'About_Banner_Color__c': aboutBannerColorC,
        'School_Banner_Color__c': schoolBannerColorC,
        'Resources_Banner_Color__c': resourcesBannerColorC,
        'Contact_Image__c': contactImageC,
        'Test_School__c': isTestSchool,
        'Needs_Custom_App__c': isCustomApp,
        'Disable_Dark_Mode__c': disableDarkMode,
        'Authentication_URL__c': authenticationURL,
        'Enable_GradEd': enableGraded,
        'Dark_Mode_Icon_Color__c': darkmodeIconColor,
        'Parent_Coordinator_Email__c': parentCoordinatorEmailc,
        'Calendar_Id__c': calendarId,
        'Calendar_Banner_Image__c': calendarBannerImage,
        'Calendar_Banner_Color__c': calendarBannerColor,
        'Dashboard_URL__c': dashboardUrlC,
        'Enable_Google_SSO__c': enableGoogleSSO,
        'Enable_NYC_DOE__c': enablenycDocLogin,
        'NYC_DOE_Google_Login_URL__c': nycDocLoginUrl
      };

  AppSetting copyWith(
      {Attributes? attributes,
      String? id,
      String? ownerId,
      bool? isDeleted,
      String? name,
      String? createdDate,
      String? createdById,
      String? lastModifiedDate,
      String? lastModifiedById,
      String? systemModstamp,
      dynamic lastActivityDate,
      String? lastViewedDate,
      String? lastReferencedDate,
      String? schoolNameC,
      String? contactNameC,
      String? appIconC,
      dynamic splashScreenC,
      String? primaryColorC,
      String? backgroundColorC,
      String? secondaryColorC,
      String? fontColorC,
      dynamic appLogoC,
      dynamic fullLogoC,
      String? bottomNavigationC,
      String? appBuildStatusC,
      String? appInformationC,
      String? contactEmailC,
      String? contactPhoneC,
      String? contactAddressC,
      String? socialapiurlc,
      double? contactOfficeLocationLatitudeS,
      double? contactOfficeLocationLongitudeS,
      String? familyBannerImageC,
      String? staffBannerImageC,
      String? studentBannerImageC,
      String? aboutBannerImageC,
      String? schoolBannerImageC,
      String? resourcesBannerImageC,
      dynamic playStoreUrlC,
      dynamic appStoreUrlC,
      dynamic bannerHeightFactorC,
      String? familyBannerColorC,
      String? staffBannerColorC,
      String? studentBannerColorC,
      String? aboutBannerColorC,
      String? schoolBannerColorC,
      String? resourcesBannerColorC,
      String? contactImageC,
      bool? isTestSchool,
      bool? isCustomApp,
      bool? disableDarkMode,
      String? authenticationURL,
      String? enableGraded,
      String? darkmodeIconColor,
      bool? isPremiumUser,
      String? dbnC,
      String? parentCoordinatorEmailc,
      String? calendarId,
      String? calendarBannerImage,
      String? calendarBannerColor,
      String? dashboardUrlC,
      String? enableGoogleSSO}) {
    return AppSetting(
        attributes: attributes ?? this.attributes,
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        isDeleted: isDeleted ?? this.isDeleted,
        name: name ?? this.name,
        createdDate: createdDate ?? this.createdDate,
        createdById: createdById ?? this.createdById,
        lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
        lastModifiedById: lastModifiedById ?? this.lastModifiedById,
        systemModstamp: systemModstamp ?? this.systemModstamp,
        lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        lastViewedDate: lastViewedDate ?? this.lastViewedDate,
        lastReferencedDate: lastReferencedDate ?? this.lastReferencedDate,
        schoolNameC: schoolNameC ?? this.schoolNameC,
        contactNameC: contactNameC ?? this.contactNameC,
        appIconC: appIconC ?? this.appIconC,
        splashScreenC: splashScreenC ?? this.splashScreenC,
        primaryColorC: primaryColorC ?? this.primaryColorC,
        backgroundColorC: backgroundColorC ?? this.backgroundColorC,
        secondaryColorC: secondaryColorC ?? this.secondaryColorC,
        fontColorC: fontColorC ?? this.fontColorC,
        appLogoC: appLogoC ?? this.appLogoC,
        fullLogoC: fullLogoC ?? this.fullLogoC,
        bottomNavigationC: bottomNavigationC ?? this.bottomNavigationC,
        appBuildStatusC: appBuildStatusC ?? this.appBuildStatusC,
        appInformationC: appInformationC ?? this.appInformationC,
        contactEmailC: contactEmailC ?? this.contactEmailC,
        contactPhoneC: contactPhoneC ?? this.contactPhoneC,
        socialapiurlc: socialapiurlc ?? this.socialapiurlc,
        contactAddressC: contactAddressC ?? this.contactAddressC,
        contactOfficeLocationLatitudeS: contactOfficeLocationLatitudeS ??
            this.contactOfficeLocationLatitudeS,
        contactOfficeLocationLongitudeS: contactOfficeLocationLongitudeS ??
            this.contactOfficeLocationLongitudeS,
        familyBannerImageC: familyBannerImageC ?? this.familyBannerImageC,
        staffBannerImageC: staffBannerImageC ?? this.staffBannerImageC,
        studentBannerImageC: studentBannerImageC ?? this.studentBannerImageC,
        aboutBannerImageC: aboutBannerImageC ?? this.aboutBannerImageC,
        schoolBannerImageC: schoolBannerImageC ?? this.schoolBannerImageC,
        resourcesBannerImageC:
            resourcesBannerImageC ?? this.resourcesBannerImageC,
        playStoreUrlC: playStoreUrlC ?? this.playStoreUrlC,
        appStoreUrlC: appStoreUrlC ?? this.appStoreUrlC,
        bannerHeightFactorC: bannerHeightFactorC ?? this.bannerHeightFactorC,
        familyBannerColorC: familyBannerColorC ?? this.familyBannerColorC,
        staffBannerColorC: staffBannerColorC ?? this.staffBannerColorC,
        studentBannerColorC: studentBannerColorC ?? this.studentBannerColorC,
        aboutBannerColorC: aboutBannerColorC ?? this.aboutBannerColorC,
        schoolBannerColorC: schoolBannerColorC ?? this.schoolBannerColorC,
        resourcesBannerColorC:
            resourcesBannerColorC ?? this.resourcesBannerColorC,
        contactImageC: contactImageC ?? this.contactImageC,
        isTestSchool: isTestSchool ?? this.isTestSchool,
        isCustomApp: isCustomApp ?? this.isCustomApp,
        disableDarkMode: disableDarkMode ?? this.disableDarkMode,
        authenticationURL: authenticationURL ?? this.authenticationURL,
        enableGraded: enableGraded ?? this.enableGraded,
        darkmodeIconColor: darkmodeIconColor ?? this.darkmodeIconColor,
        parentCoordinatorEmailc:
            parentCoordinatorEmailc ?? this.parentCoordinatorEmailc,
        calendarId: calendarId ?? this.calendarId,
        calendarBannerImage: calendarBannerImage ?? this.aboutBannerImageC,
        calendarBannerColor: calendarBannerColor ?? this.aboutBannerColorC,
        dashboardUrlC: dashboardUrlC ?? this.dashboardUrlC,
        enableGoogleSSO: enableGoogleSSO ?? this.enableGoogleSSO);
  }
}
