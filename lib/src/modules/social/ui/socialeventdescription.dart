import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/soicalwebview.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  var object;
  String? language;
  SocialDescription({required this.object, this.language});
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;

  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  int objectindex = 0;
  int? itemcount;
  int pageindex = 0;
  String heading1 = '';
  String heading2 = '';
  String heading3 = '';
  int initailindex = 0;
  int currentindex = 0;
  int firstindex = 0;
  late int lastindex;

  var date;
  var link;
  var link2;
  int pageviewItem = 0;
  int indexpostion = 0;

  void increasIndexValue() {
    this.currentindex++;
  }

  void htmlparser() {
    List<String> data = [];

    data.add(object.description["__cdata"]
        .getElementsByClassName("time")[0]
        .innerHtml);

    var temp = object.description["__cdata"].getElementsByClassName("temp")[0];
    data.add(temp.innerHtml.substring(0, temp.innerHtml.indexOf("<span>")));
    data.add(temp
        .getElementsByTagName("small")[0]
        .innerHtml
        .replaceAll(RegExp("[(|)|℃]"), ""));

    var rows = object.description["__cdata"]
        .getElementsByTagName("table")[0]
        .getElementsByTagName("td");

    rows.map((e) => e.innerHtml).forEach((element) {
      if (element != "-") {
        data.add(element);
      }
    });
  }

  Widget _buildItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: ListView(children: [
        Column(
          children: [
            _buildnews(context),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(context),
            SpacerWidget(_kPadding / 5),
            _buildbuttomsection(context),
            SpacerWidget(_kPadding / 2),
            _buildButton(context),
            SpacerWidget(_kPadding * 3),
          ],
        ),
      ]),
    );
  }

  Widget _buildButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(_kPadding / 2),
        color: AppTheme.kBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: _KButtonSize,
              height: _KButtonSize / 2,
              child: ElevatedButton(
                onPressed: () async {
                  _buildlink();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoicalPageWebview(
                                link: link2,
                                isSocialpage: true,
                                isbuttomsheet: true,
                              )));
                },
                child: language != null && language != "English"
                    ? TranslationWidget(
                        message: "More",
                        toLanguage: language,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      )
                    : Text("More"),
              ),
            ),
            HorzitalSpacerWidget(_kPadding / 2),
            SizedBox(
              width: _KButtonSize,
              height: _KButtonSize / 2,
              child: ElevatedButton(
                onPressed: () async {
                  SharePopUp obj = new SharePopUp();
                  String link = await _buildlink();
                  final String body =
                      "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}"
                              " " +
                          link;
                  obj.callFunction(context, body, "");
                },
                child: language != null && language != "English"
                    ? TranslationWidget(
                        message: "Share".toString(),
                        toLanguage: language,
                        fromLanguage: "en",
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      )
                    : Text("Share"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildbuttomsection(BuildContext context) {
    var data = object.description["__cdata"]
        .toString()
        .split("<div>")[2]
        .split("\\n")[0];
    var data2 = object.description["__cdata"]
        .toString()
        .split("\\n#")[1]
        .split("</div>")[0];
    // print(data);
    print(data2);
    return Column(
      children: [
        HorzitalSpacerWidget(_kPadding / 4),
        object.description["__cdata"] != null &&
                object.description["__cdata"]
                    .toString()
                    .contains("<img src=") &&
                object.description["__cdata"].toString().split('"')[1] != ""
            ? Html(
                data: "<img" +
                    "${object.description["__cdata"].toString().split("<img")[1].split(">")[0]}" +
                    ">")
            : Container(
                alignment: Alignment.center,
                child: Image(image: AssetImage("assets/images/appicon.png")),
              ),
        language != null && language != "English"
            ? Column(
                children: [
                  TranslationWidget(
                    message: data,
                    fromLanguage: "en",
                    toLanguage: language,
                    builder: (translatedMessage) => Text(
                      translatedMessage
                          .toString()
                          .replaceAll(new RegExp(r'[\\]+'), '\n')
                          .replaceAll("n.", ".")
                          .replaceAll("\nn", "\n")
                          .replaceAll("\\ n ", ""),
                    ),
                  ),
                  Text(
                    "#" + data2,
                  )
                ],
              )
            : Html(
                data:
                    "${object.description["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n").replaceAll("n ", "")}",
              )
      ],
    );
  }

  Widget _buildnews(BuildContext context) {
    return Wrap(children: [
      object != null && object.title["__cdata"].length > 1
          ? Container(
              alignment: Alignment.centerLeft,
              child: language != null && language != "English"
                  ? TranslationWidget(
                      message:
                          "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}",
                      fromLanguage: "en",
                      toLanguage: language,
                      builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                      ),
                    )
                  : Text(
                      "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}",
                      textAlign: TextAlign.left,
                    ),
            )
          : language != null && language != "English"
              ? TranslationWidget(
                  message: "No headline found",
                  fromLanguage: "en",
                  toLanguage: language,
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                  ),
                )
              : Text("No headline found"),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Container(
        child: object != null && object.pubDate.length > 1
            ? language != null && language != "English"
                ? TranslationWidget(
                    message: Utility.convertDate(object.pubDate).toString(),
                    toLanguage: language,
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                : Text(
                    Utility.convertDate(object.pubDate).toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
            : Container());
  }

  Widget build(BuildContext context) {
    return Container(child: _buildItem(context));
  }

  Future<String> _buildlink() async {
    link = object.link.toString();
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(link);
    matches.forEach((match) {
      link2 = link.substring(match.start, match.end);
    });
    return link2;
  }
}
