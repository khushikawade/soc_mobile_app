import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class FamilyLoginCommonWidget {
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
            text: 'Enter your email below to receive a one-time password.',
            context: context,
            textTheme: Theme.of(context).textTheme.headline3)
      ]),
    );
  }

  static Widget familyCircularIcon({required BuildContext context, required String assetImageUrl}) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.5,
      // width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_lock.png')),
          color: Colors.black,
          shape: BoxShape.circle),
    );
  }
}
