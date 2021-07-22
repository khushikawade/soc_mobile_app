import 'dart:ui';
import 'package:Soc/src/modules/families/Submodule/staff_directory/modal/staffmodel.dart';
import 'package:Soc/src/modules/families/Submodule/staff_directory/ui/directorydetail.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../overrides.dart';

class StaffDirectory extends StatefulWidget {
  var obj;
  StaffDirectory({Key? key, required this.obj}) : super(key: key);

  @override
  _StaffDirectoryState createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  static const double _kLabelSpacing = 16.0;
  var _controller = TextEditingController();

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
          Text(
            tittle,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: AppTheme.kFontColor2,
                ),
          ),
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
    return InkWell(
      onTap: () => _sendMail(index),
      child: Row(
        children: [
          Text(
            StaffModelList[index].email,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }

  _sendMail(int index) async {
    // Android and iOS
    final uri =
        'mailto:"${StaffModelList[index].email}"?subject=Greetings&body=Hello%20World';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget _buildSearchbar() {
    return SizedBox(
        height: 50,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
            color: AppTheme.kFieldbackgroundColor,
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Search School App',
                contentPadding: EdgeInsets.symmetric(
                  vertical: _kLabelSpacing / 2,
                ),
                filled: true,
                fillColor: AppTheme.kBackgroundColor,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  color: AppTheme.kprefixIconColor,
                ),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.kIconColor,
                    size: 18,
                  ),
                ),
              ),
            )));
  }

  Widget contactItem() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DirectoryDetailPage()));
      },
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
          padding: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 1.5),
          decoration: BoxDecoration(
            color: AppTheme.ListColor2,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  child: Image.asset(
                'assets/images/address.png',
                fit: BoxFit.fill,
                height: 60,
                width: 60,
              )),
              HorzitalSpacerWidget(_kLabelSpacing),
              Expanded(
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            "Name",
                          ),
                          Text(
                            "xyz",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Email",
                          ),
                          Expanded(
                            child: Text(
                              "@gmaiil.com",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "phone",
                          ),
                          Text(
                            "12354",
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
        title: "Staff directory", //  widget.obj.toString(),
        isnewsSearchPage: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeading("STAFF DIRECTORY"),
              contactItem(),
            ],
          ),
        ),
      ),
    );
  }
}
