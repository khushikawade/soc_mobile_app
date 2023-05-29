import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:flutter/material.dart';

class PBISPlusStaff extends StatefulWidget {
  final IconData titleIconData;
  PBISPlusStaff({Key? key, required this.titleIconData}) : super(key: key);

  @override
  State<PBISPlusStaff> createState() => _PBISPlusStaffState();
}

class _PBISPlusStaffState extends State<PBISPlusStaff> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//Used to avoid the blink effect on navigating back to Staff screen //Standard App
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonBackgroundImgWidget(),
      Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: PBISPlusUtility.pbisAppBar(
          context: context,
          titleIconData: widget.titleIconData,
          title: 'Class',
          scaffoldKey: _scaffoldKey,
        ),
      )
    ]);
  }
}
