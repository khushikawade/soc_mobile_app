import 'package:flutter/material.dart';

class PBISPlusActionInteractionModalNew {
  String imagePath;
  String title;
  Color color;
  PBISPlusActionInteractionModalNew({
    required this.imagePath,
    required this.title,
    required this.color,
  });

  static List<PBISPlusActionInteractionModalNew>
      PBISPlusActionInteractionIconsNew = [
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/Engaged.svg",
      title: 'Engaged',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/Helpful.svg",
      title: 'Nice Work',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/nice_work.svg",
      title: 'Helpful',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/participation.svg",
      title: 'Participation',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/collaboration.svg",
      title: 'Collaboration',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/listening.svg",
      title: 'Listening',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/courteous.svg",
      title: 'Courteous',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/responsible.svg",
      title: 'Responsible',
      color: Colors.red,
    ),
    PBISPlusActionInteractionModalNew(
      imagePath: "assets/Pbis_plus/punctual.svg",
      title: 'Punctual',
      color: Colors.red,
    ),
  ];
}

class PBISPlusDataTableModal {
  String imagePath;
  Color color;
  String title;
  PBISPlusDataTableModal(
      {required this.imagePath, required this.color, required this.title});

  static List<PBISPlusDataTableModal> PBISPlusDataTableHeadingRawNew = [
    PBISPlusDataTableModal(
        imagePath: "", color: Colors.transparent, title: 'Date'),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/Engaged.svg",
      title: 'Engaged',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/Helpful.svg",
      title: 'Nice Work',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/nice_work.svg",
      title: 'Helpful',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/participation.svg",
      title: 'Participation',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/collaboration.svg",
      title: 'Collaboration',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
      imagePath: "assets/Pbis_plus/listening.svg",
      title: 'Listening',
      color: Colors.red,
    ),
    PBISPlusDataTableModal(
        imagePath: "", color: Colors.transparent, title: 'Total')
  ];
}
