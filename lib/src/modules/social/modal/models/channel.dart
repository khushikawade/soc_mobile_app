import 'description.dart';
import 'image.dart';
import 'item.dart';
import 'language.dart';
import 'title.dart';

class Channel {
  Title? title;
  Description? description;
  List<String>? link;
  Image? image;
  String? generator;
  String? lastBuildDate;
  Language? language;
  List<Item>? item;

  Channel({
    this.title,
    this.description,
    this.link,
    this.image,
    this.generator,
    this.lastBuildDate,
    this.language,
    this.item,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        title: json['title'] == null
            ? null
            : Title.fromJson(json['title'] as Map<String, dynamic>),
        description: json['description'] == null
            ? null
            : Description.fromJson(json['description'] as Map<String, dynamic>),
        link: json['link'] as List<String>?,
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
        generator: json['generator'] as String?,
        lastBuildDate: json['lastBuildDate'] as String?,
        language: json['language'] == null
            ? null
            : Language.fromJson(json['language'] as Map<String, dynamic>),
        item: (json['item'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title?.toJson(),
        'description': description?.toJson(),
        'link': link,
        'image': image?.toJson(),
        'generator': generator,
        'lastBuildDate': lastBuildDate,
        'language': language?.toJson(),
        'item': item?.map((e) => e.toJson()).toList(),
      };
}
