import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/widgets/action_button_basic.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/selectable_html_widget.dart';
import 'package:Soc/src/widgets/soicalwebview.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  Item object;

  String? language;
  int? index;
  // final List? icons;
  // final List? iconsName;
  SocialDescription({
    required this.object,
    this.language,
    this.index,
    // required this.iconsName,
    // required this.icons
  });
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  // static const double _kIconSize = 45.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();

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

  // void htmlparser() {
  //   List<String> data = [];

  //   data.add(object.description != null && object.description != ""
  //       ? object.description["__cdata"]
  //           .getElementsByClassName("time")[0]
  //           .innerHtml
  //       : "");

  //   final temp = object.description != null && object.description != ""
  //       ? object.description["__cdata"].getElementsByClassName("temp")[0]
  //       : "";
  //   data.add(temp.innerHtml.substring(0, temp.innerHtml.indexOf("<span>")));
  //   data.add(temp
  //       .getElementsByTagName("small")[0]
  //       .innerHtml
  //       .replaceAll(RegExp("[(|)|℃]"), ""));

  //   final rows = object.description != null && object.description != ""
  //       ? object.description["__cdata"]
  //           .getElementsByTagName("table")[0]
  //           .getElementsByTagName("td")
  //       : "";

  //   rows.map((e) => e.innerHtml).forEach((element) {
  //     if (element != "-") {
  //       data.add(element);
  //     }
  //   });
  // }

  Widget _buildItem(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      child: ListView(padding: const EdgeInsets.all(_kPadding), children: [
        Column(
          children: [
            _buildnews(context),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(context),
            SpacerWidget(_kPadding / 5),
            _buildBottomSection(context),
            SpacerWidget(_kPadding / 2),
            _buildActionCount(context),
            SpacerWidget(_kPadding / 2),
            _buildButton(context),
            SpacerWidget(_kPadding * 2),
            Container(
              height: 0,
              width: 0,
              child: BlocListener<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listener: (context, state) async {
                  if (state is BottomNavigationBarSuccess) {
                    AppTheme.setDynamicTheme(Globals.appSetting, context);
                    //   Globals.homeObject = state.obj;
                    Globals.appSetting = AppSetting.fromJson(state.obj);
                  }
                },
                child: Container(),
              ),
            ),
          ],
        ),
      ]),
      onRefresh: refreshPage,
    );
  }

  Widget _buildButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(_kPadding / 6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                minWidth: _KButtonSize,
                maxWidth: 130.0,
                minHeight: _KButtonSize / 2,
                maxHeight: _KButtonSize / 2,
              ),
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
                child: TranslationWidget(
                  message: "More",
                  toLanguage: language,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildBottomSection(BuildContext context) {
    // String data = object.description["__cdata"].toString()
    // .contains("\\n")
    //     ? object.description["__cdata"]
    //         .toString()
    //         .split("<div>")[2]
    //         .split("\\n")[0]
    //     : "";
    // String data2 = object.description["__cdata"].toString().contains("\\n#")
    //     ? object.description["__cdata"]
    //         .toString()
    //         .split("\\n#")[1]
    //         .split("</div>")[0]
    //     : "";
    // String _socialDescription = object.description["__cdata"]
    //     .toString()
    //     .replaceAll(new RegExp(r'[\\]+'), '\n')
    //     .replaceAll("n.", ".")
    //     .replaceAll("\nn", "\n")
    //     .replaceAll("n ", "");

    return Column(
      children: [
        HorzitalSpacerWidget(_kPadding / 4),
        (object.enclosure != null &&
                    object.enclosure != "" &&
                    object.enclosure['url'] != null &&
                    object.enclosure['url'] != "") ||
                (object.description != null &&
                    object.description != "" &&
                    object.description["__cdata"] != null &&
                    object.description["__cdata"]
                        .toString()
                        .contains("<img src=") &&
                    object.description["__cdata"].toString().split('"')[1] !=
                        "")
            ? Container(
                alignment: Alignment.center,
                child: CommonImageWidget(
                    isOnTap: true,
                    iconUrl: object.enclosure['url'] ??
                        Utility.getHTMLImgSrc(object.description["__cdata"]) ??
                        Globals.splashImageUrl ??
                        // Globals.homeObject["App_Logo__c"],
                        Globals.appSetting.appLogoC,
                    fitMethod: BoxFit.contain,
                    height: Utility.displayHeight(context) *
                        (AppTheme.kDetailPageImageHeightFactor / 100)))
            : Container(
                alignment: Alignment.center,
                child: CommonImageWidget(
                    isOnTap: true,
                    iconUrl: Globals.splashImageUrl ??
                        // Globals.homeObject["App_Logo__c"],
                        Globals.appSetting.appLogoC,
                    fitMethod: BoxFit.contain,
                    height: Utility.displayHeight(context) *
                        (AppTheme.kDetailPageImageHeightFactor / 100))),
        SpacerWidget(_kPadding),
        TranslationWidget(
          message:
              "${object.description != null && object.description != "" ? object.description["__cdata"].replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n").replaceAll("n ", "").replaceAll("\\ n ", "") : ""}",
          // "${data + "#" + data2}",
          fromLanguage: "en",
          toLanguage: language,
          builder: (translatedMessage) => 
          // SelectableHTMLWidget // Html
          SelectableHtml(
            onLinkTap: (String? url, RenderContext context,
                Map<String, String> attributes, dom.Element? element) {
              _launchURL(url, context);
            },
            // customRender: {
            //   "img": (RenderContext context, Widget child) {
            //     return Container();
            //   },
            // },
            data: translatedMessage.toString(),
            style: {
              "body": Style(
                fontSize: Globals.deviceType == "phone"
                    ? FontSize(13.0)
                    : FontSize(21.0),
              ),
            },
          ),
        )
      ],
    );
  }

  _launchURL(obj, context) async {
    await Utility.launchUrlOnExternalBrowser(obj);
  }

  Widget _buildnews(BuildContext context) {
    return Wrap(children: [
      Container(
        alignment: Alignment.centerLeft,
        child: TranslationWidget(
          message:
              "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}",
          fromLanguage: "en",
          toLanguage: language,
          builder: (translatedMessage) => SelectableHtml(
            data: translatedMessage.toString(),
            // style: Theme.of(context).textTheme.subtitle1!,
            onLinkTap: (String? url, RenderContext context,
                Map<String, String> attributes, dom.Element? element) {
              _launchURL(url, context);
            },
          ),
        ),
      ),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Container(
        child: object != null && object.pubDate.length > 1
            ? TranslationWidget(
                message: Utility.convertDate(object.pubDate).toString(),
                toLanguage: language,
                builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.subtitle1!),
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

  _buildActionCount(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: NewsActionBasic(
        page: "social",
        obj: object,
        // icons: icons,
        // iconsName: iconsName,
      ),
    );
  }
}
