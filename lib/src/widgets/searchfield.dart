import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchFieldWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
  FocusNode myFocusNode = new FocusNode();
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _kLabelSpacing / 2, horizontal: _kLabelSpacing),
      color: AppTheme.kFieldbackgroundColor,
      child: TextFormField(
        focusNode: myFocusNode,
        decoration: InputDecoration(
            labelText: 'Search',
            filled: true,
            fillColor: AppTheme.kBackgroundColor,
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              IconData(0xe805,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kprefixIconColor,
            )),
      ),
    );
  }
}
