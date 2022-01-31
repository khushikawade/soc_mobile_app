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

        notificationId: json['Notification_Id__c'] as String?,
        schoolId: json['School_App__c'] as String?,
        likeCount: json['Total_Likes__c'] as int?,
        thanksCount: json['Total_Thanks__c'] as int?,
        helpfulCount: json['Total_Helpful__c'] as int?,
        shareCount: json['Total_Share__c'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Notification_Id__c': notificationId,
        'School_App__c': schoolId,
        'Total_Likes__c': likeCount,
        'Total_Thanks__c': thanksCount,
        'Total_Helpful__c': helpfulCount,
        'Total_Share__c': shareCount,
      };
}
