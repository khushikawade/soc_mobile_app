class End {
  DateTime? dateTime;

  End({this.dateTime});

  factory End.fromJson(Map<String, dynamic> json) => End(
        dateTime: json['dateTime'] == null
            ? json['date'] == null
                ? null
                : json['date']
            : DateTime.parse(json['dateTime'] as String),
      );

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime?.toIso8601String(),
      };
}
