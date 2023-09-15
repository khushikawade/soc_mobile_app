// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingAdapter extends TypeAdapter<AppSetting> {
  @override
  final int typeId = 0;

  @override
  AppSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSetting(
      attributes: fields[0] as Attributes?,
      id: fields[1] as String?,
      ownerId: fields[2] as String?,
      isDeleted: fields[3] as bool?,
      name: fields[4] as String?,
      createdDate: fields[5] as String?,
      createdById: fields[6] as String?,
      lastModifiedDate: fields[7] as String?,
      lastModifiedById: fields[8] as String?,
      systemModstamp: fields[9] as String?,
      lastActivityDate: fields[10] as dynamic,
      lastViewedDate: fields[11] as String?,
      lastReferencedDate: fields[12] as String?,
      schoolNameC: fields[13] as String?,
      contactNameC: fields[14] as String?,
      appIconC: fields[15] as String?,
      splashScreenC: fields[16] as dynamic,
      primaryColorC: fields[17] as String?,
      backgroundColorC: fields[18] as String?,
      secondaryColorC: fields[19] as String?,
      fontColorC: fields[20] as String?,
      appLogoC: fields[21] as dynamic,
      fullLogoC: fields[22] as dynamic,
      bottomNavigationC: fields[23] as String?,
      appBuildStatusC: fields[24] as String?,
      appInformationC: fields[25] as String?,
      contactEmailC: fields[26] as String?,
      contactPhoneC: fields[27] as String?,
      contactAddressC: fields[28] as String?,
      socialapiurlc: fields[29] as String?,
      contactOfficeLocationLatitudeS: fields[30] as dynamic,
      contactOfficeLocationLongitudeS: fields[31] as dynamic,
      bannerHeightFactor: fields[32] as dynamic,
      familyBannerImageC: fields[33] as String?,
      staffBannerImageC: fields[34] as String?,
      studentBannerImageC: fields[35] as String?,
      aboutBannerImageC: fields[36] as String?,
      schoolBannerImageC: fields[37] as String?,
      resourcesBannerImageC: fields[38] as String?,
      playStoreUrlC: fields[39] as dynamic,
      appStoreUrlC: fields[40] as dynamic,
      bannerHeightFactorC: fields[41] as dynamic,
      familyBannerColorC: fields[42] as String?,
      staffBannerColorC: fields[43] as String?,
      studentBannerColorC: fields[44] as String?,
      aboutBannerColorC: fields[45] as String?,
      schoolBannerColorC: fields[46] as String?,
      resourcesBannerColorC: fields[47] as String?,
      contactImageC: fields[48] as String?,
      isTestSchool: fields[49] as dynamic,
      isCustomApp: fields[50] as bool?,
      disableDarkMode: fields[51] as bool?,
      authenticationURL: fields[52] as String?,
      enableGraded: fields[53] as String?,
      darkmodeIconColor: fields[54] as String?,
      parentCoordinatorEmailc: fields[55] as String?,
      calendarId: fields[56] as String?,
      calendarBannerImage: fields[57] as String?,
      calendarBannerColor: fields[58] as String?,
      dashboardUrlC: fields[59] as String?,
      enableGoogleSSO: fields[60] as String?,
      enablenycDocLogin: fields[61] as String?,
      nycDocLoginUrl: fields[62] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSetting obj) {
    writer
      ..writeByte(63)
      ..writeByte(0)
      ..write(obj.attributes)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.ownerId)
      ..writeByte(3)
      ..write(obj.isDeleted)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.createdById)
      ..writeByte(7)
      ..write(obj.lastModifiedDate)
      ..writeByte(8)
      ..write(obj.lastModifiedById)
      ..writeByte(9)
      ..write(obj.systemModstamp)
      ..writeByte(10)
      ..write(obj.lastActivityDate)
      ..writeByte(11)
      ..write(obj.lastViewedDate)
      ..writeByte(12)
      ..write(obj.lastReferencedDate)
      ..writeByte(13)
      ..write(obj.schoolNameC)
      ..writeByte(14)
      ..write(obj.contactNameC)
      ..writeByte(15)
      ..write(obj.appIconC)
      ..writeByte(16)
      ..write(obj.splashScreenC)
      ..writeByte(17)
      ..write(obj.primaryColorC)
      ..writeByte(18)
      ..write(obj.backgroundColorC)
      ..writeByte(19)
      ..write(obj.secondaryColorC)
      ..writeByte(20)
      ..write(obj.fontColorC)
      ..writeByte(21)
      ..write(obj.appLogoC)
      ..writeByte(22)
      ..write(obj.fullLogoC)
      ..writeByte(23)
      ..write(obj.bottomNavigationC)
      ..writeByte(24)
      ..write(obj.appBuildStatusC)
      ..writeByte(25)
      ..write(obj.appInformationC)
      ..writeByte(26)
      ..write(obj.contactEmailC)
      ..writeByte(27)
      ..write(obj.contactPhoneC)
      ..writeByte(28)
      ..write(obj.contactAddressC)
      ..writeByte(29)
      ..write(obj.socialapiurlc)
      ..writeByte(30)
      ..write(obj.contactOfficeLocationLatitudeS)
      ..writeByte(31)
      ..write(obj.contactOfficeLocationLongitudeS)
      ..writeByte(32)
      ..write(obj.bannerHeightFactor)
      ..writeByte(33)
      ..write(obj.familyBannerImageC)
      ..writeByte(34)
      ..write(obj.staffBannerImageC)
      ..writeByte(35)
      ..write(obj.studentBannerImageC)
      ..writeByte(36)
      ..write(obj.aboutBannerImageC)
      ..writeByte(37)
      ..write(obj.schoolBannerImageC)
      ..writeByte(38)
      ..write(obj.resourcesBannerImageC)
      ..writeByte(39)
      ..write(obj.playStoreUrlC)
      ..writeByte(40)
      ..write(obj.appStoreUrlC)
      ..writeByte(41)
      ..write(obj.bannerHeightFactorC)
      ..writeByte(42)
      ..write(obj.familyBannerColorC)
      ..writeByte(43)
      ..write(obj.staffBannerColorC)
      ..writeByte(44)
      ..write(obj.studentBannerColorC)
      ..writeByte(45)
      ..write(obj.aboutBannerColorC)
      ..writeByte(46)
      ..write(obj.schoolBannerColorC)
      ..writeByte(47)
      ..write(obj.resourcesBannerColorC)
      ..writeByte(48)
      ..write(obj.contactImageC)
      ..writeByte(49)
      ..write(obj.isTestSchool)
      ..writeByte(50)
      ..write(obj.isCustomApp)
      ..writeByte(51)
      ..write(obj.disableDarkMode)
      ..writeByte(52)
      ..write(obj.authenticationURL)
      ..writeByte(53)
      ..write(obj.enableGraded)
      ..writeByte(54)
      ..write(obj.darkmodeIconColor)
      ..writeByte(55)
      ..write(obj.parentCoordinatorEmailc)
      ..writeByte(56)
      ..write(obj.calendarId)
      ..writeByte(57)
      ..write(obj.calendarBannerImage)
      ..writeByte(58)
      ..write(obj.calendarBannerColor)
      ..writeByte(59)
      ..write(obj.dashboardUrlC)
      ..writeByte(60)
      ..write(obj.enableGoogleSSO)
      ..writeByte(61)
      ..write(obj.enablenycDocLogin)
      ..writeByte(62)
      ..write(obj.nycDocLoginUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
