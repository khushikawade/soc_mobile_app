import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/strings.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ErrorMsgWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return _buildNetworkerror(context);
  }

  Widget _buildNetworkerror(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.25,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Strings.errorIconPath,
                fit: BoxFit.cover,
              )),
          SpacerWidget(12),
          Container(
            alignment: Alignment.center,
            child: TranslationWidget(
              message: "Something Went Wrong",
              toLanguage: Globals.selectedLanguage,
              fromLanguage: "en",
              builder: (translatedMessage) => Text(translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText1!),
            ),
          ),
        ],
      ),
    );
  }
}
