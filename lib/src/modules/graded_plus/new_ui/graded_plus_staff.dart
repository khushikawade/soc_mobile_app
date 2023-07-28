import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class GradedPlusStaff extends StatefulWidget {
  final IconData titleIconData;
  GradedPlusStaff({Key? key, required this.titleIconData}) : super(key: key);

  @override
  State<GradedPlusStaff> createState() => _GradedPlusStaffState();
}

class _GradedPlusStaffState extends State<GradedPlusStaff> {
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
        appBar: appBar(),
      )
    ]);
  }

  PreferredSizeWidget? appBar() {
    return CustomOcrAppBarWidget(
      refresh: (v) {
        setState(() {});
      },
      iconData: null,
      plusAppName: 'GRADED+',
      fromGradedPlus: true,
      //Show home button in standard app and hide in standalone
      assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
      isOcrHome: true,
      isSuccessState: ValueNotifier<bool>(true),
      isBackOnSuccess: ValueNotifier<bool>(false),
      key: GlobalKey(),
      isBackButton: Overrides.STANDALONE_GRADED_APP ? true : false,
    );
  }
}
