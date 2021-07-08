import 'package:app/src/modules/families/modal/familymodal.dart';
import 'package:app/src/modules/families/ui/aboutus.dart';
import 'package:app/src/styles/theme.dart';
import 'package:flutter/material.dart';

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  static const _kFontFam = 'SOC_CustomIcons';
  static const _kFontPkg = null;
  static const double _kLabelSpacing = 16.0;

  // STYLE
  static const _kTextStyle = TextStyle(
      fontFamily: "Roboto Regular",
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Color(0xff2D3F98));

  static const List<FamilyModel> familyModelList = const <FamilyModel>[
    const FamilyModel(
      title: 'About us',
      icon: IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'My Student Login',
      icon: IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Calendar/Events',
      icon: IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Forms',
      icon: IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Staff Directory',
      icon: IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Health Screening',
      icon: IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Complete Blue Card Emergency Contact',
      icon: IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'School Merchandise',
      icon: IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Gradebook - Pupilpath',
      icon: IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Resources & Updates',
      icon: IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'School Merchandise',
      icon: IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Contact',
      icon: IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
    const FamilyModel(
      title: 'Nyc DOE Resources',
      icon: IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg),
    ),
  ];

  Widget _buildList(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffe1e4e7)),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).backgroundColor
            : AppTheme.kListBackgroundColor2,
      ),
      child: ListTile(
        dense: true,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutusPage()));
        },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        contentPadding: EdgeInsets.only(left: _kLabelSpacing),
        leading: Icon(
          familyModelList[index].icon,
          color: AppTheme.kListIconColor3,
        ),
        title: Text(
          "${familyModelList[index].title}",
          style: _kTextStyle,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 20,
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
