import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchFieldWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
  FocusNode myFocusNode = new FocusNode();
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing),
        color: AppTheme.kFieldbackgroundColor,
        child: TextFormField(
          focusNode: myFocusNode,
          decoration: InputDecoration(
              isDense: true,
              labelText: 'Search',
              filled: true,
              fillColor: AppTheme.kBackgroundColor,
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                const IconData(0xe805,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kprefixIconColor,
              )),
        ),
      ),
    );
  }
}
