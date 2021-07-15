import 'package:Soc/src/modules/families/modal/familymodal.dart';
import 'package:Soc/src/modules/families/ui/familyscren2.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

import '../../../overrides.dart';

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  static const double _kLabelSpacing = 16.0;

  // STYLE
  // static const _kTextStyle = TextStyle(
  //     fontFamily: "Roboto Regular",
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //     color: Color(0xff2D3F98));

  static const List<FamilyModel> familyModelList = const <FamilyModel>[
    const FamilyModel(
      title: 'About us',
      icon: IconData(0xe80b,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 0,
    ),
    const FamilyModel(
        title: 'My Student Login',
        icon: IconData(0xe802,
            fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
        index: 1),
    const FamilyModel(
      title: 'Calendar/Events',
      icon: IconData(0xe810,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 2,
    ),
    const FamilyModel(
      title: 'Forms',
      icon: IconData(0xe814,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 3,
    ),
    const FamilyModel(
      title: 'Staff Directory',
      icon: IconData(0xe809,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 4,
    ),
    const FamilyModel(
      title: 'Health Screening',
      icon: IconData(0xe817,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 5,
    ),
    const FamilyModel(
      title: 'Complete Blue Card Emergency Contact',
      icon: IconData(0xe811,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 6,
    ),
    const FamilyModel(
      title: 'School Merchandise',
      icon: IconData(0xe804,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 7,
    ),
    const FamilyModel(
      title: 'Gradebook - Pupilpath',
      icon: IconData(0xe816,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 8,
    ),
    const FamilyModel(
      title: 'Resources & Updates',
      icon: IconData(0xe803,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 9,
    ),
    const FamilyModel(
      title: 'School Merchandise',
      icon: IconData(0xe804,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 10,
    ),
    const FamilyModel(
      title: 'Contact',
      icon: IconData(0xe812,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 11,
    ),
    const FamilyModel(
      title: 'Nyc DOE Resources',
      icon: IconData(0xe802,
          fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
      index: 12,
    ),
  ];

  Widget _buildList(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffe1e4e7),
          width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).backgroundColor
            : AppTheme.kListBackgroundColor2,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FamilyPage2(index: index)));
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        contentPadding:
            EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: Icon(
          familyModelList[index].icon,
          color: AppTheme.kListIconColor3,
        ),
        title: Text(
          "${familyModelList[index].title}",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Color(0xff89A7D7),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: familyModelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
