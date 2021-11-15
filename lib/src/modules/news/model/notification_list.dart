class NotificationList {
  String? id;
  final contents;
  final headings;
  final url;
  String? image;
  double? likeCount;
  double? thanksCount;
  double? helpfulCount;
  double? shareCount;

  NotificationList(
      {this.id,
      this.contents,
      this.headings,
      this.url,
      this.image,
      this.likeCount = 0,
      this.thanksCount = 0,
      this.helpfulCount = 0,
      this.shareCount = 0});
}
