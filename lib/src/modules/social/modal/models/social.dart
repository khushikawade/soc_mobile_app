import 'creator.dart';
import 'description.dart';
import 'title.dart';

class Social {
  Title? title;
  Description? description;
  String? link;
  String? guid;
  Creator? creator;
  String? pubDate;
  String? content;

  Social({
    this.title,
    this.description,
    this.link,
    this.guid,
    this.creator,
    this.pubDate,
    this.content,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        title: json['title'] == null
            ? null
            : Title.fromJson(json['title'] as Map<String, dynamic>),
        description: json['description'] == null
            ? null
            : Description.fromJson(json['description'] as Map<String, dynamic>),
        link: json['link'] as String?,
        guid: json['guid'] as String?,
        creator: json['creator'] == null
            ? null
            : Creator.fromJson(json['creator'] as Map<String, dynamic>),
        pubDate: json['pubDate'] as String?,
        content: json['content'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title?.toJson(),
        'description': description?.toJson(),
        'link': link,
        'guid': guid,
        'creator': creator?.toJson(),
        'pubDate': pubDate,
        'content': content,
      };
}
