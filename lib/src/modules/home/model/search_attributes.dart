class SearchAttributes {
  String? type;
  String? url;

  SearchAttributes({this.type, this.url});

  factory SearchAttributes.fromJson(Map<String, dynamic> json) =>
      SearchAttributes(
        type: json['type'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
