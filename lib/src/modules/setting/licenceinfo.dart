import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Licenceinfo extends StatefulWidget {
  Licenceinfo({Key? key, this.title, this.language}) : super(key: key);
  final String? title;
  String? language;
  @override
  _LicenceinfoState createState() => _LicenceinfoState();
}

class _LicenceinfoState extends State<Licenceinfo> {
  static const double _kIconSize = 188;
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  OSSLicensesInfo obj = new OSSLicensesInfo();
  // UI Widget
  var _list;
  @override
  void initState() {
    super.initState();

    _list = obj.ossLicenses.values.toList();
    print(_list[1]["name"]);
  }

  Widget _buildList(
    list,
    int index,
  ) {
    return InkWell(
      onTap: () {},
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
                    horizontal: _kLabelSpacing * 1,
                    vertical: _kLabelSpacing / 2),
                child: ListTile(
                  leading: Text(
                    list[index]["name"]!,
                    // style: Theme.of(context).textTheme.headline5,
                  ),
                  // title: Text(
                  //   list[index]["name"]!,
                  //   style: Theme.of(context).textTheme.headline5,
                  // ),
                  // subtitle: Text(
                  //   Utility.convertDateFormat(list.startDate!) +
                  //       " - " +
                  //       Utility.convertDateFormat(list.endDate!),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline2!
                  //       .copyWith(fontWeight: FontWeight.normal, height: 1.5),
                  // ),
                )),
          )),
    );
  }

  Widget _buildHeading() {
    return InkWell(
      onTap: () {},
      child: Text(
        "Open Source Licence",
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        appBarTitle: "Open Source Licence",
        sharedpopUpheaderText: '',
        sharedpopBodytext: '',
        language: widget.language,
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
                    : Container();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
