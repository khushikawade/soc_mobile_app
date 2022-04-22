import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/ocr/ui/image_to_text.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Ocr extends StatefulWidget {
  const Ocr({Key? key}) : super(key: key);

  @override
  State<Ocr> createState() => _OcrState();
}

class _OcrState extends State<Ocr> {
  static const double _KButtonSize = 110.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarTitle: 'OCR',
        isSearch: true,
        isShare: false,
        language: Globals.selectedLanguage,
        isCenterIcon: false,
        ishtmlpage: false,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
      ),
      body: Center(
          child: Column(children: [
        button(
            title: 'Free Method',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ImageToText()));
            }),
        SizedBox(
          height: 20,
        ),
        button(onPressed: null, title: 'Paid Method')
      ])),
    );
  }

  Widget button({required onPressed, required String title}) {
    return Container(
      constraints: BoxConstraints(
        minWidth: _KButtonSize,
        maxWidth: 230.0,
        minHeight: _KButtonSize / 2,
        maxHeight: _KButtonSize / 2,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: TranslationWidget(
          message: title,
          toLanguage: Globals.selectedLanguage,
          fromLanguage: "en",
          builder: (translatedMessage) => Text(
            translatedMessage.toString(),
          ),
        ),
      ),
    );
  }
}
