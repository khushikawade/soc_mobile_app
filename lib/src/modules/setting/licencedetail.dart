import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
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
  static const double _kIconSize = 188;
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
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Description:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: Text(
              list["description"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Color(0xff171717)),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildname(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Name:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing * 1.6),
          Expanded(
            child: Text(
              list["name"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildhomepage(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Homepage:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: InkWell(
              onTap: () {
                urlobj.callurlLaucher(context, "${list["homepage"]}");
              },
              child: Text(
                list["homepage"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(decoration: TextDecoration.underline),
                textAlign: TextAlign.justify,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVersion(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Version:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing * 1.5),
          Expanded(
            child: Text(
              list["version"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildauthors(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Authors:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: Text(
              list["authors"].toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildlicenseInfo(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "License:",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Color(0xff171717)),
            textAlign: TextAlign.start,
          ),
          HorzitalSpacerWidget(_kLabelSpacing / 2),
          Expanded(
            child: Text(
              "${list["license"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("\n", "").replaceAll("\n\n ", "")..replaceAll("        ", "")}",
              textAlign: TextAlign.justify,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
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
      body: SafeArea(
          child: list != null && list.length > 0
              ? ListView(children: [
                  _buildname(list[index]),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  _buildVersion(list[index]),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  description(list[index]),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  _buildhomepage(list[index]),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  _buildauthors(list[index]),
                  HorzitalSpacerWidget(_kLabelSpacing),
                  _buildlicenseInfo(list[index]),
                ])
              : Container(
                  height: 0,
                )),
    );
  }
}
