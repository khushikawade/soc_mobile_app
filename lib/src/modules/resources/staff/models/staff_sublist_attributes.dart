class StaffSubListAttributes {
  String? type;
  String? url;

  StaffSubListAttributes({this.type, this.url});

  factory StaffSubListAttributes.fromJson(Map<String, dynamic> json) =>
      StaffSubListAttributes(
        type: json['type'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
