import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_icons.dart';
import 'package:flutter/material.dart';

class PBISPlusActionInteractionModal {
  String title;
  Color color;
  IconData iconData;
  PBISPlusActionInteractionModal(
      {required this.title, required this.color, required this.iconData});

  static List<PBISPlusActionInteractionModal> PBISPlusActionInteractionIcons = [
    PBISPlusActionInteractionModal(
        iconData: PBISPlusIcons.like, color: Colors.red, title: 'Engaged'),
    PBISPlusActionInteractionModal(
        iconData: PBISPlusIcons.thanks, color: Colors.blue, title: 'Nice work'),
    PBISPlusActionInteractionModal(
        iconData: PBISPlusIcons.help, color: Colors.green, title: 'Helpful')
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
        iconData: PBISPlusIcons.like, color: Colors.transparent, title: 'Date'),
    PBISPlusDataTableModal(
        iconData: PBISPlusIcons.like, color: Colors.red, title: 'Engaged'),
    PBISPlusDataTableModal(
        iconData: PBISPlusIcons.thanks, color: Colors.blue, title: 'Nice work'),
    PBISPlusDataTableModal(
        iconData: PBISPlusIcons.help, color: Colors.green, title: 'Helpful'),
    PBISPlusDataTableModal(
        iconData: PBISPlusIcons.help, color: Colors.transparent, title: 'Total')
  ];
}
