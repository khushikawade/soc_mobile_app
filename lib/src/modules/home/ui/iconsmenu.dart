import 'package:flutter/material.dart';

class IconsMenu {
  static const items = <IconMenu>[
    Information,
    Setting,
    Permissions,
  ];
  // static const _kPopMenuTextStyle = TextStyle(
  //     fontFamily: "Roboto Regular", fontSize: 14, color: Color(0xff474D55));

  static const Information = IconMenu(
    text: 'Information',
  );

  static const Setting = IconMenu(
    text: 'Settings',
  );

  static const Permissions = IconMenu(
    text: 'Permissions',
  );
}

class IconMenu {
  final String text;

  const IconMenu({
    required this.text,
  });
}
