class Staffsubattribute {
  String? type;
  String? url;

  Staffsubattribute({this.type, this.url});

  factory Staffsubattribute.fromJson(Map<String, dynamic> json) =>
      Staffsubattribute(
        type: json['type'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
