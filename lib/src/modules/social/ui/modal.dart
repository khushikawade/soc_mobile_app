// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.rss,
  });

  Rss? rss;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        rss: Rss.fromJson(json["rss"]),
      );

  Map<String, dynamic> toJson() => {
        "rss": rss!.toJson(),
      };
}

class Rss {
  Rss({
    this.channel,
  });

  Channel? channel;

  factory Rss.fromJson(Map<String, dynamic> json) => Rss(
        channel: Channel.fromJson(json["channel"]),
      );

  Map<String, dynamic> toJson() => {
        "channel": channel!.toJson(),
      };
}

class Channel {
  Channel({
    this.title,
    this.description,
    this.link,
    this.image,
    this.generator,
    this.lastBuildDate,
    this.language,
    // this.item,
  });

  Description? title;
  Description? description;
  List<String>? link;
  Image? image;
  String? generator;
  String? lastBuildDate;
  Description? language;
  // List<Item>? item;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        title: Description.fromJson(json["title"]),
        description: Description.fromJson(json["description"]),
        link: List<String>.from(json["link"].map((x) => x)),
        image: Image.fromJson(json["image"]),
        generator: json["generator"],
        lastBuildDate: json["lastBuildDate"],
        language: Description.fromJson(json["language"]),
        // item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title!.toJson(),
        "description": description!.toJson(),
        "link": List<dynamic>.from(link!.map((x) => x)),
        "image": image!.toJson(),
        "generator": generator,
        "lastBuildDate": lastBuildDate,
        "language": language!.toJson(),
        // "item": List<dynamic>.from(item!.map((x) => x.toJson())),
      };
}

class Description {
  Description({
    this.cdata,
  });

  String? cdata;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        cdata: json["__cdata"],
      );

  Map<String, dynamic> toJson() => {
        "__cdata": cdata,
      };
}

class Image {
  Image({
    this.url,
    this.title,
    this.link,
  });

  String? url;
  String? title;
  String? link;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json["url"],
        title: json["title"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "link": link,
      };
}

// class Item {
//   Item({
//     this.title,
//     this.description,
//     this.link,
//     this.guid,
//     this.creator,
//     this.pubDate,
//     this.content,
//   });

//   Description? title;
//   Description? description;
//   String? link;
//   String? guid;
//   Description? creator;
//   String? pubDate;
//   String? content;

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         title: Description.fromJson(json["title"]),
//         description: Description.fromJson(json["description"]),
//         link: json["link"],
//         guid: json["guid"],
//         creator: Description.fromJson(json["creator"]),
//         pubDate: json["pubDate"],
//         content: json["content"] == null ? null : json["content"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title!.toJson(),
//         "description": description!.toJson(),
//         "link": link,
//         "guid": guid,
//         "creator": creator!.toJson(),
//         "pubDate": pubDate,
//         "content": content == null ? null : content,
//       };
// }
