class Assessment {
  String? title;
  String? description;
  String? fileid;
  Assessment({this.title, this.description, this.fileid});

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
      title: json['title'] as String?,
      description: json['description'] as String?,
      fileid: json['id'] as String?);
}
