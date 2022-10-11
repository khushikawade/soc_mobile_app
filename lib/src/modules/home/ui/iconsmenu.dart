class IconsMenu {
  static const items = <IconMenu>[Information, Setting, Permissions, Calender];

  static const Information = IconMenu(
    text: 'Information',
  );

  static const Setting = IconMenu(
    text: 'Settings',
  );

  static const Permissions = IconMenu(
    text: 'Permission',
  );
  static const Calender = IconMenu(text: 'Calender');
}

class IconMenu {
  final String text;

  const IconMenu({
    required this.text,
  });
}
