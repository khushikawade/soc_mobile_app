import 'dart:ui';
import 'package:Soc/src/modules/families/Submodule/staff/modal/staffmodel.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';

class StaffListPage extends StatefulWidget {
  StaffListPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  static const double _kLabelSpacing = 18.0;

  final TextStyle _kheadingStyle = TextStyle(
    height: 1.5,
    fontFamily: "Roboto Medium",
    fontSize: 28,
    color: AppTheme.kFontColor2,
  );

  // final TextStyle nametextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 14.0,
  //   fontWeight: FontWeight.w500,
  //   color: AppTheme.kAccentColor,
  // );

  // final TextStyle emailtextStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Regular",
  //   fontSize: 16,
  //   color: AppTheme.kAccentColor,
  // );

  static const List<StaffModel> StaffModelList = const <StaffModel>[
    const StaffModel(
        name: "Alleyne Marguerite", email: "AlleyneMarguerite4@school.nyc.gov"),
    const StaffModel(
        name: "Allong Peter", email: "PAllongpeter@school.nyc.gov"),
    const StaffModel(
        name: "Alston Prine", email: "PAlstonprine@school.nyc.gov"),
    const StaffModel(
        name: "Bailey Richard", email: "RBaileyrichard@school.nyc.gov"),
    const StaffModel(
        name: "Brathwaite Edwin", email: "EBrathwaiteedwin@school.nyc.gov"),
    const StaffModel(
        name: "Bailey Richard", email: "RBaileyrichard@school.nyc.gov"),
    const StaffModel(
        name: "Brathwaite Edwin", email: "EBrathwaiteedwin@school.nyc.gov"),
  ];

  Widget _buildList(int index) {
    return Container(
        decoration: BoxDecoration(
          border: (index % 2 == 0)
              ? Border.all(color: AppTheme.kListBackgroundColor3)
              : Border.all(color: Theme.of(context).backgroundColor),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? AppTheme.kListBackgroundColor3
              : Theme.of(context).backgroundColor,
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildname(index),
                HorzitalSpacerWidget(_kLabelSpacing),
                _buildemail(index),
              ],
            ),
          ),
        ));
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _kLabelSpacing * 1.2),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0,
        ),
        color: AppTheme.kOnPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(tittle, style: _kheadingStyle),
        ],
      ),
    );
  }

  Widget _buildname(int index) {
    return Row(
      children: [
        Text(
          StaffModelList[index].name,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildemail(int index) {
    return Row(
      children: [
        Text(
          StaffModelList[index].email,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.normal,
              ),
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
              _buildHeading("STAFF DIRECTORY"),

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
