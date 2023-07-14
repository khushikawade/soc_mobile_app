import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class FamilyVerificationCommonWidget {
  /* ------------------ Widget to show title and description in family login flow ----------------- */
  static Widget titleAndDesWidget(
      {required BuildContext context,
      required String title,
      String? description}) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Utility.textWidget(
              text: title,
              context: context,
              textTheme: Theme.of(context).textTheme.headline1),
          SpacerWidget(10),
          Utility.textWidget(
              textAlign: TextAlign.center,
              text: description ?? '',
              context: context,
              textTheme: Theme.of(context).textTheme.headline3)
        ]));
  }

  static Widget familyCircularIcon(
      {required BuildContext context, required String assetImageUrl}) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        // width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(assetImageUrl)),
            color: Colors.black,
            shape: BoxShape.circle));
  }

  static PreferredSizeWidget familyLoginAppBar(
      {required BuildContext context, required bool isBackButton}) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: isBackButton == true
            ? IconButton(
                icon: Icon(
                    IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor),
                onPressed: () {
                  Navigator.pop(context);
                })
            : Container());
  }
}
