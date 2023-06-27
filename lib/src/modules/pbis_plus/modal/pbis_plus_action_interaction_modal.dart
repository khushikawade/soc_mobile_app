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
    )
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
