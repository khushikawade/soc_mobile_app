class Description {
  String? cdata;

  Description({this.cdata});

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        cdata: json['__cdata'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '__cdata': cdata,
      };
}
