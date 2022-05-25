class Assessment {
  String? title;
  String? description;
  Assessment({this.title, this.description});

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        title: json['title'] as String?,
        description: json['description'] as String?,
      );
}
