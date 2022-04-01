import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class AboutusPage extends StatefulWidget {
  final String htmlText;
  final String? language;
  final bool isbuttomsheet;
  final bool ishtml;
  final String appbarTitle;
  final bool? isAppBar;

  @override
  AboutusPage({
    Key? key,
    required this.htmlText,
    required this.isbuttomsheet,
    required this.ishtml,
    required this.appbarTitle,
    required this.language,
    this.isAppBar,
  }) : super(key: key);
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
          TranslationWidget(
            message: widget.htmlText,
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) => Html(
              data: translatedMessage,
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) {
                _launchURL(url);
              },
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
                'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppBar == false
          ? null
          : CustomAppBarWidget(
              isSearch: false,
              isShare: true,
              appBarTitle: widget.appbarTitle,
              ishtmlpage: widget.ishtml,
              sharedpopBodytext: Utility.parseHtml(widget.htmlText
                  .replaceAll('<img src=', ' ')
                  .replaceAll('data-imageguid=', '</')),
              sharedpopUpheaderText: "Please checkout this link",
              language: Globals.selectedLanguage,
            ),
      body: ListView(children: [
        Container(
            padding: EdgeInsets.only(bottom: 20), child: _buildContent1()),
      ]),
    );
  }

  _launchURL(obj) async {
    if (obj.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: widget.appbarTitle.toString(),
                    url: obj,
                    isbuttomsheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }
}
