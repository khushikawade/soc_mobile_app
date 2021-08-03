import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';

class LicenceDetailPage extends StatefulWidget {
  String? language;
  int index;
  LicenceDetailPage(
      {Key? key, this.title, required this.language, required this.index})
      : super(key: key);
  final String? title;
  @override
  _LicenceDetailPageState createState() => _LicenceDetailPageState();
}

class _LicenceDetailPageState extends State<LicenceDetailPage> {
<<<<<<< HEAD
=======
  // static const double _kIconSize = 188;
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
            child: Text(
              list["description"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
=======
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message: list["description"].toString(),
                    fromLanguage: "en",
                    toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message: list["name"].toString(),
                    fromLanguage: "en",
                    toLanguage: widget.language,
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

<<<<<<< HEAD
=======
  // Widget _buildHomeHeading() {
  //   return Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: _kLabelSpacing,
  //       ),
  //       child: widget.language != null && widget.language != "English"
  //           ? TranslationWidget(
  //               message: "Homepage:",
  //               fromLanguage: "en",
  //               toLanguage: widget.language,
  //               builder: (translatedMessage) => Text(
  //                 translatedMessage,
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .headline3!
  //                     .copyWith(color: Colors.black),
  //                 textAlign: TextAlign.start,
  //               ),
  //             )
  //           : Text(
  //               "Homepage:",
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .headline3!
  //                   .copyWith(color: Colors.black),
  //               textAlign: TextAlign.start,
  //             ));
  // }

>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
              child: Text(
                list["homepage"].toString(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    decoration: TextDecoration.underline,
                    color: AppTheme.kAccentColor),
                textAlign: TextAlign.start,
              ),
=======
              child: widget.language != null && widget.language != "English"
                  ? TranslationWidget(
                      message: list["homepage"].toString(),
                      fromLanguage: "en",
                      toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
          Text(
            "Version : ",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black),
            textAlign: TextAlign.start,
          ),
          // HorzitalSpacerWidget(_kLabelSpacing / 5),
          Expanded(
            child: Text(
              list["version"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
=======
          widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: "Version:",
                  fromLanguage: "en",
                  toLanguage: widget.language,
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
                  textAlign: TextAlign.start,
                ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message: list["version"].toString(),
                    fromLanguage: "en",
                    toLanguage: widget.language,
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
                    list["version"].toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
      child: Text(
        "Authors : ",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.black),
        textAlign: TextAlign.start,
      ),
=======
      child: widget.language != null && widget.language != "English"
          ? TranslationWidget(
              message: "Authors:",
              fromLanguage: "en",
              toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
            child: Text(
              "${list["authors"].toString().replaceAll('[', '').replaceAll(']', '')}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.left,
            ),
=======
            child: widget.language != null && widget.language != "English"
                ? TranslationWidget(
                    message:
                        "${list["authors"].toString().replaceAll('[', '').replaceAll(']', '')}",
                    fromLanguage: "en",
                    toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
<<<<<<< HEAD
        child: Text(
          "License : ",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
          textAlign: TextAlign.start,
        ));
=======
        child: widget.language != null && widget.language != "English"
            ? TranslationWidget(
                message: "License:",
                fromLanguage: "en",
                toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
  }

  Widget _buildlicenseInfo(list) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kLabelSpacing,
          ),
<<<<<<< HEAD
          child: Text(
            "${list["license"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("\n", "").replaceAll("\n\n ", "").replaceAll("*", "").replaceAll("     ", "").toLowerCase()}",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black, height: 1.5),
            textAlign: TextAlign.start,
          ),
=======
          child: widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message:
                      "${list["license"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("\n", "").replaceAll("\n\n ", "").replaceAll("*", "").replaceAll("     ", "")}",
                  fromLanguage: "en",
                  toLanguage: widget.language,
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
>>>>>>> 511c938905ed01a480779bd63732a65e90f23ef7
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
        language: widget.language,
      ),
      body: Container(
          color: AppTheme.kListBackgroundColor2,
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
    );
  }
}
