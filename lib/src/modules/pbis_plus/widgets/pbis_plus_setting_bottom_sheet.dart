import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../styles/theme.dart';

// ignore: must_be_immutable
class PBISPlusSettingBottomSheet extends StatefulWidget {
  final List<ClassroomCourse> googleClassroomCourseworkList;
  final double? height;
  final double? constraintDeviceHeight;
  PBISPlusSettingBottomSheet({
    Key? key,
    required this.googleClassroomCourseworkList,
    required this.constraintDeviceHeight,
    this.height = 200,
  }) : super(key: key);

  @override
  State<PBISPlusSettingBottomSheet> createState() =>
      _PBISPlusSettingBottomSheetState();
}

class _PBISPlusSettingBottomSheetState
    extends State<PBISPlusSettingBottomSheet> {
  late PageController _pageController;
  final ValueNotifier<bool> selectionChange = ValueNotifier<bool>(false);

  List<ClassroomCourse> selectedCoursesList = [];
  List<ClassroomStudents> selectedStudentList = [];
  int pageValue = 0;
  bool? isResetStudent = false;

  @override
  void initState() {
    {
      _pageController = PageController()
        ..addListener(() {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.5,
      controller: ModalScrollController.of(context),
      child: Container(
          height: pageValue == 0
              ? widget.height!
              : pageValue == 1
                  ? widget.height! * 1.15
                  : pageValue == 2
                      ? widget.height! * 1.2
                      : widget.height,
          decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            borderRadius: BorderRadius.circular(15),
          ),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: ((value) {
              pageValue = value;
            }),
            allowImplicitScrolling: false,
            pageSnapping: false,
            controller: _pageController,
            children: [
              settingWidget(
                  context), //-----------------setting widget design------------//
              buildGoogleClassroomCourseWidget(
                  context), //----------select ClassroomCourse view-----------------//
              buildSelectStudentBottomsheetWidget(
                  context), //----------------------select student view---------------//
              commonLoaderWidget()
            ],
          )),
    );
  }

//-------------------------------Setting widget design------------------------------------------//
  Widget settingWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //---------------------Cross Icon button-----------------//
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          icon: Icon(
            Icons.clear,
            size: Globals.deviceType == "phone" ? 28 : 36,
            color: AppTheme.kButtonColor,
          ),
        ),
        //------------------------first row-------------------------//
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Utility.textWidget(
                      context: context,
                      text: "Re-sync rosters",
                      textTheme:
                          Theme.of(context).textTheme.headline5!.copyWith(
                                color: Color(0xff000000) ==
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffFFFFFF)
                                    : Color(0xff000000),
                                fontSize: Globals.deviceType == "phone"
                                    ? AppTheme.kBottomSheetTitleSize
                                    : AppTheme.kBottomSheetTitleSize * 1.3,
                              )),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width / 5,
                      height: 35,
                      decoration: BoxDecoration(
                          color: AppTheme.kButtonColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sync,
                            size: Globals.deviceType == "phone" ? 16 : 28,
                            color: AppTheme.kBlackColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FittedBox(
                            child: Utility.textWidget(
                                text: 'Sync',
                                context: context,
                                textAlign: TextAlign.center,
                                textTheme: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Color(0xff000000),
                                      // fontSize: Globals.deviceType == "phone"
                                      //     ? AppTheme.kBottomSheetTitleSize
                                      //     : AppTheme.kBottomSheetTitleSize * 1.3,
                                    )),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        //------------------------remaining row-------------------------//

        textWidget('Save & Reset Points', AppTheme.kButtonColor, null),
        textWidget('All Classes & Students', Color(0xff111C20), 0),
        divider(context),
        textWidget('Select Students', Color(0xff111C20), 1),
        divider(context),
        textWidget('Select Classes', Color(0xff111C20), 2),
        textWidget('Edit Skills', AppTheme.kButtonColor, null),
        textWidget('Coming Spetember 2023', Color(0xff111C20), null),
      ],
    );
  }

  //--------------divider for design-----------------------//
  Widget divider(BuildContext context) {
    return Container(
      height: 0.5,
      decoration: BoxDecoration(color: Color(0xffD7D7D7)),
    );
  }

//-----------------text  widget for setting  design ------------//
  Widget textWidget(String? text, Color backgroundColor, int? index) {
    return InkWell(
        onTap: () {
          // setState(() {
          //-----------------------------if user select the student or classes navigate to select course bottom sheet-------------------------------------//

          if (index == 1 || index == 2) {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease);
          }
          if (index == 1) {
            isResetStudent = true;
          } else {
            isResetStudent = false;
          }
          // });
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor == AppTheme.kButtonColor
                  ? backgroundColor
                  : Color(0xff000000) != Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20),
            ),
            child: Utility.textWidget(
                text: text!,
                context: context,
                textTheme: Theme.of(context).textTheme.headline5!.copyWith(
                      color:
                          Color(0xff000000) == Theme.of(context).backgroundColor
                              ? backgroundColor == AppTheme.kButtonColor
                                  ? Color(0xff000000)
                                  : Color(0xffFFFFFF)
                              : Color(0xff000000),
                      fontSize: Globals.deviceType == "phone"
                          ? AppTheme.kBottomSheetTitleSize
                          : AppTheme.kBottomSheetTitleSize * 1.3,
                    ))));
  }

//------------------------Page 1 for course List-------------------------//
  Widget buildGoogleClassroomCourseWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).requestFocus(FocusNode());
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36,
              ),
            )),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Utility.textWidget(
              context: context,
              text: 'Select Course',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            onPressed: () {
              //--------------------------For back to previous screen---------------------//
              _pageController.animateToPage(pageValue - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
            },
            icon: Icon(
              IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kButtonColor,
            ),
          ),
        ),
        // SpacerWidget(20),
        ValueListenableBuilder(
            valueListenable: selectionChange,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
                height: widget.height! * 0.65,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: 25,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.googleClassroomCourseworkList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _classroomCourseRadioList(
                        index, context, widget.googleClassroomCourseworkList);
                  },
                ),
              );
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {
                if (isResetStudent == true) {
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                } else {
                  _pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                }
              },
              label: Utility.textWidget(
                  text: isResetStudent! ? 'Next' : 'Submit',
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Theme.of(context).backgroundColor))),
        ),
      ],
    );
  }

//------------------Radio view for course List ----------------------------//
  Widget _classroomCourseRadioList(
      int index, context, List<ClassroomCourse> courseList) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          //In case of ALL no other course can be selected individually
          selectedCoursesList.clear();
          // selectedCoursesList.addAll(courseList);
        } else if (!selectedCoursesList.contains(courseList[index])) {
          // selectedCoursesList.add(ClassroomCourse(name: 'All'));
          selectedCoursesList.add(courseList[index]);
        } else {
          selectedCoursesList.remove(courseList[index]);
        }
        //Refresh value in the UI
        selectionChange.value = !selectionChange.value;
      },
      child: Container(
          height: 54,
          padding: EdgeInsets.symmetric(
            horizontal: 0,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? Theme.of(context).colorScheme.background ==
                          Color(0xff000000)
                      ? AppTheme.klistTilePrimaryDark
                      : AppTheme
                          .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.background ==
                          Color(0xff000000)
                      ? AppTheme.klistTileSecoandryDark
                      : AppTheme
                          .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
              ),
          child: IgnorePointer(
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: AppTheme.kButtonColor,
              ),
              child: RadioListTile(
                  groupValue: selectedCoursesList.contains(courseList[index])
                      ? true
                      : false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppTheme
                      .kButtonColor, //Theme.of(context).colorScheme.primaryVariant,
                  contentPadding: EdgeInsets.zero,
                  value: selectedCoursesList.length == 0
                      ? index == 0
                          ? false
                          : true
                      : true,
                  onChanged: (dynamic val) {},
                  title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Utility.textWidget(
                          text: courseList[index].name!,
                          context: context,
                          textTheme: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold)))),
            ),
          )),
    );
  }

//----------------Student list------------------------------------//
  Widget buildSelectStudentBottomsheetWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).requestFocus(FocusNode());
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36,
              ),
            )),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Utility.textWidget(
              context: context,
              text: 'Select Students',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            onPressed: () {
              _pageController.animateToPage(pageValue - 1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
            },
            icon: Icon(
              IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kButtonColor,
            ),
          ),
        ),
        SpacerWidget(20),
        ValueListenableBuilder(
            valueListenable: selectionChange,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container(
                height: widget.height! * 0.65,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: 25,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: selectedCoursesList.length == 0
                      ? widget.googleClassroomCourseworkList.length
                      : selectedCoursesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return renderClassWiseStudentList(
                      index,
                      context,
                      selectedCoursesList.length == 0
                          ? widget.googleClassroomCourseworkList
                          : selectedCoursesList,
                    );
                  },
                ),
              );
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {},
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utility.textWidget(
                      text: 'Submit',
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Theme.of(context).backgroundColor)),
                ],
              )),
        ),
      ],
    );
  }

//--------------------------------return selected class name on select student screen---------------//
  Widget renderClassWiseStudentList(
      int index, context, List<ClassroomCourse> courseList) {
    if (courseList.length > 0 && courseList[0].students == null) {
      courseList.removeAt(0);
    }
    return Container(
      key: ValueKey(courseList[index]),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
        child: Column(
          children: [
            Text(
              courseList[index]
                  .name!, // -----------------class name-----------------//
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: AppTheme.kButtonColor),
            ),
            selectedCoursesList.length != 0
                ? renderStudents(selectedCoursesList[index]
                    .students!) // only particular class of student showing
                : renderStudents(
                    courseList[index].students!) // for all the student showing
          ],
        ),
      ),
    );
  }

//---------------------return the student list-----------------//
  renderStudents(List<ClassroomStudents> studentList) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: studentList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (!selectedStudentList.contains(studentList[index])) {
              selectedStudentList.add(studentList[index]);
            } else {
              selectedStudentList.remove(studentList[index]);
            }
            //Refresh value in the UI
            selectionChange.value = !selectionChange.value;
            selectedStudentList.length;
          },
          child: Container(
              height: 54,
              padding: EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? AppTheme.klistTilePrimaryDark
                          : AppTheme
                              .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? AppTheme.klistTileSecoandryDark
                          : AppTheme
                              .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
                  ),
              child: IgnorePointer(
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: AppTheme.kButtonColor,
                  ),
                  child: RadioListTile(
                      groupValue: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: AppTheme
                          .kButtonColor, //Theme.of(context).colorScheme.primaryVariant,

                      contentPadding: EdgeInsets.zero,
                      value: selectedStudentList.contains(studentList[index]),
                      onChanged: (dynamic val) {},
                      title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Utility.textWidget(
                              text: studentList[index].profile!.name!.fullName!,
                              context: context,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.bold)))),
                ),
              )),
        );
      },
    );
  }

//-------------------------view of student name and radio button -------------//

//page value=3
  Widget commonLoaderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacerWidget(50),
        CircularProgressIndicator.adaptive(
          backgroundColor: AppTheme.kButtonColor,
        ),
        SpacerWidget(30),
        Utility.textWidget(
            context: context,
            textAlign: TextAlign.center,
            text:
                'Resetting Selected ${isResetStudent! ? 'Students' : 'Courses'} and Preparing Google Spreadsheet',
            textTheme:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 18)),
      ],
    );
  }
}
