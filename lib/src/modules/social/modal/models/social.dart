import 'rss.dart';

class Social {
  Rss? rss;

  Social({this.rss});

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        rss: json['rss'] == null
            ? null
            : Rss.fromJson(json['rss'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'rss': rss?.toJson(),
      };
}
