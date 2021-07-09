import 'package:app/src/modules/families/modal/eventmodal.dart';
import 'package:app/src/modules/families/modal/formModal.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/hori_spacerwidget.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/src/overrides.dart' as overrides;

class FormPage extends StatefulWidget {
  FormPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  static const double _kLabelSpacing = 17.0;
  static const _kFontFam = 'SOC_CustomIcons';
  static const _kFontPkg = null;
  FocusNode myFocusNode = new FocusNode();
  final TextStyle headingtextStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Medium",
    fontSize: 16,
    color: AppTheme.kFontColor2,
  );

  final TextStyle formtextStyle = TextStyle(
    fontFamily: "Roboto Regular",
    fontSize: 14,
    color: AppTheme.kAccentColor,
  );

  static const List<FormModal> FormModalList = const <FormModal>[
    const FormModal(
      formName: 'Complete Blue Card Emergency Contact',
    ),
    const FormModal(
      formName: 'Complete Media Relese Form',
    ),
    const FormModal(
      formName: 'Health Screening',
    ),
    const FormModal(
      formName: 'Consent Form for COVID-19 Testing',
    ),
    const FormModal(
      formName: 'Afterschool Consent Form',
    ),
    const FormModal(
      formName: 'Password Request Form',
    ),
    const FormModal(
      formName: 'ipad & chromebook Tech Support',
    ),
    const FormModal(
      formName: 'Field Trip From',
    ),
  ];

  Widget _buildSearchfield() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _kLabelSpacing / 2, horizontal: _kLabelSpacing),
      color: AppTheme.kFieldbackgroundColor,
      child: TextFormField(
        focusNode: myFocusNode,
        decoration: InputDecoration(
            labelText: 'Search',
            filled: true,
            fillColor: AppTheme.kBackgroundColor,
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              IconData(0xe805,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kprefixIconColor,
            )),
      ),
    );
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
                _buildFormName(index),
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
            child: Text(tittle, style: headingtextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildFormName(int index) {
    return Row(
      children: [
        Text(
          FormModalList[index].formName,
          style: formtextStyle,
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
