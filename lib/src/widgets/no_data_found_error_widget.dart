import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/Strings.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class NoDataFoundErrorWidget extends StatelessWidget {
  bool isResultNotFoundMsg;
  NoDataFoundErrorWidget({Key? key, required this.isResultNotFoundMsg})
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
              child: SvgPicture.asset(
                Strings.noDataIconPath,
                fit: BoxFit.cover,
              )),
          SpacerWidget(12),
          Container(
            alignment: Alignment.center,
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: isResultNotFoundMsg
                        ? "No result found"
                        : "No data found",
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                        style: Theme.of(context).textTheme.bodyText1!),
                  )
                : Text(
                    isResultNotFoundMsg ? "No result found" : "No data found",
                    style: Theme.of(context).textTheme.bodyText1!),
          ),
        ],
      ),
    );
  }
}
