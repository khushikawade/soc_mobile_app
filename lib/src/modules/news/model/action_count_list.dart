class ActionCountList {
  String? name;
  String? schoolId;
  int? likeCount;
  int? thanksCount;
  int? helpfulCount;
  int? shareCount;

  ActionCountList(
      {this.name,
      this.schoolId,
      this.likeCount,
      this.thanksCount,
      this.helpfulCount,
      this.shareCount});

  factory ActionCountList.fromJson(Map<String, dynamic> json) =>
      ActionCountList(
        name: json['Name'] as String?,
        schoolId: json['School_App__c'] as String?,
        likeCount: json['Total_Likes__c'] as int?,
        thanksCount: json['Total_Thanks__c'] as int?,
        helpfulCount: json['Total_helpful__c'] as int?,
        shareCount: json['Total__c'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'School_App__c': schoolId,
        'Total_Likes__c': likeCount,
        'Total_Thanks__c': thanksCount,
        'Total_helpful__c': helpfulCount,
        'Total__c': name,
      };
}
