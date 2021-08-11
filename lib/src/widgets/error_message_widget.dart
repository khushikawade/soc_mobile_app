import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? imgURL;
  final String? msg;
  ErrorMessageWidget({Key? key, required this.imgURL, required this.msg})
      : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.12,
            ),
            alignment: Alignment.center,
            child: Image.asset(imgURL!, fit: BoxFit.contain),
          ),
          SpacerWidget(12),
          Container(
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
