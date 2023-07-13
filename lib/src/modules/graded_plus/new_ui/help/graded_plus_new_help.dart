import 'package:Soc/src/modules/graded_plus/modal/custom_intro_content_modal.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_intro_tutorial_section.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:flutter/material.dart';

class GradedPlusHelpSection extends StatefulWidget {
  GradedPlusHelpSection({
    Key? key,
  }) : super(key: key);

  @override
  State<GradedPlusHelpSection> createState() => _GradedPlusHelpSectionState();
}

class _GradedPlusHelpSectionState extends State<GradedPlusHelpSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ValueNotifier<String> selectedIntroType = ValueNotifier<String>('');

  // String aboutInfo =
  //     "GRADED+ is a smart student work scanner for teachers. The camera app auto finds your hand-written teacher’s score (circled) and students’ unique Google Classroom email when you snap a photo.";

//Used to avoid the blink effect on navigating back to Staff screen //Standard App
  @override
  Widget build(BuildContext context) {
    return CommonIntroSection(
        onBoardingInfoList:
            GradedIntroContentModal.onBoardingMainPagesInfoList);

    // Stack(children: [
    //   CommonBackgroundImgWidget(),
    //   Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     key: _scaffoldKey,
    //     extendBody: true,
    //     backgroundColor: Colors.transparent,
    //     appBar: appBar(),
    //     body: CommonIntroSection(
    //         onBoardingInfoList:
    //             GradedIntroContentModal.onBoardingMainPagesInfoList),
    //   )
    // ]);
  }

  // PreferredSizeWidget? appBar() {
  //   return CustomOcrAppBarWidget(
  //     plusAppName: 'GRADED+',
  //     fromGradedPlus: true,
  //     //Show home button in standard app and hide in standalone
  //     assessmentDetailPage: Overrides.STANDALONE_GRADED_APP ? true : null,
  //     isOcrHome: true,
  //     isSuccessState: ValueNotifier<bool>(true),
  //     isBackOnSuccess: ValueNotifier<bool>(false),
  //     key: GlobalKey(),
  //     isBackButton: Overrides.STANDALONE_GRADED_APP ? true : false,
  //   );
  // }
}
