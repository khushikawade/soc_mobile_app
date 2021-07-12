import 'package:app/src/styles/theme.dart';
import 'package:app/src/modules/families/modal/resourcemodal.dart';
import 'package:app/src/widgets/hori_spacerwidget.dart';
import 'package:app/src/widgets/searchfield.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/src/overrides.dart' as overrides;

class Resources extends StatefulWidget {
  Resources({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  static const double _kLabelSpacing = 17.0;
  static const _kFontFam = 'SOC_CustomIcons';
  static const _kFontPkg = null;
  FocusNode myFocusNode = new FocusNode();
  // final TextStyle _kheadingStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 16,
  //   color: AppTheme.kFontColor2,
  // );

  final TextStyle formtextStyle = TextStyle(
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: AppTheme.kAccentColor,
  );

  static const List<ResourcesModal> ResourcesList = const <ResourcesModal>[
    const ResourcesModal(
      resource: '5/24 Family Letter',
    ),
    const ResourcesModal(
      resource: 'Family Letter March 10 2021',
    ),
    const ResourcesModal(
      resource: 'SupportingFamilies During COVID-19',
    ),
    const ResourcesModal(
      resource: 'Complete Blue Card Emergency Contact',
    ),
    const ResourcesModal(
      resource: 'Complete Blue Card Emergency Contact',
    ),
  ];

  Widget _buildSearchfield() {
    return SearchFieldWidget();
  }

  Widget _buildList(int index) {
    return Container(
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
                horizontal: _kLabelSpacing * 2, vertical: _kLabelSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildresource(index),
              ],
            ),
          ),
        ));
  }

  Widget _buildHeading(String tittle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: _kLabelSpacing / 1.5, bottom: _kLabelSpacing / 1.5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
            ),
            color: AppTheme.kOnPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: _kLabelSpacing),
            child: Text(
              tittle,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildresource(int index) {
    return Row(
      children: [
        Text(
          ResourcesList[index].resource,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchfield(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
