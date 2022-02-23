import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

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
    // String? htmlData;
    // if (widget.htmlText.toString().contains("img") == true &&
    //     widget.htmlText.toString().contains("src=") == true) {
    //   String img = Utility.getHTMLImgSrc(widget.htmlText);
    //   htmlData = widget.htmlText.toString().replaceAll("$img ", " ");
    // }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Wrap(
        children: [
          // widget.htmlText.toString().contains("src=") &&
          //         widget.htmlText.toString().split('"')[1] != ""
          //     ? Container(
          //         alignment: Alignment.center,
          //         child: ClipRRect(
          //           child: CachedNetworkImage(
          //             imageUrl: Utility.getHTMLImgSrc(widget.htmlText),
          //             fit: BoxFit.cover,
          //             placeholder: (context, url) => Container(
          //                 alignment: Alignment.center,
          //                 child: ShimmerLoading(
          //                   isLoading: true,
          //                   child: Container(
          //                     width: MediaQuery.of(context).size.width * 0.8,
          //                     height: MediaQuery.of(context).size.width * 0.5,
          //                     color: Colors.white,
          //                   ),
          //                 )),
          //             errorWidget: (context, url, error) => Container(),
          //           ),
          //         ),
          //       )
          //     : Container(),
          TranslationWidget(
            message: widget.htmlText,
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) => Html(
              data: translatedMessage,
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) {
                // print(url);
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
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: true,
        appBarTitle: widget.appbarTitle,
        ishtmlpage: widget.ishtml,
        // sharedpopBodytext:parseHtmlString(widget.htmlText),
        sharedpopBodytext: widget.htmlText
            .replaceAll('<img src=', ' ')
            .replaceAll('data-imageguid=', '</')
            .replaceAll(exp, '')
            .toString(),
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
