import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/setting/licencedetail.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Licenceinfo extends StatefulWidget {
  Licenceinfo({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _LicenceinfoState createState() => _LicenceinfoState();
}

class _LicenceinfoState extends State<Licenceinfo> {
  // static const double _kIconSize = 188;
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  OSSLicensesInfo obj = new OSSLicensesInfo();
  // UI Widget
  var _list;
  @override
  void initState() {
    super.initState();
    _list = obj.ossLicenses.values.toList();
  }

  Widget _buildList(
    list,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LicenceDetailPage(
                      index: index,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          border: (index % 2 == 0)
              ? Border.all(color: AppTheme.kListBackgroundColor2)
              : Border.all(color: Theme.of(context).backgroundColor),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? AppTheme.kListBackgroundColor2
              : Theme.of(context).backgroundColor,
        ),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing * 1, vertical: _kLabelSpacing),
          child: Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: list[index]["name"] ?? '-',
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
                  list[index]["name"] ?? '-',
                  // style: Theme.of(context).textTheme.headline5,
                ),
        )),
      ),
    );
  }

  // Widget _buildHeading() {
  //   return InkWell(
  //     onTap: () {},
  //     child: Text(
  //       "Open Source Licence",
  //       style: Theme.of(context).textTheme.headline2,
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        appBarTitle: "Open Source Licence",
        sharedpopUpheaderText: '',
        sharedpopBodytext: '',
        language: Globals.selectedLanguage,
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return _list.length > 0
                    ? _buildList(
                        _list,
                        index,
                      )
                    : Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "No data found",
                                    toLanguage: Globals.selectedLanguage,
                                    fromLanguage: "en",
                                    builder: (translatedMessage) => Text(
                                      translatedMessage.toString(),
                                    ),
                                  )
                                : Text("No data found")));
              },
            ),
          ),
        ]),
      ),
    );
  }
}
