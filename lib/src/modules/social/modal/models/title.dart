class Title {
  String? cdata;

  Title({this.cdata});

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        cdata: json['__cdata'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '__cdata': cdata,
      };
}
