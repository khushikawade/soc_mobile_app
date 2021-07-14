import 'channel.dart';

class Rss {
  Channel? channel;

  Rss({this.channel});

  factory Rss.fromJson(Map<String, dynamic> json) => Rss(
        channel: json['channel'] == null
            ? null
            : Channel.fromJson(json['channel'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'channel': channel?.toJson(),
      };
}
