import 'dart:ui';
import 'package:Soc/src/modules/families/Submodule/staff/modal/staffmodel.dart';
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
  static const double _kLabelSpacing = 18.0;
  var _controller = TextEditingController();

  // final TextStyle _kheadingStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 28,
  //   color: AppTheme.kFontColor2,
  // );

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
              // focusNode: myFocusNode,
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

  // Widget card()
  // {
  //   return  Card(
  //         elevation: 50,
  //         shadowColor: Colors.black,
  //         color: Colors.greenAccent[100],
  //         child: SizedBox(
  //           width: 300,
  //           height: 500,
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Column(
  //               children: [
  //                 CircleAvatar(
  //                   backgroundColor: Colors.green[500],
  //                   radius: 108,
  //                   child: CircleAvatar(
  //                     backgroundImage: NetworkImage(
  //                         "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"), //NetworkImage
  //                     radius: 100,
  //                   ), //CircleAvatar
  //                 )]));//CirclAvatar
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
        title: widget.obj.toString(),
        isnewsSearchPage: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeading("STAFF DIRECTORY"),
              _buildSearchbar(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
