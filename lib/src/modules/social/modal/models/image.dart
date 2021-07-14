class Image {
  String? url;
  String? title;
  String? link;

  Image({this.url, this.title, this.link});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json['url'] as String?,
        title: json['title'] as String?,
        link: json['link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'title': title,
        'link': link,
      };
}
