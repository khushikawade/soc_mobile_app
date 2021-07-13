import 'package:app/src/modules/families/modal/eventmodal.dart';
import 'package:app/src/modules/families/modal/formModal.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customList.dart';
import 'package:app/src/widgets/hori_spacerwidget.dart';
import 'package:app/src/widgets/searchfield.dart';
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
  // final TextStyle headingtextStyle = TextStyle(
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
    return SearchFieldWidget();
  }

  Widget _buildList(int index, Widget listItem) {
    return ListWidget(index, _buildFormName(index));
  }

  Widget _buildFormName(int index) {
    return Row(
      children: [
        Text(
          FormModalList[index].formName,
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
                  return _buildList(index, _buildFormName(index));
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
