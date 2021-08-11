import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ErrorMessageWidget extends StatelessWidget {
  final String? msg;
  final bool? isnetworkerror;
  int icondata = 0xe81c;
  ErrorMessageWidget({
    Key? key,
    required this.msg,
    required this.isnetworkerror,
    required this.icondata,
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
            child: Icon(
              IconData(icondata,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              size: Globals.deviceType == "phone" ? 20 : 28,
              color: Colors.black,
              // Theme.of(context).primaryColor,
            ),
          ),
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
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : Text(msg!),
                ),
        ],
      ),
    );
  }
}
