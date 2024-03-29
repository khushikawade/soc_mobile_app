import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/action_interaction_button.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/socialwebview.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
// import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class SocialDescription extends StatelessWidget {
  Item object;
  String? language;
  int? index;

  SocialDescription({
    required this.object,
    this.language,
    this.index,
  });
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  // static const double _kIconSize = 45.0;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();

  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  // int objectindex = 0;
  int? itemCount;
  int pageIndex = 0;
  String heading1 = '';
  String heading2 = '';
  String heading3 = '';
  // int initailIndex = 0;
  int currentIndex = 0;
  // int firstindex = 0;
  late int lastIndex;

  var date;
  var link;
  var link2;
  // int pageviewItem = 0;
  // int indexpostion = 0;

  void increasIndexValue() {
    this.currentIndex++;
  }

  Widget _buildItem(BuildContext context) {
    FirebaseAnalyticsService.addCustomAnalyticsEvent('social_description');
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'social_description', screenClass: 'SocialDescription');

    return RefreshIndicator(
      key: refreshKey,
      child: ListView(padding: const EdgeInsets.all(_kPadding), children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          builder: (context) => SocialPageWebview(
                                link: link2,
                                isSocialpage: true,
                                isBottomSheet: true,
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

    await Future.delayed(Duration(seconds: 2));
    _homeBloc.add(FetchStandardNavigationBar());
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        HorizontalSpacerWidget(_kPadding / 4),
        (object.mediaContent != null &&
                    object.mediaContent != "" &&
                    object.mediaContent != null &&
                    object.mediaContent != "") ||
                (object.description != null &&
                    object.description != "" &&
                    // object.description != null &&
                    object.description.toString().contains("<img src=") &&
                    object.description.toString().split('"')[1] != "")
            ? Container(
                alignment: Alignment.center,
                child: CommonImageWidget(
                    isOnTap: true,
                    iconUrl: (object.mediaContent != null &&
                            object.mediaContent != "" &&
                            object.mediaContent != null &&
                            object.mediaContent != "")
                        ? object.mediaContent
                        : Utility.getHTMLImgSrc(object.description) != ''
                            ? Utility.getHTMLImgSrc(object.description)
                            : Globals.splashImageUrl ??
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
              "${object.description != null && object.description != "" ? object.description.toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n").replaceAll("n ", "").replaceAll("\\ n ", "").replaceAll('⁦', '').replaceAll('⁩', '') : ""}",
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
            message: object.title != null && object.title != ""
                ? "${object.title.toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n").replaceAll('⁦', '').replaceAll('⁩', '')}"
                : "",
            fromLanguage: "en",
            toLanguage: language,
            builder: (translatedMessage) => RichText(
                    text: TextSpan(children: [
                  WidgetSpan(child: widgetIcon(object.link, context)),
                  WidgetSpan(
                    child: SelectableHtml(
                      data: translatedMessage.toString(),
                      // style: Theme.of(context).textTheme.subtitle1!,
                      onLinkTap: (String? url,
                          RenderContext context,
                          Map<String, String> attributes,
                          dom.Element? element) {
                        _launchURL(url, context);
                      },
                    ),
                  )
                ]))),
      ),
      SpacerWidget(_kPadding),
    ]);
  }

  Widget _buildnewTimeStamp(BuildContext context) {
    return Container(
        child: object != null &&
                object.pubDate != null &&
                object.pubDate.length > 1
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
    return
        // VisibilityDetector(
        //     key: Key('rss-feed-post'),
        //     onVisibilityChanged: (visibilityInfo) {
        //       ActionInteractionButtonWidget(
        //         // view: view,
        //         isViewInteraction: true,
        //         page: "social",
        //         obj: object,
        //         title:
        //             object.title != "" && object.title != null ? object.title : "",
        //         description:
        //             object.title != "" && object.title != null ? object.title : "",
        //         imageUrl: object.mediaContent != "" &&
        //                 object.mediaContent != null &&
        //                 object.mediaContent != "" &&
        //                 object.mediaContent != null
        //             ? object.mediaContent
        //             : "",
        //         imageExtType: object.mediaContent != "" &&
        //                 object.mediaContent != null &&
        //                 object.mediaContent.toString().split(".").last != "" &&
        //                 object.mediaContent.toString().split(".").last != null
        //             ? object.mediaContent.toString().split(".").last
        //             : "",
        //       );
        //     },
        //     child:
        Container(child: _buildItem(context));
    //  );
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
    return ActionInteractionButtonWidget(
      page: "social",
      obj: object,
      title: object.title != "" && object.title != null ? object.title : "",
      description:
          object.title != "" && object.title != null ? object.title : "",
      imageUrl: object.mediaContent != "" &&
              object.mediaContent != null &&
              object.mediaContent != "" &&
              object.mediaContent != null
          ? object.mediaContent
          : "",
      imageExtType: object.mediaContent != "" &&
              object.mediaContent != null &&
              object.mediaContent.toString().split(".").last != "" &&
              object.mediaContent.toString().split(".").last != null
          ? object.mediaContent.toString().split(".").last
          : "",
    );
  }

  Widget widgetIcon(link, context) {
    if (link.contains('instagram')) {
      return ShaderMask(
          shaderCallback: (bounds) => RadialGradient(
                center: Alignment.topRight,
                transform: GradientRotation(50),
                radius: 5,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.red,
                  Colors.yellow,
                  Color(0xffee2a7b),
                  Colors.red,
// Color(0xff002aff),
                ],
              ).createShader(bounds),
          child: Padding(
            padding: EdgeInsets.only(bottom: 1),
            child: FaIcon(
              FontAwesomeIcons.instagram,
              size: Globals.deviceType == 'phone' ? 18 : 22,
              color: Colors.white,
            ),
          ));

// iconWidget(

// FontAwesomeIcons.instagramSquare, [Colors.cyan, Colors.yellow]);
    } else if (link.contains('twitter')) {
      return iconWidget(FontAwesomeIcons.twitter, Color(0xff1DA1F2), context);
    } else if (link.contains('facebook')) {
      return Padding(
          padding: EdgeInsets.only(bottom: 1),
          child: iconWidget(
              FontAwesomeIcons.facebook, Color(0xff4267B2), context));
    } else if (link.contains('youtube')) {
      return iconWidget(FontAwesomeIcons.youtube, Color(0xffFF0000), context);
    } else if (link.contains('pinterest')) {
      return iconWidget(FontAwesomeIcons.pinterest, Color(0xffFF0000), context);
    }

    return Container();
  }

  Widget iconWidget(icon, color, context) {
    return FaIcon(
      icon,
      size: Globals.deviceType == 'phone' ? 18 : 22,
      // MediaQuery.of(context).size.height *0.02,
      color: color,
    );
  }
}
