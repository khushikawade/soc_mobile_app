import 'package:Soc/src/modules/graded_plus/new_ui/help.dart';
import 'package:Soc/src/modules/graded_plus/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class GradedPlusHelp extends StatefulWidget {
  GradedPlusHelp({
    Key? key,
  }) : super(key: key);

  @override
  State<GradedPlusHelp> createState() => _GradedPlusHelpState();
}

class _GradedPlusHelpState extends State<GradedPlusHelp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> introList = ['Constructed Response', 'Multiple Choice'];
  final ValueNotifier<String> selectedIntroType = ValueNotifier<String>('');

  String aboutInfo =
      "GRADED+ is a smart student work scanner for teachers. The camera app auto finds your hand-written teacher’s score (circled) and students’ unique Google Classroom email when you snap a photo.";

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
        body: body(),
      )
    ]);
  }

  PreferredSizeWidget? appBar() {
    return CustomOcrAppBarWidget(
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

  Widget body() {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: StudentPlusOverrides.kSymmetricPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 4),
          PlusScreenTitleWidget(
              kLabelSpacing: StudentPlusOverrides.kLabelSpacing,
              text: 'Graded+ Help'),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 2),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kLabelSpacing / 2),
            child: Utility.textWidget(
                textAlign: TextAlign.left,
                text: aboutInfo,
                context: context,
                textTheme: Theme.of(context).textTheme.headline2),
          ),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 1.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Utility.textWidget(
                  textAlign: TextAlign.left,
                  text: 'Select GRADED+ Tutorial Type',
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline5),
            ],
          ),
          SpacerWidget(StudentPlusOverrides.KVerticalSpace / 1.8),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    introList.length,
                    (index) => Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: selectedIntroType,
                            child: Container(),
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return buttonDesign(
                                  index: index,
                                  isSelected: selectedIntroType.value ==
                                      introList[index]);
                            })),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget buttonDesign({required int index, required isSelected}) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bouncing(
            onPress: () async {
              selectedIntroType.value = introList[index];
              await Future.delayed(Duration(milliseconds: 300));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomIntroWidget(
                    SectionName: selectedIntroType.value,
                    isFromHelp: true,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: Duration(microseconds: 100),
              child: CircleAvatar(
                backgroundColor: isSelected
                    ? AppTheme.kSelectedColor
                    : Color(0xff000000) != Theme.of(context).backgroundColor
                        ? Colors.grey.shade200
                        : Colors.grey.shade800,
                radius: MediaQuery.of(context).size.height * 0.07,
                child: CircleAvatar(
                  backgroundColor:
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xffF7F8F9)
                          : Color(0xff111C20),
                  radius: MediaQuery.of(context).size.height * 0.06,
                  child: Icon(
                      IconData(index == 1 ? 0xe833 : 0xe87c,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      size: index == 0 ? 35 : 42,
                      color: isSelected
                          ? AppTheme.kSelectedColor
                          : AppTheme.kButtonColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FittedBox(
              child: Utility.textWidget(
                  text: introList[index],
                  context: context,
                  textAlign: TextAlign.left,
                  textTheme: Theme.of(context).textTheme.headline2!.copyWith(
                      color: isSelected ? AppTheme.kSelectedColor : null)),
            ),
          ),
        ],
      ),
    );
  }
}
