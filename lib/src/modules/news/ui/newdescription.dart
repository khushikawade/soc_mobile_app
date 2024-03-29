import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/modules/social/modal/item.dart';
import 'package:Soc/src/widgets/action_interaction_button.dart';
import 'package:Soc/src/widgets/common_image_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:io' show Platform;
import 'package:visibility_detector/visibility_detector.dart';

class NewsDescription extends StatefulWidget {
  NewsDescription({
    Key? key,
    required this.obj,
    required this.date,
    required this.isBottomSheet,
    required this.language,
    required this.connected,
  }) : super(key: key);

  final Item obj;
  final String date;
  final bool isBottomSheet;
  final String? language;
  final bool? connected;

  _NewsDescriptionState createState() => _NewsDescriptionState();
}

class _NewsDescriptionState extends State<NewsDescription> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  static const double _kLabelSpacing = 20.0;
  final HomeBloc _homeBloc = new HomeBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Globals.callSnackbar = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _launchURL(obj) async {
    if (!obj.toString().contains('http')) {
      await Utility.launchUrlOnExternalBrowser(obj);
      return;
    }
    // Checking here for zoom/google_meet/docs/forms app URLs to open these specific URLs Externally(In browser/Related App if installed already)
    if (obj.toString().contains("zoom.us") ||
        obj.toString().contains("meet.google.com") ||
        obj.toString().contains("docs.google.com") ||
        obj.toString().contains("forms.gle")) {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else if (obj.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: widget.obj.title.toString(),
                    url: obj,
                    isBottomSheet: true,
                    language: Globals.selectedLanguage,
                  )));
    }
  }

  Widget _buildNewsDescription() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 30.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              // height: MediaQuery.of(context).size.width * 0.5,
              child: ClipRRect(
                  child: CommonImageWidget(
                iconUrl: widget.obj.image ??
                    Globals.splashImageUrl ??
                    Globals.appSetting.appLogoC,
                height: Utility.displayHeight(context) *
                    (AppTheme.kDetailPageImageHeightFactor / 100),
                fitMethod: BoxFit.contain,
                isOnTap: true,
              )),
            ),
            SpacerWidget(_kLabelSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: TranslationWidget(
                  message: widget.obj.title != "" &&
                          widget.obj.title != null &&
                          widget.obj.title.length > 0
                      ? Utility.utf8convert(widget.obj.title ?? '')
                      : widget.obj.title.toString().split(" ").length > 1
                          ? Utility.utf8convert(widget.obj.description
                                  .toString()
                                  .replaceAll("\n", " ")
                                  .split(" ")[0] +
                              " " +
                              widget.obj.description
                                  .toString()
                                  .replaceAll("\n", " ")
                                  .split(" ")[1]
                                  .split("\n")[0] +
                              "...")
                          : Utility.utf8convert(widget.obj.description ?? ''),
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => SelectableLinkify(
                    toolbarOptions: Platform.isAndroid
                        ? ToolbarOptions(copy: true, selectAll: true)
                        : ToolbarOptions(copy: true),
                    selectionControls: materialTextSelectionControls,
                    onOpen: (link) => _launchURL(link.url),
                    options: LinkifyOptions(humanize: false),
                    linkStyle: TextStyle(color: Colors.blue),
                    text: translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )),
              ],
            ),
            //
            Text(
              Utility.convertTimestampToDateFormat(
                  widget.obj.completedAt, "MM/dd/yy"),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
            ),

            SpacerWidget(AppTheme.kBodyPadding / 2),

            Container(
              child: Wrap(
                children: [
                  TranslationWidget(
                    message: Utility.utf8convert(widget.obj.description ?? ''),
                    toLanguage: Globals.selectedLanguage,
                    fromLanguage: "en",
                    builder: (translatedMessage) => SelectableLinkify(
                      toolbarOptions: Platform.isAndroid
                          ? ToolbarOptions(copy: true, selectAll: true)
                          : ToolbarOptions(copy: true),
                      selectionControls: materialTextSelectionControls,
                      onOpen: (link) => _launchURL(link.url),
                      enableInteractiveSelection: true,
                      options: LinkifyOptions(humanize: false),
                      linkStyle: TextStyle(color: Colors.blue),
                      text: translatedMessage.toString(),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: widget.obj.link != null
                  ? Wrap(
                      children: [
                        TranslationWidget(
                          message: widget.obj.link.toString(),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => SelectableLinkify(
                            toolbarOptions: Platform.isAndroid
                                ? ToolbarOptions(copy: true, selectAll: true)
                                : ToolbarOptions(copy: true),
                            onOpen: (link) => _launchURL(link.url),
                            linkStyle: TextStyle(color: Colors.blue),
                            options: LinkifyOptions(humanize: false),
                            text: translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
        BlocListener<HomeBloc, HomeState>(
          bloc: _homeBloc,
          listener: (context, state) async {
            if (state is BottomNavigationBarSuccess) {
              AppTheme.setDynamicTheme(Globals.appSetting, context);

              Globals.appSetting = AppSetting.fromJson(state.obj);
            }
          },
          child: Container(),
        ),
        SpacerWidget(AppTheme.kBodyPadding),
        Container(
          alignment: Alignment.centerLeft,
          child: ActionInteractionButtonWidget(
            page: "news",
            obj: widget.obj,
            title: widget.obj.description,
            description: widget.obj.description,
            imageUrl: widget.obj.link,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
          child: RefreshIndicator(
            key: refreshKey,
            // child: VisibilityDetector(
            //     key: Key('news-feed-post'),
            //     onVisibilityChanged: (visibilityInfo) {
            //       ActionInteractionButtonWidget(
            //           isViewInteraction: true,
            //           title: widget.obj.title,
            //           description: widget.obj.description,
            //           imageUrl: widget.obj.image,
            //           obj: widget.obj,
            //           page: "news",
            //           isLoading: false);
            //     },
            child: _buildNewsDescription(),
            //  ),
            onRefresh: refreshPage,
          ),
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    _homeBloc.add(FetchStandardNavigationBar());
  }
}
