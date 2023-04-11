// // To parse this JSON data, do
// //
// //     final ocrImageModal = ocrImageModalFromJson(jsonString);

// import 'dart:convert';

// class OcrImageModal {
//   OcrImageModal({
//     this.responses,
//   });

//   List<Response>? responses;

//   factory OcrImageModal.fromRawJson(String str) =>
//       OcrImageModal.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory OcrImageModal.fromJson(Map<String, dynamic> json) => OcrImageModal(
//         responses: json["responses"] == null
//             ? null
//             : List<Response>.from(
//                 json["responses"].map((x) => Response.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "responses": responses == null
//             ? null
//             : List<dynamic>.from(responses!.map((x) => x.toJson())),
//       };
// }

// class Response {
//   Response({
//     this.textAnnotations,
//     this.fullTextAnnotation,
//   });

//   List<TextAnnotation>? textAnnotations;
//   FullTextAnnotation? fullTextAnnotation;

//   factory Response.fromRawJson(String str) =>
//       Response.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//         textAnnotations: json["textAnnotations"] == null
//             ? null
//             : List<TextAnnotation>.from(
//                 json["textAnnotations"].map((x) => TextAnnotation.fromJson(x))),
//         fullTextAnnotation: json["fullTextAnnotation"] == null
//             ? null
//             : FullTextAnnotation.fromJson(json["fullTextAnnotation"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "textAnnotations": textAnnotations == null
//             ? null
//             : List<dynamic>.from(textAnnotations!.map((x) => x.toJson())),
//         "fullTextAnnotation":
//             fullTextAnnotation == null ? null : fullTextAnnotation!.toJson(),
//       };
// }

// class FullTextAnnotation {
//   FullTextAnnotation({
//     this.pages,
//     this.text,
//   });

//   List<Page>? pages;
//   String? text;

//   factory FullTextAnnotation.fromRawJson(String str) =>
//       FullTextAnnotation.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory FullTextAnnotation.fromJson(Map<String, dynamic> json) =>
//       FullTextAnnotation(
//         pages: json["pages"] == null
//             ? null
//             : List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
//         text: json["text"] == null ? null : json["text"],
//       );

//   Map<String, dynamic> toJson() => {
//         "pages": pages == null
//             ? null
//             : List<dynamic>.from(pages!.map((x) => x.toJson())),
//         "text": text == null ? null : text,
//       };
// }

// class Page {
//   Page({
//     this.property,
//     this.width,
//     this.height,
//     this.blocks,
//   });

//   ParagraphProperty? property;
//   int? width;
//   int? height;
//   List<Block>? blocks;

//   factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Page.fromJson(Map<String, dynamic> json) => Page(
//         property: json["property"] == null
//             ? null
//             : ParagraphProperty.fromJson(json["property"]),
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//         blocks: json["blocks"] == null
//             ? null
//             : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "property": property == null ? null : property!.toJson(),
//         "width": width == null ? null : width,
//         "height": height == null ? null : height,
//         "blocks": blocks == null
//             ? null
//             : List<dynamic>.from(blocks!.map((x) => x.toJson())),
//       };
// }

// class Block {
//   Block({
//     this.property,
//     this.boundingBox,
//     this.paragraphs,
//     this.blockType,
//     this.confidence,
//   });

//   ParagraphProperty? property;
//   Bounding? boundingBox;
//   List<Paragraph>? paragraphs;
//   String? blockType;
//   double? confidence;

//   factory Block.fromRawJson(String str) => Block.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Block.fromJson(Map<String, dynamic> json) => Block(
//         property: json["property"] == null
//             ? null
//             : ParagraphProperty.fromJson(json["property"]),
//         boundingBox: json["boundingBox"] == null
//             ? null
//             : Bounding.fromJson(json["boundingBox"]),
//         paragraphs: json["paragraphs"] == null
//             ? null
//             : List<Paragraph>.from(
//                 json["paragraphs"].map((x) => Paragraph.fromJson(x))),
//         blockType: json["blockType"] == null ? null : json["blockType"],
//         confidence:
//             json["confidence"] == null ? null : json["confidence"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "property": property == null ? null : property!.toJson(),
//         "boundingBox": boundingBox == null ? null : boundingBox!.toJson(),
//         "paragraphs": paragraphs == null
//             ? null
//             : List<dynamic>.from(paragraphs!.map((x) => x.toJson())),
//         "blockType": blockType == null ? null : blockType,
//         "confidence": confidence == null ? null : confidence,
//       };
// }

// class Bounding {
//   Bounding({
//     this.vertices,
//   });

//   List<Vertex>? vertices;

//   factory Bounding.fromRawJson(String str) =>
//       Bounding.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Bounding.fromJson(Map<String, dynamic> json) => Bounding(
//         vertices: json["vertices"] == null
//             ? null
//             : List<Vertex>.from(
//                 json["vertices"].map((x) => Vertex.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "vertices": vertices == null
//             ? null
//             : List<dynamic>.from(vertices!.map((x) => x.toJson())),
//       };
// }

// class Vertex {
//   Vertex({
//     this.x,
//     this.y,
//   });

//   int? x;
//   int? y;

//   factory Vertex.fromRawJson(String str) => Vertex.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Vertex.fromJson(Map<String, dynamic> json) => Vertex(
//         x: json["x"] == null ? null : json["x"],
//         y: json["y"] == null ? null : json["y"],
//       );

//   Map<String, dynamic> toJson() => {
//         "x": x == null ? null : x,
//         "y": y == null ? null : y,
//       };
// }

// class Paragraph {
//   Paragraph({
//     this.property,
//     this.boundingBox,
//     this.words,
//     this.confidence,
//   });

//   ParagraphProperty? property;
//   Bounding? boundingBox;
//   List<Word>? words;
//   double? confidence;

//   factory Paragraph.fromRawJson(String str) =>
//       Paragraph.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
//         property: json["property"] == null
//             ? null
//             : ParagraphProperty.fromJson(json["property"]),
//         boundingBox: json["boundingBox"] == null
//             ? null
//             : Bounding.fromJson(json["boundingBox"]),
//         words: json["words"] == null
//             ? null
//             : List<Word>.from(json["words"].map((x) => Word.fromJson(x))),
//         confidence:
//             json["confidence"] == null ? null : json["confidence"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "property": property == null ? null : property!.toJson(),
//         "boundingBox": boundingBox == null ? null : boundingBox!.toJson(),
//         "words": words == null
//             ? null
//             : List<dynamic>.from(words!.map((x) => x.toJson())),
//         "confidence": confidence == null ? null : confidence,
//       };
// }

// class ParagraphProperty {
//   ParagraphProperty({
//     this.detectedLanguages,
//   });

//   List<PurpleDetectedLanguage>? detectedLanguages;

//   factory ParagraphProperty.fromRawJson(String str) =>
//       ParagraphProperty.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory ParagraphProperty.fromJson(Map<String, dynamic> json) =>
//       ParagraphProperty(
//         detectedLanguages: json["detectedLanguages"] == null
//             ? null
//             : List<PurpleDetectedLanguage>.from(json["detectedLanguages"]
//                 .map((x) => PurpleDetectedLanguage.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "detectedLanguages": detectedLanguages == null
//             ? null
//             : List<dynamic>.from(detectedLanguages!.map((x) => x.toJson())),
//       };
// }

// class PurpleDetectedLanguage {
//   PurpleDetectedLanguage({
//     this.languageCode,
//     this.confidence,
//   });

//   Locale? languageCode;
//   double? confidence;

//   factory PurpleDetectedLanguage.fromRawJson(String str) =>
//       PurpleDetectedLanguage.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PurpleDetectedLanguage.fromJson(Map<String, dynamic> json) =>
//       PurpleDetectedLanguage(
//         languageCode: json["languageCode"] == null
//             ? null
//             : localeValues.map[json["languageCode"]],
//         confidence:
//             json["confidence"] == null ? null : json["confidence"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "languageCode":
//             languageCode == null ? null : localeValues.reverse[languageCode],
//         "confidence": confidence == null ? null : confidence,
//       };
// }

// enum Locale { EN }

// final localeValues = EnumValues({"en": Locale.EN});

// class Word {
//   Word({
//     this.property,
//     this.boundingBox,
//     this.symbols,
//     this.confidence,
//   });

//   WordProperty? property;
//   Bounding? boundingBox;
//   List<Symbol>? symbols;
//   double? confidence;

//   factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Word.fromJson(Map<String, dynamic> json) => Word(
//         property: json["property"] == null
//             ? null
//             : WordProperty.fromJson(json["property"]),
//         boundingBox: json["boundingBox"] == null
//             ? null
//             : Bounding.fromJson(json["boundingBox"]),
//         symbols: json["symbols"] == null
//             ? null
//             : List<Symbol>.from(json["symbols"].map((x) => Symbol.fromJson(x))),
//         confidence:
//             json["confidence"] == null ? null : json["confidence"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "property": property == null ? null : property!.toJson(),
//         "boundingBox": boundingBox == null ? null : boundingBox!.toJson(),
//         "symbols": symbols == null
//             ? null
//             : List<dynamic>.from(symbols!.map((x) => x.toJson())),
//         "confidence": confidence == null ? null : confidence,
//       };
// }

// class WordProperty {
//   WordProperty({
//     this.detectedLanguages,
//   });

//   List<FluffyDetectedLanguage>? detectedLanguages;

//   factory WordProperty.fromRawJson(String str) =>
//       WordProperty.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory WordProperty.fromJson(Map<String, dynamic> json) => WordProperty(
//         detectedLanguages: json["detectedLanguages"] == null
//             ? null
//             : List<FluffyDetectedLanguage>.from(json["detectedLanguages"]
//                 .map((x) => FluffyDetectedLanguage.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "detectedLanguages": detectedLanguages == null
//             ? null
//             : List<dynamic>.from(detectedLanguages!.map((x) => x.toJson())),
//       };
// }

// class FluffyDetectedLanguage {
//   FluffyDetectedLanguage({
//     this.languageCode,
//   });

//   Locale? languageCode;

//   factory FluffyDetectedLanguage.fromRawJson(String str) =>
//       FluffyDetectedLanguage.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory FluffyDetectedLanguage.fromJson(Map<String, dynamic> json) =>
//       FluffyDetectedLanguage(
//         languageCode: json["languageCode"] == null
//             ? null
//             : localeValues.map[json["languageCode"]],
//       );

//   Map<String, dynamic> toJson() => {
//         "languageCode":
//             languageCode == null ? null : localeValues.reverse[languageCode],
//       };
// }

// class Symbol {
//   Symbol({
//     this.property,
//     this.boundingBox,
//     this.text,
//     this.confidence,
//   });

//   SymbolProperty? property;
//   Bounding? boundingBox;
//   String? text;
//   double? confidence;

//   factory Symbol.fromRawJson(String str) => Symbol.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
//         property: json["property"] == null
//             ? null
//             : SymbolProperty.fromJson(json["property"]),
//         boundingBox: json["boundingBox"] == null
//             ? null
//             : Bounding.fromJson(json["boundingBox"]),
//         text: json["text"] == null ? null : json["text"],
//         confidence:
//             json["confidence"] == null ? null : json["confidence"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "property": property == null ? null : property!.toJson(),
//         "boundingBox": boundingBox == null ? null : boundingBox!.toJson(),
//         "text": text == null ? null : text,
//         "confidence": confidence == null ? null : confidence,
//       };
// }

// class SymbolProperty {
//   SymbolProperty({
//     this.detectedLanguages,
//     this.detectedBreak,
//   });

//   List<FluffyDetectedLanguage>? detectedLanguages;
//   DetectedBreak? detectedBreak;

//   factory SymbolProperty.fromRawJson(String str) =>
//       SymbolProperty.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory SymbolProperty.fromJson(Map<String, dynamic> json) => SymbolProperty(
//         detectedLanguages: json["detectedLanguages"] == null
//             ? null
//             : List<FluffyDetectedLanguage>.from(json["detectedLanguages"]
//                 .map((x) => FluffyDetectedLanguage.fromJson(x))),
//         detectedBreak: json["detectedBreak"] == null
//             ? null
//             : DetectedBreak.fromJson(json["detectedBreak"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "detectedLanguages": detectedLanguages == null
//             ? null
//             : List<dynamic>.from(detectedLanguages!.map((x) => x.toJson())),
//         "detectedBreak": detectedBreak == null ? null : detectedBreak!.toJson(),
//       };
// }

// class DetectedBreak {
//   DetectedBreak({
//     this.type,
//   });

//   String? type;

//   factory DetectedBreak.fromRawJson(String str) =>
//       DetectedBreak.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory DetectedBreak.fromJson(Map<String, dynamic> json) => DetectedBreak(
//         type: json["type"] == null ? null : json["type"],
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type == null ? null : type,
//       };
// }

// class TextAnnotation {
//   TextAnnotation({
//     this.locale,
//     this.description,
//     this.boundingPoly,
//   });

//   Locale? locale;
//   String? description;
//   Bounding? boundingPoly;

//   factory TextAnnotation.fromRawJson(String str) =>
//       TextAnnotation.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory TextAnnotation.fromJson(Map<String, dynamic> json) => TextAnnotation(
//         locale:
//             json["locale"] == null ? null : localeValues.map[json["locale"]],
//         description: json["description"] == null ? null : json["description"],
//         boundingPoly: json["boundingPoly"] == null
//             ? null
//             : Bounding.fromJson(json["boundingPoly"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "locale": locale == null ? null : localeValues.reverse[locale],
//         "description": description == null ? null : description,
//         "boundingPoly": boundingPoly == null ? null : boundingPoly!.toJson(),
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
