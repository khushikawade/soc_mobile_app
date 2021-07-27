class CalendarAttributes {
  String? type;
  String? url;

  CalendarAttributes({this.type, this.url});

  factory CalendarAttributes.fromJson(Map<String, dynamic> json) =>
      CalendarAttributes(
        type: json['type'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
