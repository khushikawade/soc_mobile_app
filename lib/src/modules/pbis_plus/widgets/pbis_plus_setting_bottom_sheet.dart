import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../styles/theme.dart';

// ignore: must_be_immutable
class PBISPlusSettingBottomSheet extends StatefulWidget {
  final List<ClassroomCourse> googleClassroomCourseworkList;
  final double? height;
  final double? constraintDeviceHeight;
  final GlobalKey<ScaffoldState> scaffoldKey;
  PBISPlusSettingBottomSheet(
      {Key? key,
      required this.googleClassroomCourseworkList,
      required this.constraintDeviceHeight,
      this.height = 200,
      required this.scaffoldKey})
      : super(key: key);

  @override
  State<PBISPlusSettingBottomSheet> createState() =>
      _PBISPlusSettingBottomSheetState();
}

class _PBISPlusSettingBottomSheetState
    extends State<PBISPlusSettingBottomSheet> {
  late PageController _pageController;
  final ValueNotifier<bool> selectionChange = ValueNotifier<bool>(false);

  List<ClassroomCourse> selectedRecords = []; //Add selected student and courses
  List<ClassroomStudents> selectedStudentList = [];
  int pageValue = 0;
  String sectionName = '';
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
  PBISPlusBloc pbisBloc = PBISPlusBloc();

  get heightMap => {
        0: widget.height!,
        1: widget.height! * 1.15,
        2: widget.height! * 1.2,
        3: widget.height! / 2,
      };

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
          height: heightMap.containsKey(pageValue)
              ? heightMap[pageValue]
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

        textWidget('Save & Reset Points', AppTheme.kButtonColor),
        textWidget('All Classes & Students', Color(0xff111C20)),
        divider(context),
        textWidget('Select Students', Color(0xff111C20)),
        divider(context),
        textWidget('Select Classes', Color(0xff111C20)),
        textWidget('Edit Skills', AppTheme.kButtonColor),
        textWidget('Coming Spetember 2023', Color(0xff111C20)),
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
  Widget textWidget(
    String? text,
    Color backgroundColor,
  ) {
    return InkWell(
        onTap: () {
          // This code handles different text values to perform different actions.
          //sectionName-To identify the selected section from the save and reset menu
          sectionName = '';
          selectedRecords.clear();
          selectedStudentList.clear();

          switch (text) {
            case 'All Classes & Students':
              sectionName = 'All Classes & Students';
              _pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;
            case 'Select Students':
              sectionName = 'Students';

              _pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);

              break;
            case 'Select Classes':
              sectionName = 'Classes';
              _pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;
            default:
              // Code to handle an unknown text value.
              break;
          }
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
                textTheme: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: backgroundColor == AppTheme.kButtonColor
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Color(0xff000000) !=
                                Theme.of(context).backgroundColor ||
                            backgroundColor == AppTheme.kButtonColor
                        ? Color(0xff000000)
                        : Color(0xffFFFFFF)))));
  }

//------------------------Page 1 for course List-------------------------//
  Widget buildGoogleClassroomCourseWidget(context) {
    return SingleChildScrollView(
        child: Column(
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
                // commaSeparatedStringForCourse();

                _pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
              },
              label: Utility.textWidget(
                  text: 'Submit',
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Theme.of(context).backgroundColor))),
        ),
      ],
    ));
  }

//------------------Radio view for course List ----------------------------//
  Widget _classroomCourseRadioList(
      int index, context, List<ClassroomCourse> courseList) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          //In case of ALL no other course can be selected individually
          selectedRecords.clear();
          // selectedCoursesList.addAll(courseList);
        } else if (!selectedRecords.contains(courseList[index])) {
          // selectedCoursesList.add(ClassroomCourse(name: 'All'));
          selectedRecords.add(courseList[index]);
        } else {
          selectedRecords.remove(courseList[index]);
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
                  groupValue: selectedRecords.contains(courseList[index])
                      ? true
                      : false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppTheme
                      .kButtonColor, //Theme.of(context).colorScheme.primaryVariant,
                  contentPadding: EdgeInsets.zero,
                  value: selectedRecords.length == 0
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
    if (widget.googleClassroomCourseworkList.length > 0 &&
        widget.googleClassroomCourseworkList[0].name == "All") {
      widget.googleClassroomCourseworkList.removeAt(0);
    }
    return SingleChildScrollView(
      child: Column(
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
                _pageController.animateToPage(pageValue - 2,
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
                    itemCount: widget.googleClassroomCourseworkList.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return renderClassWiseStudentList(
                        index,
                        context,
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
                onPressed: () async {
                  if (selectedStudentList.length > 0) {
                    selectedRecords = await filterCourses(selectedStudentList);

                    _pageController.animateToPage(3,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease);
                  } else {
                    Utility.currentScreenSnackBar(
                        "Please select at least one student.", null);
                  }
                },
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Utility.textWidget(
                        text: 'Submit',
                        context: context,
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(
                                color: Theme.of(context).backgroundColor)),
                  ],
                )),
          ),
        ],
      ),
    );
  }

//--------------------------------return selected class name on select student screen---------------//
  Widget renderClassWiseStudentList(
    int index,
    context,
  ) {
    return Container(
      key: ValueKey(widget.googleClassroomCourseworkList[index]),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
        child: Column(
          children: [
            Text(
              widget.googleClassroomCourseworkList[index]
                  .name!, // -----------------class name-----------------//
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: AppTheme.kButtonColor),
            ),

            widget.googleClassroomCourseworkList[index].students != null &&
                    widget.googleClassroomCourseworkList[index].students!
                            .length >
                        0
                ? renderStudents(
                    widget.googleClassroomCourseworkList[index].students!,
                    widget.googleClassroomCourseworkList[index].id ?? '')
                : Text('No Student Found') // for all the student showing
          ],
        ),
      ),
    );
  }

//---------------------return the student list-----------------//
  renderStudents(List<ClassroomStudents> studentList, String courseId) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: studentList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (!selectedStudentList.contains(studentList[index])) {
              ClassroomStudents studentObj = studentList[index];
              studentObj.profile!.courseId = courseId;
              selectedStudentList.add(studentObj);
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
            text: 'Exporting to Spreadsheet and resetting \'$sectionName\'',
            textTheme:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 18)),
        if (pageValue == 3) googleDriveBlocListener()
      ],
    );
  }

  Container googleDriveBlocListener() {
    if (PBISPlusOverrides.pbisPlusGoogleDriveFolderId.isNotEmpty == true) {
      //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY
      _exportDataToSpreadSheet();
    } else {
      //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
      _checkDriveFolderExistsOrNot();
    }
    return Container(
      height: 0,
      width: 0,
      child: Column(
        children: [
          BlocListener<GoogleDriveBloc, GoogleDriveState>(
            bloc: googleDriveBloc,
            child: EmptyContainer(),
            listener: (context, state) async {
              if (state is GoogleSuccess) {
                //In case of Folder Id received
                _exportDataToSpreadSheet();
              }
              if (state is ExcelSheetCreated) {
                googleDriveBloc.add(PBISPlusUpdateDataOnSpreadSheetTabs(
                    spreadSheetFileObj: state.googleSpreadSheetFileObj,
                    classroomCourseworkList:
                        (sectionName == 'All Classes & Students' ||
                                (selectedRecords?.isEmpty ?? true))
                            ? widget.googleClassroomCourseworkList
                            : selectedRecords));
              }
              if (state is PBISPlusUpdateDataOnSpreadSheetSuccess) {
                resetData();
                // Navigator.pop(context);
                // Utility.currentScreenSnackBar(
                //     "Google SpreadSheet Created Successfully.", null);
              }
              if (state is ErrorState) {
                if (state.errorMsg == 'ReAuthentication is required') {
                  await Utility.refreshAuthenticationToken(
                      isNavigator: true,
                      errorMsg: state.errorMsg!,
                      context: context,
                      scaffoldKey: widget.scaffoldKey);

                  // Navigator.of(context).pop();
                  Utility.currentScreenSnackBar('Please try again', null);
                } else {
                  Navigator.of(context).pop();
                  Utility.currentScreenSnackBar(
                      state.errorMsg == 'NO_CONNECTION'
                          ? 'No Internet Connection'
                          : "Something Went Wrong. Please Try Again.",
                      null);
                }
              }
            },
          ),
          BlocListener<PBISPlusBloc, PBISPlusState>(
            bloc: pbisBloc,
            child: EmptyContainer(),
            listener: (context, state) async {
              if (state is PBISErrorState) {
                Navigator.of(context).pop();
                Utility.currentScreenSnackBar(
                    state.error == 'NO_CONNECTION'
                        ? 'No Internet Connection'
                        : "Something Went Wrong. Please Try Again.",
                    null);
              }
              if (state is PBISPlusResetSuccess) {
                Navigator.pop(context, sectionName);
                Utility.currentScreenSnackBar(
                    "\'$sectionName\' have been reset successfully.", null);
              }
            },
          ),
        ],
      ),
    );
  }

  //check drive folder exists or not if not exists create one
  void _checkDriveFolderExistsOrNot() async {
    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: true,
        token: userProfile.authorizationToken,
        folderName: "SOLVED PBIS+",
        refreshToken: userProfile.refreshToken));
  }

  void _exportDataToSpreadSheet() {
    //CREATE SPREADSHEET ON DRIVE
    googleDriveBloc.add(CreateExcelSheetToDrive(
        name:
            "PBIS_${Globals.appSetting.contactNameC}_${Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy")}",
        folderId: PBISPlusOverrides.pbisPlusGoogleDriveFolderId));
  }

//----------------------call method for reset data----------------//
  resetData() async {
    pbisBloc.add(PBISPlusResetInteractions(
      type: sectionName,
      selectedRecords: (sectionName == 'All Classes & Students' ||
              (selectedRecords?.isEmpty ?? true))
          ? widget.googleClassroomCourseworkList
          : selectedRecords,
    ));
  }

  List<ClassroomCourse> filterCourses(List<ClassroomStudents> students) {
    try {
      List<ClassroomCourse> filteredCourses = [];

      for (ClassroomCourse course in widget.googleClassroomCourseworkList) {
        List<ClassroomStudents>? filteredStudents = course.students
            ?.where((student) => students?.contains(student) ?? false)
            .toList();

        if (filteredStudents?.isNotEmpty ?? false) {
          filteredCourses.add(ClassroomCourse(
            id: course.id,
            name: course.name,
            descriptionHeading: course.descriptionHeading,
            ownerId: course.ownerId,
            enrollmentCode: course.enrollmentCode,
            courseState: course.courseState,
            students: filteredStudents,
          ));
        }
      }

      return filteredCourses;
    } catch (e) {
      return [];
    }
  }
}
