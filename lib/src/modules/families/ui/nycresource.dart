import 'package:app/src/modules/families/modal/eventmodal.dart';
import 'package:app/src/modules/families/modal/NYCUpdateModal.dart';
import 'package:app/src/overrides.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customList.dart';
import 'package:app/src/widgets/hori_spacerwidget.dart';
import 'package:app/src/widgets/searchfield.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/src/overrides.dart' as overrides;

class NycResource extends StatefulWidget {
  NycResource({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _NycResourceState createState() => _NycResourceState();
}

class _NycResourceState extends State<NycResource> {
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

  static const List<NYCUpdateModal> NYCUpdateModalList = const <NYCUpdateModal>[
    const NYCUpdateModal(
      updateditem: 'Nyc Doe Calender',
    ),
    const NYCUpdateModal(
      updateditem: 'NYC DOE Twittet',
    ),
    const NYCUpdateModal(
      updateditem: 'NYC DOE Messages to Families',
    ),
    const NYCUpdateModal(
      updateditem: 'Technical Support for Families',
    ),
    const NYCUpdateModal(
      updateditem: 'Transportation',
    ),
    const NYCUpdateModal(
      updateditem: 'Parents ‘Bill of Right',
    ),
    const NYCUpdateModal(
      updateditem: 'Child Welfare',
    ),
    const NYCUpdateModal(
      updateditem: 'FACE ( Family and community Empowerment )',
    ),
  ];

  Widget _buildSearchfield() {
    return SearchFieldWidget();
  }

  Widget _buildList(int index) {
    return ListWidget(index, _buildupdateditem(index));
  }

  Widget _buildupdateditem(int index) {
    return Row(
      children: [
        Text(
          NYCUpdateModalList[index].updateditem,
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
