import 'package:hive/hive.dart';
part 'calendar_banner_image_modal.g.dart';

@HiveType(typeId: 24)
class CalendarBannerImageModal {
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  // String? createdById;
  // @HiveField(4)
  // String? lastModifiedById;
  @HiveField(4)
  String? monthC;
  @HiveField(5)
  String? monthImageC;
  // @HiveField(7)
  // String? ownerId;

  CalendarBannerImageModal({
    this.id,
    this.name,
    // this.createdById,
    // this.lastModifiedById,
    this.monthC,
    this.monthImageC,
    // this.ownerId
  });

  factory CalendarBannerImageModal.fromJson(Map<String, dynamic> json) =>
      CalendarBannerImageModal(
        id: json['Id'] as String?,
        name: json['Name'] as String?,
        // createdById: json['CreatedById'] as String?,
        // lastModifiedById: json['LastModifiedById'] as String?,
        monthC: json['Month__c'] as String?,
        monthImageC: json['Month_Image__c'] as String?,
        // ownerId: json['OwnerId'] as String?,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    // data['CreatedById'] = this.createdById;
    // data['LastModifiedById'] = this.lastModifiedById;
    data['Month__c'] = this.monthC;
    data['Month_Image__c'] = this.monthImageC;
    // data['OwnerId'] = this.ownerId;
    return data;
  }
}
