class ActionCountList {
  String? notificationId;
  String? schoolId;
  int? likeCount;
  int? thanksCount;
  int? helpfulCount;
  int? shareCount;
  String? title;
  String? id;
  int? supportCount;
  int? viewCount;

  ActionCountList(
      {this.notificationId,
      this.schoolId,
      this.likeCount,
      this.thanksCount,
      this.helpfulCount,
      this.shareCount,
      this.title,
      this.id,
      this.supportCount,
      this.viewCount});
  factory ActionCountList.fromJson(Map<String, dynamic> json) =>
      ActionCountList(
          notificationId: json['Notification_Id__c'] as String?,
          schoolId: json['School_App__c'] as String?,
          likeCount: json['Total_Likes__c'] as int?,
          thanksCount: json['Total_Thanks__c'] as int?,
          helpfulCount: json['Total_Helpful__c'] as int?,
          shareCount: json['Total_Share__c'] as int?,
          title: json['Title__c'] as String?,
          id: json['UID'] as String?,
          supportCount: json['Total_Support__c'] as int?,
          viewCount: json['Total_View__c'] as int?);

  Map<String, dynamic> toJson() => {
        'Notification_Id__c': notificationId,
        'School_App__c': schoolId,
        'Total_Likes__c': likeCount,
        'Total_Thanks__c': thanksCount,
        'Total_Helpful__c': helpfulCount,
        'Total_Share__c': shareCount,
        'Title__c': title,
        'UID': id,
        'Total_Support__c': supportCount,
        'Total_View__c': viewCount
      };
}
