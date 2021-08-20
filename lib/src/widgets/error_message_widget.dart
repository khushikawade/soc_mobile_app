import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ErrorMessageWidget extends StatelessWidget {
  final String? msg;
  final bool? isnetworkerror;
  final String imgPath;
  ErrorMessageWidget({
    Key? key,
    required this.msg,
    required this.isnetworkerror,
    required this.imgPath,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.12,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                imgPath,
                fit: BoxFit.cover,
              )),
          SpacerWidget(12),
          isnetworkerror!
              ? Text(msg!)
              : Container(
                  alignment: Alignment.center,
                  child: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: msg,
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                              style: Theme.of(context).textTheme.bodyText1!),
                        )
                      : Text(msg!,
                          style: Theme.of(context).textTheme.bodyText1!),
                ),
        ],
      ),
    );
  }
}
