class Start {
  DateTime? dateTime;
  Start({this.dateTime});

  factory Start.fromJson(Map<String, dynamic> json) => Start(
        dateTime: json['dateTime'] == null
            ? null
            : DateTime.parse(json['dateTime'] as String),
      );

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime?.toIso8601String(),
      };
}