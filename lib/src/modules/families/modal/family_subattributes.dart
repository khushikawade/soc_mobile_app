class SubAttributes {
  String? type;
  String? url;

  SubAttributes({this.type, this.url});

  factory SubAttributes.fromJson(Map<String, dynamic> json) => SubAttributes(
        type: json['type'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
