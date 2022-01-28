// class SocialActionCountList {
//   // String? name;
//   String? socialId;

//   int? likeCount;
//   int? thanksCount;
//   int? helpfulCount;
//   int? shareCount;
//   // double? likeCount;
//   // double? thanksCount;
//   // double? helpfulCount;
//   // double? shareCount;

//   SocialActionCountList(
//       {
//       // this.name,
//       this.socialId,
//       this.likeCount,
//       this.thanksCount,
//       this.helpfulCount,
//       this.shareCount});

//   factory SocialActionCountList.fromJson(Map<String, dynamic> json) =>
//       SocialActionCountList(
//         // name: json['Name'] as String?,
//         // schoolId: json['School_App__c'] as String?,
//         // likeCount: json['Total_Likes__c'] as double?,
//         // thanksCount: json['Total_Thanks__c'] as double?,
//         // helpfulCount: json['Total_helpful__c'] as double?,
//         // shareCount: json['Total__c'] as double?,

//         socialId: json['Id'] as String?,

//         likeCount: json['like'] as int?,
//         thanksCount: json['thanks'] as int?,
//         helpfulCount: json['helpful'] as int?,
//         shareCount: json['share'] as int?,
//       );

//   Map<String, dynamic> toJson() => {
//         'Id': socialId,
//         'like': likeCount,
//         'thanks': thanksCount,
//         'helpful': helpfulCount,
//         'share': shareCount,
//       };
// }
