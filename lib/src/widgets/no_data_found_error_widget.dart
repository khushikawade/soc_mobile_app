import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/services/Strings.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  bool isResultNotFoundMsg;
  bool ?isNews;
  NoDataFoundErrorWidget({Key? key, required this.isResultNotFoundMsg,required this.isNews})
      : super(key: key);

  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.25,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              Strings.noDataIconPath,
              fit: BoxFit.cover,
            )),
        SpacerWidget(12),
        Container(
          alignment: Alignment.center,
          child: Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English" &&
                  Globals.selectedLanguage != ""
              ? TranslationWidget(
                  message: isNews!?"No Message Yet":isResultNotFoundMsg
                      ? "No result found"
                      : "No data found",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText1!),
                )
              : Text(
                  isNews!?"No Message Yet":isResultNotFoundMsg ? "No result found" : "No data found",
                  style: Theme.of(context).textTheme.bodyText1!),
        ),
      ],
    );
  }
}
