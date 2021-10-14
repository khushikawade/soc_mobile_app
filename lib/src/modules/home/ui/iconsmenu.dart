class IconsMenu {
  static const items = <IconMenu>[
    Information,
    Setting,
    Permissions,
    Accessibility,
  ];

  static const Information = IconMenu(
    text: 'Information',
  );

  static const Setting = IconMenu(
    text: 'Settings',
  );

  static const Permissions = IconMenu(
    text: 'Permission',
  );

  static const Accessibility = IconMenu(
    text: 'Accessibility',
  );
}

class IconMenu {
  final String text;

  const IconMenu({
    required this.text,
  });
}
