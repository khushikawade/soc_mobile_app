import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/soicalwebview.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  var object;
  String? language;
  SocialDescription({required this.object, this.language});
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  static const double _kIconSize = 45.0;
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

  void htmlparser() {
    List<String> data = [];

    data.add(object.description["__cdata"]
        .getElementsByClassName("time")[0]
        .innerHtml);

    final temp =
        object.description["__cdata"].getElementsByClassName("temp")[0];
    data.add(temp.innerHtml.substring(0, temp.innerHtml.indexOf("<span>")));
    data.add(temp
        .getElementsByTagName("small")[0]
        .innerHtml
        .replaceAll(RegExp("[(|)|℃]"), ""));

    final rows = object.description["__cdata"]
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
        child: RefreshIndicator(
          key: refreshKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: ListView(children: [
              Column(
                children: [
                  _buildnews(context),
                  SpacerWidget(_kPadding / 2),
                  _buildnewTimeStamp(context),
                  SpacerWidget(_kPadding / 5),
                  _buildBottomSection(context),
                  SpacerWidget(_kPadding / 2),
                  _buildButton(context),
                  SpacerWidget(_kPadding * 3),
                  Container(
                    height: 0,
                    width: 0,
                    child: BlocListener<HomeBloc, HomeState>(
                      bloc: _homeBloc,
                      listener: (context, state) async {
                        if (state is BottomNavigationBarSuccess) {
                          AppTheme.setDynamicTheme(Globals.appSetting, context);
                          Globals.homeObjet = state.obj;
                        }
                      },
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          onRefresh: refreshPage,
        ));
  }

  Widget _buildButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(_kPadding / 2),
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
                child: Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
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
                child: Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
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

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }

  Widget _buildBottomSection(BuildContext context) {
    String data = object.description["__cdata"].toString().contains("\\n")
        ? object.description["__cdata"]
            .toString()
            .split("<div>")[2]
            .split("\\n")[0]
        : "";
    String data2 = object.description["__cdata"].toString().contains("\\n")
        ? object.description["__cdata"]
            .toString()
            .split("\\n#")[1]
            .split("</div>")[0]
        : "";

    // String _socialDescription = object.description["__cdata"]
    //     .toString()
    //     .replaceAll(new RegExp(r'[\\]+'), '\n')
    //     .replaceAll("n.", ".")
    //     .replaceAll("\nn", "\n")
    //     .replaceAll("n ", "");

    return Column(
      children: [
        HorzitalSpacerWidget(_kPadding / 4),
        object.description != null &&
                object.description["__cdata"] != null &&
                object.description["__cdata"]
                    .toString()
                    .contains("<img src=") &&
                object.description["__cdata"].toString().split('"')[1] != ""
            ? Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        Utility.getHTMLImgSrc(object.description["__cdata"]),
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: _kIconSize * 1.4,
                            height: _kIconSize * 1.5,
                            color: Colors.white,
                          ),
                        )),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
                // child: Html(
                //     data: "<img" +
                //         "${object.description["__cdata"].toString().split("<img")[1].split(">")[0]}" +
                //         ">"),
              )
            : Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: Globals.homeObjet["App_Logo__c"],
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: _kIconSize * 1.4,
                            height: _kIconSize * 1.5,
                            color: Colors.white,
                          ),
                        )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
        Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: "${data + "#" + data2}",
                fromLanguage: "en",
                toLanguage: language,
                builder: (translatedMessage) => Text(
                  translatedMessage
                      .toString()
                      .replaceAll(new RegExp(r'[\\]+'), '\n')
                      .replaceAll("n.", ".")
                      .replaceAll("\nn", "\n")
                      .replaceAll("\\ n ", ""),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant),
                ),
              )
            : Center(
                child: Html(
                  onImageError: (m, d) {},
                  customRender: {
                    "img": (RenderContext context, Widget child) {
                      return Container();
                    },
                  },
                  data:
                      "${object.description["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n").replaceAll("n ", "")}",
                  style: {
                    "body": Style(
                      color: Theme.of(context).colorScheme.primaryVariant,
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

  Widget _buildnews(BuildContext context) {
    return Wrap(children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message:
                    "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}",
                fromLanguage: "en",
                toLanguage: language,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant),
                ),
              )
            : Text(
                "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.primaryVariant),
              ),
      ),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Container(
        child: object != null && object.pubDate.length > 1
            ? Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: Utility.convertDate(object.pubDate).toString(),
                    toLanguage: language,
                    builder: (translatedMessage) => Text(
                      translatedMessage.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant),
                    ),
                  )
                : Text(
                    Utility.convertDate(object.pubDate).toString(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.primaryVariant),
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
