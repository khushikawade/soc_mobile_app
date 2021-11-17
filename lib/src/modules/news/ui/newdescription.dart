import 'dart:io';

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/news/ui/news_image.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:share/share.dart';

class Newdescription extends StatefulWidget {
  Newdescription(
      {Key? key,
      required this.obj,
      required this.date,
      required this.isbuttomsheet,
      required this.language})
      : super(key: key);

  final String date;
  final bool isbuttomsheet;
  final String? language;
  final obj;

  _NewdescriptionState createState() => _NewdescriptionState();
}

class _NewdescriptionState extends State<Newdescription> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  static const double _kIconSize = 45.0;
  static const double _kLabelSpacing = 20.0;
  final HomeBloc _homeBloc = new HomeBloc();
  bool _downloadingFile = false;
  static const double _KButtonSize = 110.0;

  @override
  void initState() {
    super.initState();
    Globals.callsnackbar = true;
  }

  void _launchURL(obj) async {
    if (!obj.toString().contains('http')) {
      await Utility.launchUrlOnExternalBrowser(obj);
      return;
    }
    if (obj.toString().contains(
            "zoom.us") || // Checking here for zoom/google meet app URLs to open these specific URLs Externally(In browser/Related App if installed already)
        obj.toString().contains("meet.google.com")) {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else if (obj.toString().split(":")[0] == 'http') {
      await Utility.launchUrlOnExternalBrowser(obj);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: widget.obj.headings["en"].toString(),
                    url: obj,
                    isbuttomsheet: true,
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
                child: widget.obj.image != null && widget.obj.image != ""
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  NewsImagePage(imageURL: widget.obj.image));
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.obj.image,
                          fit: BoxFit.cover,
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => NewsImagePage(
                                    imageURL: Globals.splashImageUrl != null &&
                                            Globals.splashImageUrl != ""
                                        ? Globals.splashImageUrl
                                        : Globals.homeObjet["App_Logo__c"]));
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: Globals.splashImageUrl != null &&
                                    Globals.splashImageUrl != ""
                                ? Globals.splashImageUrl
                                : Globals.homeObjet["App_Logo__c"],
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
              ),
            ),
            SpacerWidget(_kLabelSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English" &&
                          Globals.selectedLanguage != ""
                      ? TranslationWidget(
                          message: widget.obj.headings != "" &&
                                  widget.obj.headings != null &&
                                  widget.obj.headings.length > 0
                              ? widget.obj.headings["en"].toString()
                              : widget.obj.contents["en"]
                                          .toString()
                                          .split(" ")
                                          .length >
                                      1
                                  ? widget.obj.contents["en"]
                                          .toString()
                                          .replaceAll("\n", " ")
                                          .split(" ")[0] +
                                      " " +
                                      widget.obj.contents["en"]
                                          .toString()
                                          .replaceAll("\n", " ")
                                          .split(" ")[1]
                                          .split("\n")[0] +
                                      "..."
                                  : widget.obj.contents["en"],
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Linkify(
                            onOpen: (link) => _launchURL(link.url),
                            options: LinkifyOptions(humanize: false),
                            text: translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        )
                      : Linkify(
                          onOpen: (link) => _launchURL(link.url),
                          options: LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(color: Colors.blue),
                          text: widget.obj.headings != "" &&
                                  widget.obj.headings != null &&
                                  widget.obj.headings.length > 0
                              ? widget.obj.headings["en"].toString()
                              : widget.obj.contents["en"]
                                          .toString()
                                          .split(" ")
                                          .length >
                                      1
                                  ? widget.obj.contents["en"]
                                          .toString()
                                          .replaceAll("\n", " ")
                                          .split(" ")[0] +
                                      " " +
                                      widget.obj.contents["en"]
                                          .toString()
                                          .replaceAll("\n", " ")
                                          .split(" ")[1]
                                          .split("\n")[0] +
                                      "..."
                                  : widget.obj.contents["en"],
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                ),
              ],
            ),
            Container(
              child: Wrap(
                children: [
                  Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English" &&
                          Globals.selectedLanguage != ""
                      ? TranslationWidget(
                          message: widget.obj.contents["en"].toString(),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Linkify(
                            onOpen: (link) => _launchURL(link.url),
                            options: LinkifyOptions(humanize: false),
                            linkStyle: TextStyle(color: Colors.blue),
                            text: translatedMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText1!,
                            textAlign: TextAlign.left,
                          ),
                        )
                      : Linkify(
                          onOpen: (link) => _launchURL(link.url),
                          options: LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(color: Colors.blue),
                          text: widget.obj.contents["en"].toString(),
                          style: Theme.of(context).textTheme.bodyText1!,
                          textAlign: TextAlign.left,
                        ),
                ],
              ),
            ),
            GestureDetector(
              child: widget.obj.url != null
                  ? Wrap(
                      children: [
                        Globals.selectedLanguage != null &&
                                Globals.selectedLanguage != "English" &&
                                Globals.selectedLanguage != ""
                            ? TranslationWidget(
                                message: widget.obj.url.toString(),
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Linkify(
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
                              )
                            : Linkify(
                                onOpen: (link) => _launchURL(link.url),
                                linkStyle: TextStyle(color: Colors.blue),
                                text: widget.obj.url.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                textAlign: TextAlign.justify,
                              ),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
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
        SpacerWidget(AppTheme.kBodyPadding),
        Row(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: _KButtonSize,
                maxWidth: 130.0,
              ),
              child: ElevatedButton(
                  onPressed: () async {
                    _shareNews();
                  },
                  child: _downloadingFile == true
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).backgroundColor),
                          ),
                        )
                      : TranslationWidget(
                          message: "Share".toString(),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                          ),
                        )),
            ),
          ],
        )
      ],
    );
  }

  _shareNews() async {
    try {
      if (_downloadingFile == true) return;
      setState(() {
        _downloadingFile = true;
      });
      String _title = widget.obj.headings["en"] ?? "";
      String _description = widget.obj.contents["en"] ?? "";
      String _imageUrl = widget.obj.image != null
          ? widget.obj.image
          : Globals.splashImageUrl != null && Globals.splashImageUrl != ""
              ? Globals.splashImageUrl
              : Globals.homeObjet["App_Logo__c"];
      File _image = await Utility.createFileFromUrl(_imageUrl);
      setState(() {
        _downloadingFile = false;
      });
      Share.shareFiles(
        [_image.path],
        subject: '$_title',
        text: '$_description',
      );
    } catch (e) {
      setState(() {
        _downloadingFile = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kLabelSpacing / 1.5),
      child: RefreshIndicator(
        key: refreshKey,
        child: _buildNewsDescription(),
        onRefresh: refreshPage,
      ),
    ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
