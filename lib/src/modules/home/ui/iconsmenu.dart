class IconsMenu {
  static const items = <IconMenu>[Information, Setting, Permissions, Camera,Google];

  static const Information = IconMenu(
    text: 'Information',
  );

  static const Setting = IconMenu(
    text: 'Settings',
  );

  static const Permissions = IconMenu(
    text: 'Permission',
  );

  static const Camera = IconMenu(
    text: 'Camera',
  );

  static const Google = IconMenu(
    text: 'Google',
  );
}

class IconMenu {
  final String text;

  const IconMenu({
    required this.text,
  });
}
