class Language {
  String? cdata;

  Language({this.cdata});

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        cdata: json['__cdata'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '__cdata': cdata,
      };
}
