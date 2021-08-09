import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';

class LicenceDetailPage extends StatefulWidget {
  int index;
  LicenceDetailPage({Key? key, this.title, required this.index})
      : super(key: key);
  final String? title;
  @override
  _LicenceDetailPageState createState() => _LicenceDetailPageState();
}

class _LicenceDetailPageState extends State<LicenceDetailPage> {
  // static const double _kIconSize = 188;
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  OSSLicensesInfo obj = new OSSLicensesInfo();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  int? index;
  var list;
  @override
  void initState() {
    super.initState();
    list = obj.ossLicenses.values.toList();
    index = int.parse(widget.index.toString());
  }

  // UI Widget

  Widget description(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        children: [
          Expanded(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: list["description"].toString(),
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                      translatedMessage,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                  )
                : Text(
                    list["description"].toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildname(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: list["name"].toString(),
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                      translatedMessage,
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                  )
                : Text(
                    list["name"].toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildhomepage(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                urlobj.callurlLaucher(context, "${list["homepage"]}");
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English"
                  ? TranslationWidget(
                      message: list["homepage"].toString(),
                      fromLanguage: "en",
                      toLanguage: Globals.selectedLanguage,
                      builder: (translatedMessage) => Text(
                        translatedMessage,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            color: AppTheme.kAccentColor),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Text(
                      list["homepage"].toString(),
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppTheme.kAccentColor),
                      textAlign: TextAlign.start,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersion(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: "Version:",
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Text(
                    translatedMessage,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                )
              : Text(
                  "Version:",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black),
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message: list["version"].toString(),
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                      translatedMessage,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black),
                    ),
                  )
                : Text(
                    list["version"].toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildauthorsHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Globals.selectedLanguage != null &&
              Globals.selectedLanguage != "English"
          ? TranslationWidget(
              message: "Authors:",
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) => Text(
                translatedMessage,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
                textAlign: TextAlign.start,
              ),
            )
          : Text(
              "Authors:",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
    );
  }

  Widget _buildauthors(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Globals.selectedLanguage != null &&
                    Globals.selectedLanguage != "English"
                ? TranslationWidget(
                    message:
                        "${list["authors"].toString().replaceAll('[', '').replaceAll(']', '')}",
                    fromLanguage: "en",
                    toLanguage: Globals.selectedLanguage,
                    builder: (translatedMessage) => Text(
                      translatedMessage,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  )
                : Text(
                    "${list["authors"].toString().replaceAll('[', '').replaceAll(']', '')}",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildlicenseInfoHeading() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing,
        ),
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: "License:",
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              )
            : Text(
                "License:",
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
                textAlign: TextAlign.start,
              ));
  }

  Widget _buildlicenseInfo(list) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kLabelSpacing,
          ),
          child: Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message:
                      "${list["license"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("\n", "").replaceAll("\n\n ", "\n").replaceAll("*", "").replaceAll("     ", "").toLowerCase()}",
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Text(
                    translatedMessage,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black, height: 1.5),
                    textAlign: TextAlign.start,
                  ),
                )
              : Text(
                  "${list["license"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("\n", "").replaceAll("\n\n ", "").replaceAll("*", "").replaceAll("     ", "")}",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black, height: 1.5),
                  textAlign: TextAlign.start,
                ),
        )),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        appBarTitle: "Licence Detail",
        sharedpopUpheaderText: '',
        sharedpopBodytext: '',
        language: Globals.selectedLanguage,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Container(
            color: Theme.of(context).colorScheme.background,
            child: list != null && list.length > 0
                ? ListView(children: [
                    SpacerWidget(_kLabelSpacing / 2),
                    _buildname(list[index]),
                    SpacerWidget(_kLabelSpacing / 2),
                    _buildVersion(list[index]),
                    SpacerWidget(_kLabelSpacing / 2),
                    _buildlicenseInfoHeading(),
                    _buildlicenseInfo(list[index]),
                    SpacerWidget(_kLabelSpacing / 5),
                    _buildhomepage(list[index]),
                    SpacerWidget(_kLabelSpacing / 2),
                    _buildauthorsHeading(),
                    _buildauthors(list[index]),
                    SpacerWidget(_kLabelSpacing / 2),
                  ])
                : Container(
                    height: 0,
                  )),
      ),
    );
  }
}
