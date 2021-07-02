import 'package:flutter/material.dart';
// import '../screens/lanuage-selector.dart';
// import 'package:containerapp/src/overrides.dart' as overries;

class LanguageSelectorIconButton extends StatelessWidget {
  var color;
  LanguageSelectorIconButton(this.color);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // _languageIconTapped(context);
      },
      icon: Icon(
        Icons.ac_unit,
        color: color,
      ),
    );
  }

  // _languageIconTapped(BuildContext context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => LanguageSelectorPage(),
  //     ),
  //   );
  // }
}
