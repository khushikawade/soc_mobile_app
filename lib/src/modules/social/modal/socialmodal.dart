// import 'dart:ffi';

// import 'package:flutter/material.dart';

// // class SocialModel {
// //   const SocialModel({
// //     required this.tittle,
// //     // required this.pubget,
// //     // required this.description,
// //   });

// //   final tittle;
// //   // final pubget; //TIMESTAMP
// //   // final description;
// // }

// import 'dart:convert';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

// class Welcome {
//   Welcome({
//     this.rss,
//   });

//   Rss? rss;

//   factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//         rss: json["rss"] == null ? null : Rss.fromJson(json["rss"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "rss": rss == null ? null : rss!.toJson(),
//       };
// }

// class Rss {
//   Rss({
//     this.channel,
//   });

//   Channel? channel;

//   factory Rss.fromJson(Map<String, dynamic> json) => Rss(
//         channel:
//             json["channel"] == null ? null : Channel.fromJson(json["channel"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "channel": channel == null ? null : channel!.toJson(),
//       };
// }

// class Channel {
//   Channel({
//     this.title,
//     this.description,
//     this.link,
//     this.image,
//     this.generator,
//     this.lastBuildDate,
//     this.language,
//     this.item,
//   });

//   Description? title;
//   Description? description;
//   List<String>? link;
//   Image? image;
//   String? generator;
//   String? lastBuildDate;
//   Description? language;
//   List<Item>? item;

//   factory Channel.fromJson(Map<String, dynamic> json) => Channel(
//         title:
//             json["title"] == null ? null : Description.fromJson(json["title"]),
//         description: json["description"] == null
//             ? null
//             : Description.fromJson(json["description"]),
//         // link: json["link"] == null
//         //     ? null
//         //     : List<String>.from(json["link"].map((x) => x)),
//         image: json["image"] == null ? null : Image.fromJson(json["image"]),
//         generator: json["generator"] == null ? null : json["generator"],
//         lastBuildDate:
//             json["lastBuildDate"] == null ? null : json["lastBuildDate"],
//         language: json["language"] == null
//             ? null
//             : Description.fromJson(json["language"]),
//         item: json["item"] == null
//             ? null
//             : List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title == null ? null : title!.toJson(),
//         "description": description == null ? null : description!.toJson(),
//         "link": link == null ? null : List<dynamic>.from(link!.map((x) => x)),
//         "image": image == null ? null : image!.toJson(),
//         "generator": generator == null ? null : generator,
//         "lastBuildDate": lastBuildDate == null ? null : lastBuildDate,
//         "language": language == null ? null : language!.toJson(),
//         "item": item == null
//             ? null
//             : List<dynamic>.from(item!.map((x) => x.toJson())),
//       };
// }

// class Description {
//   Description({
//     this.cdata,
//   });

//   String? cdata;

//   factory Description.fromJson(Map<String, dynamic> json) => Description(
//         cdata: json["__cdata"] == null ? null : json["__cdata"],
//       );

//   Map<String, dynamic> toJson() => {
//         "__cdata": cdata == null ? null : cdata,
//       };
// }

// class Image {
//   Image({
//     this.url,
//     this.title,
//     this.link,
//   });

//   String? url;
//   String? title;
//   String? link;

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         url: json["url"] == null ? null : json["url"],
//         title: json["title"] == null ? null : json["title"],
//         link: json["link"] == null ? null : json["link"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url == null ? null : url,
//         "title": title == null ? null : title,
//         "link": link == null ? null : link,
//       };
// }

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
//         title:
//             json["title"] == null ? null : Description.fromJson(json["title"]),
//         description: json["description"] == null
//             ? null
//             : Description.fromJson(json["description"]),
//         link: json["link"] == null ? null : json["link"],
//         guid: json["guid"] == null ? null : json["guid"],
//         creator: json["creator"] == null
//             ? null
//             : Description.fromJson(json["creator"]),
//         pubDate: json["pubDate"] == null ? null : json["pubDate"],
//         content: json["content"] == null ? null : json["content"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title == null ? null : title!.toJson(),
//         "description": description == null ? null : description!.toJson(),
//         "link": link == null ? null : link,
//         "guid": guid == null ? null : guid,
//         "creator": creator == null ? null : creator!.toJson(),
//         "pubDate": pubDate == null ? null : pubDate,
//         "content": content == null ? null : content,
//       };
// }
