import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_icons.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class PBISPlusActionInteractionModal {
  String title;
  Color color;
  IconData iconData;

  PBISPlusActionInteractionModal({
    required this.title,
    required this.color,
    required this.iconData,
  });

  static List<PBISPlusActionInteractionModal> PBISPlusActionInteractionIcons = [
    PBISPlusActionInteractionModal(
      iconData: IconData(0xe87e,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      color: Colors.red,
      title: 'Engaged',
    ),
    PBISPlusActionInteractionModal(
      iconData: IconData(0xe87f,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      color: Colors.blue,
      title: 'Nice Work',
    ),
    PBISPlusActionInteractionModal(
      iconData: IconData(0xe880,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      color: Colors.green,
      title: 'Helpful',
    ),
  ];
}

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
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/Engaged.svg",
    //   title: 'Engaged',
    //   color: Colors.red,
    // ),
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/Helpful.svg",
    //   title: 'Nice Work',
    //   color: Colors.red,
    // ),
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/nice_work.svg",
    //   title: 'Helpful',
    //   color: Colors.red,
    // ),
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/participation.svg",
    //   title: 'Participation',
    //   color: Colors.red,
    // ),
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/collaboration.svg",
    //   title: 'Collaboration',
    //   color: Colors.red,
    // ),
    // PBISPlusActionInteractionModalNew(
    //   imagePath: "assets/Pbis_plus/listening.svg",
    //   title: 'Listening',
    //   color: Colors.red,
    // ),
  ];
}

class PBISPlusDataTableModal {
  String title;
  Color color;
  IconData iconData;
  PBISPlusDataTableModal(
      {required this.title, required this.color, required this.iconData});

  static List<PBISPlusDataTableModal> PBISPlusDataTableHeadingRaw = [
    PBISPlusDataTableModal(
        iconData: IconData(0xe87e,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.transparent,
        title: 'Date'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe87e,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.red,
        title: 'Engaged'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe87f,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.blue,
        title: 'Nice Work'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe880,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.green,
        title: 'Helpful'),
    PBISPlusDataTableModal(
        iconData: IconData(0xe880,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        color: Colors.transparent,
        title: 'Total')
  ];
}
