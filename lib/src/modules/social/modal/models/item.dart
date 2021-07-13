import 'creator.dart';
import 'description.dart';
import 'title.dart';

class Item {
  // Title? title;
  // Description? description;
  String? title;
  String? description;
  String? link;
  String? guid;
  // Creator? creator;
  String? creator;
  String? pubDate;
  String? content;

  Item({
    this.title,
    this.description,
    this.link,
    this.guid,
    this.creator,
    this.pubDate,
    this.content,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        title: json['title'] as String?,
        description: json['description'] as String?,

        // title: json['title'] == null
        //     ? null
        //     : Title.fromJson(json['title'] as Map<String, dynamic>),
        // description: json['description'] == null
        //     ? null
        //     : Description.fromJson(json['description'] as Map<String, dynamic>),
        link: json['link'] as String?,
        guid: json['guid'] as String?,
        creator: json['creator'] as String?,
        // creator: json['creator'] == null
        //     ? null
        //     : Creator.fromJson(json['creator'] as Map<String, dynamic>),
        pubDate: json['pubDate'] as String?,
        content: json['content'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        // ?.toJson(),
        'description': description,
        // ?.toJson(),
        'link': link,
        'guid': guid,
        'creator': creator,
        // ?.toJson(),
        'pubDate': pubDate,
        'content': content,
      };
}
