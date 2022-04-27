// To parse this JSON data, do
//
//     final ocrModal = ocrModalFromJson(jsonString);

import 'dart:convert';

OcrModal ocrModalFromJson(String str) => OcrModal.fromJson(json.decode(str));

String ocrModalToJson(OcrModal data) => json.encode(data.toJson());

class OcrModal {
  OcrModal({
    this.responses,
  });

  List<Response>? responses;

  factory OcrModal.fromJson(Map<String, dynamic> json) => OcrModal(
        responses: List<Response>.from(
            json["responses"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responses": List<dynamic>.from(responses!.map((x) => x.toJson())),
      };
}

class Response {
  Response({
    this.textAnnotations,
    this.fullTextAnnotation,
  });

  List<TextAnnotation>? textAnnotations;
  FullTextAnnotation? fullTextAnnotation;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        textAnnotations: List<TextAnnotation>.from(
            json["textAnnotations"].map((x) => TextAnnotation.fromJson(x))),
        fullTextAnnotation:
            FullTextAnnotation.fromJson(json["fullTextAnnotation"]),
      );

  Map<String, dynamic> toJson() => {
        "textAnnotations":
            List<dynamic>.from(textAnnotations!.map((x) => x.toJson())),
        "fullTextAnnotation": fullTextAnnotation!.toJson(),
      };
}

class FullTextAnnotation {
  FullTextAnnotation({
    this.pages,
    this.text,
  });

  List<Page>? pages;
  String? text;

  factory FullTextAnnotation.fromJson(Map<String, dynamic> json) =>
      FullTextAnnotation(
        pages: List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "pages": List<dynamic>.from(pages!.map((x) => x.toJson())),
        "text": text,
      };
}

class Page {
  Page({
    this.width,
    this.height,
    this.blocks,
  });

  int? width;
  int? height;
  List<Block>? blocks;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        width: json["width"],
        height: json["height"],
        blocks: List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "blocks": List<dynamic>.from(blocks!.map((x) => x.toJson())),
      };
}

class Block {
  Block({
    this.boundingBox,
    this.paragraphs,
    this.blockType,
    this.confidence,
  });

  Bounding? boundingBox;
  List<Paragraph>? paragraphs;
  String? blockType;
  double? confidence;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        boundingBox: Bounding.fromJson(json["boundingBox"]),
        paragraphs: List<Paragraph>.from(
            json["paragraphs"].map((x) => Paragraph.fromJson(x))),
        blockType: json["blockType"],
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "boundingBox": boundingBox!.toJson(),
        "paragraphs": List<dynamic>.from(paragraphs!.map((x) => x.toJson())),
        "blockType": blockType,
        "confidence": confidence,
      };
}

class Bounding {
  Bounding({
    this.vertices,
  });

  List<Vertex>? vertices;

  factory Bounding.fromJson(Map<String, dynamic> json) => Bounding(
        vertices:
            List<Vertex>.from(json["vertices"].map((x) => Vertex.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vertices": List<dynamic>.from(vertices!.map((x) => x.toJson())),
      };
}

class Vertex {
  Vertex({
    this.x,
    this.y,
  });

  int? x;
  int? y;

  factory Vertex.fromJson(Map<String, dynamic> json) => Vertex(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}

class Paragraph {
  Paragraph({
    this.boundingBox,
    this.words,
    this.confidence,
  });

  Bounding? boundingBox;
  List<Word>? words;
  double? confidence;

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
        boundingBox: Bounding.fromJson(json["boundingBox"]),
        words: List<Word>.from(json["words"].map((x) => Word.fromJson(x))),
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "boundingBox": boundingBox!.toJson(),
        "words": List<dynamic>.from(words!.map((x) => x.toJson())),
        "confidence": confidence,
      };
}

class Word {
  Word({
    this.boundingBox,
    this.symbols,
    this.confidence,
  });

  Bounding? boundingBox;
  List<Symbol>? symbols;
  double? confidence;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        boundingBox: Bounding.fromJson(json["boundingBox"]),
        symbols:
            List<Symbol>.from(json["symbols"].map((x) => Symbol.fromJson(x))),
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "boundingBox": boundingBox!.toJson(),
        "symbols": List<dynamic>.from(symbols!.map((x) => x.toJson())),
        "confidence": confidence,
      };
}

class Symbol {
  Symbol({
    this.boundingBox,
    this.text,
    this.confidence,
    this.property,
  });

  Bounding? boundingBox;
  String? text;
  double? confidence;
  Property? property;

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        boundingBox: Bounding.fromJson(json["boundingBox"]),
        text: json["text"],
        confidence: json["confidence"].toDouble(),
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
      );

  Map<String, dynamic> toJson() => {
        "boundingBox": boundingBox!.toJson(),
        "text": text,
        "confidence": confidence,
        "property": property == null ? null : property!.toJson(),
      };
}

class Property {
  Property({
    this.detectedBreak,
  });

  DetectedBreak? detectedBreak;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        detectedBreak: DetectedBreak.fromJson(json["detectedBreak"]),
      );

  Map<String, dynamic> toJson() => {
        "detectedBreak": detectedBreak!.toJson(),
      };
}

class DetectedBreak {
  DetectedBreak({
    this.type,
  });

  String? type;

  factory DetectedBreak.fromJson(Map<String, dynamic> json) => DetectedBreak(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class TextAnnotation {
  TextAnnotation({
    this.locale,
    this.description,
    this.boundingPoly,
  });

  String? locale;
  String? description;
  Bounding? boundingPoly;

  factory TextAnnotation.fromJson(Map<String, dynamic> json) => TextAnnotation(
        locale: json["locale"] == null ? null : json["locale"],
        description: json["description"],
        boundingPoly: Bounding.fromJson(json["boundingPoly"]),  
      );

  Map<String, dynamic> toJson() => {
        "locale": locale == null ? null : locale,
        "description": description,
        "boundingPoly": boundingPoly!.toJson(),
      };
}
