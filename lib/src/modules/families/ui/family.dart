import 'package:app/src/modules/families/modal/familymodal.dart';
import 'package:app/src/modules/families/ui/aboutus.dart';
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
    // const FamilyModel(title: 'My Student Login', icon: 0xe802),
    // const FamilyModel(title: 'Calendar', icon: 0xe80f),
    // const FamilyModel(title: 'Forms', icon: 0xe813),
    // const FamilyModel(title: 'Staff Directory', icon: 0xe809),
    // const FamilyModel(title: 'Health Screening', icon: 0xe800),
    // const FamilyModel(
    //     title: 'Complete Blue Card Emergency Contact', icon: 0xe810),
    // const FamilyModel(title: 'School Merchandise', icon: 0xe804),
    // const FamilyModel(title: 'Gradebook - Pupilpath', icon: 0xe815),
    // const FamilyModel(title: 'Resources & Updates', icon: 0xe803),
    // const FamilyModel(title: 'School Merchandise', icon: 0xe804),
    // const FamilyModel(title: 'Contact', icon: 0xe811),
    // const FamilyModel(title: 'Nyc DOE Resources', icon: 0xe802),
  ];

  Widget _buildList(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffe1e4e7)),
        borderRadius: BorderRadius.circular(0.50),
        color: Color(0xffF5F5F5),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutusPage()));
        },
        contentPadding: EdgeInsets.only(left: _kLabelSpacing),
        leading: Icon(familyModelList[index].icon),
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
