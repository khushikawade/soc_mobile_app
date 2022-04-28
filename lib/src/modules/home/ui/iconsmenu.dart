class IconsMenu {
  static const items = <IconMenu>[
    Information,
    Setting,
    Permissions,
    Camera,
    Login   
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
  
  static const Camera = IconMenu(
    text: 'Camera',
  );

  static const Login = IconMenu(
    text: 'Login',
  );
  
  
}

class IconMenu {
  final String text;

  const IconMenu({
    required this.text,
  });
}
