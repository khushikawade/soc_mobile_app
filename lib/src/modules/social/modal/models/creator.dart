class Creator {
  String? cdata;

  Creator({this.cdata});

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        cdata: json['__cdata'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '__cdata': cdata,
      };
}
