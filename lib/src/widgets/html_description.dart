import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class AboutusPage extends StatefulWidget {
  String htmlText;
  String? language;
  bool isbuttomsheet;
  bool ishtml;
  String appbarTitle;

  @override
  AboutusPage(
      {Key? key,
      required this.htmlText,
      // required this.url,
      required this.isbuttomsheet,
      required this.ishtml,
      required this.appbarTitle,
      required this.language})
      : super(key: key);
  @override
  _AboutusPageState createState() => _AboutusPageState();
}

class _AboutusPageState extends State<AboutusPage> {
  static const double _kLabelSpacing = 20.0;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  Widget _buildContent1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Wrap(
        children: [
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: widget.htmlText,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Html(
                    data: translatedMessage.toString(),
                  ),
                )
              : Html(
                  data: widget.htmlText,
                  style: {
                    "table": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topLeft,
                    ),
                    'h5':
                        Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                  },
                ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        appBarTitle: widget.appbarTitle,
        ishtmlpage: widget.ishtml,
        sharedpopBodytext: widget.htmlText.replaceAll(exp, '').toString(),
        sharedpopUpheaderText: "Please checkout this link",
        language: Globals.selectedLanguage,
      ),
      body: ListView(children: [
        _buildContent1(),
      ]),
    );
  }
}
