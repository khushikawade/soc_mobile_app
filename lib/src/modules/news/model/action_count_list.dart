class ActionCountList {
  // String? name;
  String? notificationId;
  String? schoolId;
  int? likeCount;
  int? thanksCount;
  int? helpfulCount;
  int? shareCount;
  // double? likeCount;
  // double? thanksCount;
  // double? helpfulCount;
  // double? shareCount;

  ActionCountList(
      {
        // this.name,
      this.notificationId,
      this.schoolId,
      this.likeCount,
      this.thanksCount,
      this.helpfulCount,
      this.shareCount});

  factory ActionCountList.fromJson(Map<String, dynamic> json) =>
      ActionCountList(
        // name: json['Name'] as String?,
        // schoolId: json['School_App__c'] as String?,
        // likeCount: json['Total_Likes__c'] as double?,
        // thanksCount: json['Total_Thanks__c'] as double?,
        // helpfulCount: json['Total_helpful__c'] as double?,
        // shareCount: json['Total__c'] as double?,

        notificationId: json['notificationId'] as String?,
        schoolId: json['schoolId'] as String?,
        likeCount: json['like'] as int?,
        thanksCount: json['thanks'] as int?,
        helpfulCount: json['helpful'] as int?,
        shareCount: json['share'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'schoolId': schoolId,
        'like': likeCount,
        'thanks': thanksCount,
        'helpful': helpfulCount,
        'share': shareCount,
      };
}
