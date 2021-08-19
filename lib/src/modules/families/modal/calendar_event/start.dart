class Start {
  String? dateTime;
  Start({this.dateTime});

  factory Start.fromJson(Map<String, dynamic> json) => Start(
      dateTime: json['dateTime'] == null ? null : json['dateTime'] as String);

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
      };
}
