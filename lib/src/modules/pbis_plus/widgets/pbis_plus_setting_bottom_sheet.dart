import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/widgets/spinning_icon.dart';
import 'package:Soc/src/modules/pbis_plus/bloc/pbis_plus_bloc.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_edit_skills.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../styles/theme.dart';

// ignore: must_be_immutable
class PBISPlusSettingBottomSheet extends StatefulWidget {
  final List<ClassroomCourse> googleClassroomCourseworkList;
  final double? height;
  final double? constraintDeviceHeight;
  final PBISPlusBloc? pbisBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  // Function? editBehaviourFunction;

  PBISPlusSettingBottomSheet(
      {Key? key,
      required this.googleClassroomCourseworkList,
      required this.constraintDeviceHeight,
      this.pbisBloc,
      this.height = 200,
      // required this.editBehaviourFunction,
      required this.scaffoldKey})
      : super(key: key);

  @override
  State<PBISPlusSettingBottomSheet> createState() =>
      _PBISPlusSettingBottomSheetState();
}

class _PBISPlusSettingBottomSheetState extends State<PBISPlusSettingBottomSheet>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  AnimationController? _animationControllerForSync;
  Animation? animation;
  Animation? rotateAnimation;

  final ValueNotifier<bool> selectionChange = ValueNotifier<bool>(false);

  PBISPlusBloc pbisBloc = new PBISPlusBloc();
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();

  List<ClassroomCourse> selectedRecords = []; //Add selected student and courses
  List<ClassroomStudents> selectedStudentList = [];
  List<ClassroomStudents> allStudents = [];

  int pageValue = 0;
  String sectionName = '';
  get heightMap => {
        0: widget.height! * 1.1,
        1: widget.height! * 1.2,
        2: widget.height! * 1.2,
        // 3: widget.height! / 1.5,
        // 4: widget.height! / 2
        3: widget.height! * 1.2,
        4: widget.height! / 1.5,
        5: widget.height! / 2
      };

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  void dispose() {
    _animationControllerForSync!.dispose();
    super.dispose();
  }

  initMethod() async {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });

    _animationControllerForSync = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        animationBehavior: AnimationBehavior.normal);

    // Combine all the students from different courses into a single list.
    allStudents = await getClassroomStudents(
        classroomCoursesList: widget.googleClassroomCourseworkList);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
              padding: MediaQuery.of(context).viewInsets / 1.5,
              controller: ModalScrollController.of(context),
              child: Container(
                  height: heightMap.containsKey(pageValue)
                      ? heightMap[pageValue]
                      : widget.height,
                  decoration: BoxDecoration(
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
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
                      settingWidget(context),
                      //-----------------setting widget design------------//
                      buildGoogleClassroomCourseWidget(context),
                      //----------select ClassroomCourse view-----------------//
                      buildSelectStudentBottomsheetWidget(context),
                      //----------------------select student view---------------//
                      buildSelectStudentByCourseBottomsheetWidget(context),
                      warningWidget(),
                      commonLoaderWidget(),
                    ],
                  )),
            )),
        blocListener()
      ],
    );
  }

//-------------------------------Setting widget design------------------------------------------//
  Widget settingWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //---------------------Cross Icon button-----------------//
        Padding(
          padding: Globals.deviceType == "phone"
              ? const EdgeInsets.only(top: 8.0, right: 8)
              : const EdgeInsets.only(top: 16.0, right: 16),
          child: IconButton(
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
        ),
        //------------------------first row-------------------------//
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Utility.textWidget(
                      context: context,
                      text: "Re-sync rosters",
                      textTheme:
                          Theme.of(context).textTheme.headline3!.copyWith(
                                color: Color(0xff000000) ==
                                        Theme.of(context).backgroundColor
                                    ? Color(0xffFFFFFF)
                                    : Color(0xff000000),
                              )),
                ),
                BlocListener<PBISPlusBloc, PBISPlusState>(
                    bloc: widget.pbisBloc,
                    listener: (context, state) async {
                      if (state is PBISPlusImportRosterSuccess) {
                        Future.delayed(Duration(seconds: 5), () {
                          Navigator.pop(context, 'Sync');
                          if (_animationControllerForSync!.isAnimating ==
                              true) {
                            Utility.currentScreenSnackBar(
                                'Courses synced successfully', null,
                                marginFromBottom: 90);
                            _animationControllerForSync!.stop();
                          }
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.036,
                      child: FloatingActionButton.extended(
                          backgroundColor: AppTheme.kButtonColor,
                          onPressed: () async {
                            if (_animationControllerForSync!.isAnimating ==
                                true) {
                              Utility.currentScreenSnackBar(
                                  'Please wait, sync is in progress', null,
                                  marginFromBottom: 90);
                            } else {
                              _animationControllerForSync!.repeat();
                              widget.pbisBloc!.add(
                                  PBISPlusImportRoster(isGradedPlus: false));
                            }
                          },
                          label: Utility.textWidget(
                              text: 'Sync',
                              context: context,
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color:
                                          Theme.of(context).backgroundColor)),
                          icon: SpinningIconButton(
                            controller: _animationControllerForSync,
                            iconData: Icons.sync,
                          )),
                    ))
              ],
            ),
          ),
        ),
        //------------------------remaining row-------------------------//

        textWidget('Save & Reset Points', AppTheme.kButtonColor),
        textWidget(PBISPlusOverrides.kresetOptionOnetitle, Color(0xff111C20)),
        divider(context),
        textWidget(PBISPlusOverrides.kresetOptionTwotitle, Color(0xff111C20)),
        divider(context),
        textWidget(PBISPlusOverrides.kresetOptionThreetitle, Color(0xff111C20)),
        divider(context),
        textWidget(PBISPlusOverrides.kresetOptionFourtitle, Color(0xff111C20)),
        textWidget('Edit Behaviour', AppTheme.kButtonColor),
        textWidget('Edit Behaviour', Color(0xff111C20)),
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
          sectionName = text ?? '';
          selectedRecords.clear();
          selectedStudentList.clear();
          print(text);
          switch (text) {
            case PBISPlusOverrides.kresetOptionOnetitle:
              PlusUtility.updateLogs(
                  activityType: 'PBIS+',
                  userType: 'Teacher',
                  activityId: '58',
                  description:
                      'PBIS+ Save & Reset Points: All Courses & Students',
                  operationResult: 'Success');
              //-------------------------------------------------------------

              _pageController.animateToPage(4,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;
            case PBISPlusOverrides.kresetOptionTwotitle:
              PlusUtility.updateLogs(
                  activityType: 'PBIS+',
                  userType: 'Teacher',
                  activityId: '60',
                  description: 'Save & Reset Points: Select Students',
                  operationResult: 'Success');
              //-------------------------------------------------------------

              _pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);

              break;
            case PBISPlusOverrides.kresetOptionThreetitle:
              PlusUtility.updateLogs(
                  activityType: 'PBIS+',
                  userType: 'Teacher',
                  activityId: '59',
                  description: 'PBIS+ Save & Reset Points: Select Courses',
                  operationResult: 'Success');
              //-------------------------------------------------------------

              _pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;

            case PBISPlusOverrides.kresetOptionFourtitle:
              _pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease);
              break;

            case 'Edit Behaviour':
              sectionName = 'Behaviour';
              Navigator.pop(context);
              pushNewScreen(
                context,
                screen: PBISPlusEditSkills(),
                withNavBar: true,
              );

              // _pageController.animateToPage(1,
              //     duration: const Duration(milliseconds: 100),
              //     curve: Curves.ease);
              // widget.editSkills;
              // pushNewScreen(
              //   context,
              //   screen: PBISPlusEditSkills(),
              //   withNavBar: true,
              // );
              // Navigator.pop(context);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => Center(
              //       child: PBISPlusEditSkills(constraint: 450),
              //     ),
              //   ),
              // );

              break;
            case PBISPlusOverrides.kresetOptionFourtitle:
              _pageController.animateToPage(3,
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
                    color: text.contains('2023')
                        ? AppTheme.kSecondaryColor
                        : Color(0xff000000) !=
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
            child: Padding(
              padding: Globals.deviceType == "phone"
                  ? const EdgeInsets.only(top: 8.0, right: 8)
                  : const EdgeInsets.only(top: 16.0, right: 16),
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
              ),
            )),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Utility.textWidget(
              context: context,
              text: 'Select Courses',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            onPressed: () {
              //--------------------------For back to previous screen---------------------//
              _pageController.animateToPage(0,
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
                padding: EdgeInsets.all(5),
                height: widget.height! * 0.65,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      // top:25,
                      // bottom: 25,
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
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {
                // commaSeparatedStringForCourse();

                _pageController.animateToPage(5,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
                _exportDataToSpreadSheet();
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
                          textTheme: Theme.of(context).textTheme.headline4!))),
            ),
          )),
    );
  }

//----------------Student list------------------------------------//

  Widget buildSelectStudentBottomsheetWidget(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: Globals.deviceType == "phone"
                    ? const EdgeInsets.only(top: 8.0, right: 8)
                    : const EdgeInsets.only(top: 16.0, right: 16),
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
                _pageController.animateToPage(0,
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
          SpacerWidget(10),
          ValueListenableBuilder(
              valueListenable: selectionChange,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Container(
                  padding: EdgeInsets.all(5),
                  height: widget.height! * 0.60,
                  child: (allStudents?.isNotEmpty ?? false)
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: allStudents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return renderStudent(allStudents[index], index);
                          },
                        )
                      : Center(
                          child: NoDataFoundErrorWidget(
                            errorMessage: 'No Student Found',
                            marginTop: 16,
                            isResultNotFoundMsg: false,
                            isNews: false,
                            isEvents: false,
                            isSearchpage: true,
                          ),
                        ),
                );
              }),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: FloatingActionButton.extended(
                backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                onPressed: () async {
                  //this is for default  'ALL' selected
                  if (selectedStudentList?.isEmpty ?? true) {
                    selectedStudentList = getClassroomStudents(
                        classroomCoursesList:
                            widget.googleClassroomCourseworkList,
                        isSubmitOnTap: true);
                  } else {
                    //this is for selected students
                    selectedStudentList = getAllStudentsForCourse(
                      selectedStudentList: selectedStudentList,
                      classroomCoursesList:
                          widget.googleClassroomCourseworkList,
                    );
                  }

                  // Create a new ClassroomCourse object and add all selected students to it.
                  selectedRecords.add(ClassroomCourse(
                      id: '',
                      name: 'Students',
                      descriptionHeading: '',
                      ownerId: '',
                      enrollmentCode: '',
                      courseState: '',
                      students: selectedStudentList));

                  // Navigate to the third page with a quick animation.
                  _pageController.animateToPage(5,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                  _exportDataToSpreadSheet();
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

//---------------------return the student list-----------------//
  renderStudent(ClassroomStudents student, int index) {
    return InkWell(
      onTap: () {
        index == 0
            ? selectedStudentList.clear()
            : selectedStudentList.contains(student)
                ? selectedStudentList.remove(student)
                : selectedStudentList.add(student);

        // Refresh value in the UI
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
                  groupValue: selectedStudentList.contains(student),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppTheme.kButtonColor,
                  contentPadding: EdgeInsets.zero,
                  value: selectedStudentList.isNotEmpty || index != 0,
                  onChanged: (dynamic val) {},
                  title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(student.profile!.name!.fullName!,
                          style: Theme.of(context).textTheme.headline4!))),
            ),
          )),
    );
  }

//-------------------------view of student name and radio button -------------//

//page value=4
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
                'Exporting to Spreadsheet and resetting \'${msgForUi(sectionName)}\'',
            textTheme:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 18)),
      ],
    );
  }

  Container blocListener() {
    print("UI STATE------------BlocConsumer ");
    return Container(
      height: 0,
      width: 0,
      child: Column(
        children: [
          BlocConsumer<GoogleDriveBloc, GoogleDriveState>(
            bloc: googleDriveBloc,
            builder: (context, state) {
              print("UI STATE------------GOOGLE STATE $state");
              return Container(
                height: 0,
              );
            },
            listener: (context, state) async {
              print("UI STATE------------GOOGLE STATE $state");

              if (state is GoogleFolderCreated) {
                //In case of Folder Id received
                _exportDataToSpreadSheet();
              }
              if (state is ExcelSheetCreated) {
                googleDriveBloc.add(PBISPlusUpdateDataOnSpreadSheetTabs(
                    spreadSheetFileObj: state.googleSpreadSheetFileObj,
                    classroomCourseworkList:
                        (sectionName == 'All Courses & Students' ||
                                (selectedRecords?.isEmpty ?? true))
                            ? List<ClassroomCourse>.from(
                                widget.googleClassroomCourseworkList)
                            : selectedRecords));
              }
              if (state is PBISPlusUpdateDataOnSpreadSheetSuccess) {
                resetData();
              }
              if (state is ErrorState) {
                if (state.errorMsg == 'ReAuthentication is required') {
                  // await Utility.refreshAuthenticationToken(
                  //     isNavigator: true,
                  //     errorMsg: state.errorMsg!,
                  //     context: context,
                  //     scaffoldKey: widget.scaffoldKey);
                  await Authentication.reAuthenticationRequired(
                      context: context,
                      errorMessage: state.errorMsg!,
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
              print("UI STATE------------pbisBloc STATE $state");
              if (state is PBISErrorState) {
                Navigator.of(context).pop();
                Utility.currentScreenSnackBar(
                    state.error == 'NO_CONNECTION'
                        ? 'No Internet Connection'
                        : "Something Went Wrong. Please Try Again.",
                    null);
              }
              if (state is PBISPlusResetSuccess) {
                PlusUtility.updateLogs(
                    activityType: 'PBIS+',
                    userType: 'Teacher',
                    activityId: '40',
                    description: 'Save and Rest $sectionName',
                    operationResult: 'Success');

                Navigator.pop(context, sectionName);
                Utility.currentScreenSnackBar(
                    "\'${msgForUi(sectionName)}\' have been reset successfully.",
                    null);
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

  Future<void> _exportDataToSpreadSheet() async {
    // List<UserInformation> userProfileInfoData =
    //     await UserGoogleProfile.getUserProfile();
    //CREATE SPREADSHEET ON DRIVE

    List<UserInformation> userProfileInfoData =
        await UserGoogleProfile.getUserProfile();

    if (userProfileInfoData[0].pbisPlusGoogleDriveFolderId != null &&
        userProfileInfoData[0].pbisPlusGoogleDriveFolderId != "") {
      //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY

      googleDriveBloc.add(CreateExcelSheetToDrive(
          name:
              "PBIS_${Globals.appSetting.contactNameC}_${Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy")}",
          folderId: userProfileInfoData[0].pbisPlusGoogleDriveFolderId ?? ''));
    } else {
      //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
      _checkDriveFolderExistsOrNot();
    }
  }

//----------------------call method for reset data----------------//
  resetData() async {
    pbisBloc.add(PBISPlusResetInteractions(
      type: sectionName,
      selectedRecords: (sectionName == 'All Courses & Students' ||
              (selectedRecords?.isEmpty ?? true))
          ? List<ClassroomCourse>.from(widget.googleClassroomCourseworkList)
          : selectedRecords,
    ));
  }

  List<ClassroomStudents> getClassroomStudents(
      {required final List<ClassroomCourse> classroomCoursesList,
      bool? isSubmitOnTap}) {
    List<ClassroomCourse> classroomCourses =
        List<ClassroomCourse>.from(classroomCoursesList);

    final uniqueStudents = <ClassroomStudents>[];

    for (final course in classroomCourses) {
      for (final student in course?.students ?? []) {
        //Used for UI and onSubmit with different data sets required
        //-------------------------------------------------------------------------------------
        //student.profile?.name?.fullName != 'All' checking if visible on UI or not
        //-------------------------------------------------------------------------------------
        //!uniqueStudents.any((s) => s.profile?.id == student.profile?.id used to show unique students on UI only

        final isStudentUnique = (isSubmitOnTap != true ||
                student.profile?.name?.fullName != 'All') &&
            (isSubmitOnTap == true ||
                !uniqueStudents
                    .any((s) => s.profile?.id == student.profile?.id));

        // //Adding all objects of single student if exists multiple time in different courses
        if (isStudentUnique) {
          student.profile!.courseName = course.name;
          uniqueStudents.add(student);
        }
      }
    }

    uniqueStudents.sort((a, b) {
      // if ((isSubmitOnTap != true) &&
      //     (a == uniqueStudents[0] || b == uniqueStudents[0])) {
      //   return 0;
      // }
      return a.profile!.name!.fullName!
          .toLowerCase()
          .compareTo(b.profile!.name!.fullName!.toLowerCase());
    });

    if (isSubmitOnTap != true) {
      uniqueStudents
          .removeWhere((element) => element.profile!.name!.fullName == 'All');
      uniqueStudents.insert(0, classroomCourses[0].students![0]);
    }
    return uniqueStudents;
  }

//page 3
  Widget warningWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                },
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.kButtonColor,
                  size: Globals.deviceType == "phone" ? 28 : 36,
                ),
              )),
          SpacerWidget(10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Utility.textWidget(
                context: context,
                textAlign: TextAlign.center,
                text:
                    'This action will reset \'All Courses and Students\' PBIS scores. Do you still want to continue?',
                textTheme: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 18)),
          ),
          SpacerWidget(30),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: FloatingActionButton.extended(
                backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                onPressed: () async {
                  _pageController.animateToPage(5,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                  _exportDataToSpreadSheet();
                },
                label: Utility.textWidget(
                    text: 'Continue to Reset',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Theme.of(context).backgroundColor))),
          ),
        ],
      ),
    );
  }

  // Future<void> exportData() async {
  //   // if (PBISPlusOverrides.pbisPlusGoogleDriveFolderId.isNotEmpty == true) {
  //   //   //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY
  //   //   _exportDataToSpreadSheet();
  //   // } else {
  //   //   //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
  //   //   _checkDriveFolderExistsOrNot();
  //   // }
  //   List<UserInformation> userProfileInfoData =
  //       await UserGoogleProfile.getUserProfile();

  //   if (userProfileInfoData[0].pbisPlusGoogleDriveFolderId != null &&
  //       userProfileInfoData[0].pbisPlusGoogleDriveFolderId != "") {
  //     //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY
  //     _exportDataToSpreadSheet(userProfileInfoData[0]);
  //   } else {
  //     //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
  //     _checkDriveFolderExistsOrNot();
  //   }
  // }

//Used to add all courses data of single student if exist in multiple classes
  List<ClassroomStudents> getAllStudentsForCourse(
      {required List<ClassroomStudents> selectedStudentList,
      required final List<ClassroomCourse> classroomCoursesList}) {
    List<ClassroomCourse> classroomCourses =
        List<ClassroomCourse>.from(classroomCoursesList);

    try {
      //add all student that contains same ids
      List<ClassroomStudents> newStudentList = [];

      for (ClassroomStudents student in selectedStudentList) {
        for (ClassroomCourse course in classroomCourses) {
          if (course.name != 'All' && course.students != null) {
            //Checking selected students in each course of the classroom
            for (ClassroomStudents studentInCourse in course.students!) {
              if (studentInCourse.profile?.id == student.profile?.id) {
                ClassroomStudents newStudent = ClassroomStudents(
                  //TODOPBIS:  excel sheet
                  profile: ClassroomProfile(
                    courseName: course.name,
                    emailAddress: studentInCourse.profile?.emailAddress,
                    id: studentInCourse.profile?.id,
                    name: studentInCourse.profile?.name,
                    permissions: studentInCourse.profile?.permissions,
                    photoUrl: studentInCourse.profile?.photoUrl,
                    engaged: studentInCourse.profile?.engaged,
                    helpful: studentInCourse.profile?.helpful,
                    niceWork: studentInCourse.profile?.niceWork,
                    // behaviour1: studentInCourse.profile?.behaviour1,
                    // behaviour2: studentInCourse.profile?.behaviour2,
                    // behaviour3: studentInCourse.profile?.behaviour3,
                    // behaviour4: studentInCourse.profile?.behaviour4,
                    // behaviour5: studentInCourse.profile?.behaviour5,
                    // behaviour6: studentInCourse.profile?.behaviour6,
                  ),
                );

                newStudentList.add(newStudent);
                break;
              }
            }
          }
        }
      }

      return newStudentList;
    } catch (e) {
      print(e);
      return [];
    }
  }

//----------------Student list------------------------------------//

  Widget buildSelectStudentByCourseBottomsheetWidget(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: Globals.deviceType == "phone"
                    ? const EdgeInsets.only(top: 8.0, right: 8)
                    : const EdgeInsets.only(top: 16.0, right: 16),
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
                ),
              )),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Utility.textWidget(
                context: context,
                text: 'Select Students by Course',
                textTheme: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            leading: IconButton(
              onPressed: () {
                _pageController.animateToPage(0,
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
          SpacerWidget(10),
          ValueListenableBuilder(
              valueListenable: selectionChange,
              child: Container(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Container(
                  padding: EdgeInsets.all(5),
                  height: widget.height! * 0.65,
                  child: (widget.googleClassroomCourseworkList?.isNotEmpty ??
                          false)
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildCourseSeparationList(
                                course:
                                    widget.googleClassroomCourseworkList[index],
                                parentIndex: index);
                          },
                          itemCount:
                              widget.googleClassroomCourseworkList.length,
                        )
                      : Center(
                          child: NoDataFoundErrorWidget(
                            errorMessage: 'No Student Found',
                            marginTop: 16,
                            isResultNotFoundMsg: false,
                            isNews: false,
                            isEvents: false,
                            isSearchpage: true,
                          ),
                        ),
                );
              }),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: FloatingActionButton.extended(
                backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
                onPressed: () async {
                  //this is for default  'ALL' selected
                  if (selectedStudentList?.isEmpty ?? true) {
                    selectedRecords = widget.googleClassroomCourseworkList;
                  } else {
                    //this is for selected students
                    selectedRecords = prepareStudentListByCourseToReset(
                      selectedStudentList: selectedStudentList,
                      classroomCoursesList:
                          widget.googleClassroomCourseworkList,
                    );
                  }

                  // Navigate to the third page with a quick animation.
                  _pageController.animateToPage(5,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                  _exportDataToSpreadSheet();
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

  Widget _buildCourseSeparationList(
      {required ClassroomCourse course, required int parentIndex}) {
    return Column(children: [
      if ((course.students?.isNotEmpty ?? false) && parentIndex != 0)
        Center(
            child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            course.name ?? '',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppTheme.kButtonColor),
          ),
        )),
      if (course.students?.isNotEmpty ?? false)
        Container(
          // padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: course.students!.length,
            itemBuilder: (BuildContext context, int index) {
              return renderStudentByCourse(
                course: course,
                parentIndex: parentIndex,
                student: course.students![index],
                index: index,
              );
            },
          ),
        )
    ]);
  }

//---------------------return the student by course list-----------------//
  Widget renderStudentByCourse(
      {required ClassroomCourse course,
      required int parentIndex,
      required ClassroomStudents student,
      required int index}) {
    return InkWell(
      onTap: () {
        // add course id and name for to make student unique
        student.profile!.courseId = course.id;
        student.profile!.courseName = course.name;
        parentIndex == 0
            ? selectedStudentList.clear()
            : isStudentAlreadySelected(
                    selectedStudentList: selectedStudentList,
                    student:
                        student) //   //this will verify the current student is available in same course or not
                ? selectedStudentList.remove(student)
                : selectedStudentList.add(student);

        // Refresh value in the UI
        selectionChange.value = !selectionChange.value;
      },
      child: Container(
          height: 54,
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
                  groupValue: isStudentAlreadySelected(
                      selectedStudentList:
                          selectedStudentList, //    //this will verify the current student is available in same course or not
                      student: student),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppTheme.kButtonColor,
                  contentPadding: EdgeInsets.zero,
                  value: selectedStudentList.isNotEmpty || parentIndex != 0,
                  onChanged: (dynamic val) {},
                  title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(student.profile!.name!.fullName!,
                          style: Theme.of(context).textTheme.headline4!))),
            ),
          )),
    );
  }

  bool isStudentAlreadySelected(
      {required List<ClassroomStudents> selectedStudentList,
      required ClassroomStudents student}) {
    try {
      //this will verify the current student is available in same course or not
      for (ClassroomStudents selectedStudent in selectedStudentList) {
        if (selectedStudent.profile!.courseId == student.profile!.courseId &&
            selectedStudent.profile!.id == student.profile!.id) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Add all Selected student to a new list type class course
  List<ClassroomCourse> prepareStudentListByCourseToReset(
      {required List<ClassroomStudents> selectedStudentList,
      required final List<ClassroomCourse> classroomCoursesList}) {
    try {
      List<ClassroomCourse> classroomCourses =
          List<ClassroomCourse>.from(classroomCoursesList);
      List<ClassroomCourse> newClassroomCourseList = [];

      for (var i = 0; i < classroomCourses.length; i++) {
        //create current course obj with empty students
        ClassroomCourse currentCourseObj = classroomCourses[i];
        currentCourseObj.students = [];
        for (var j = 0; j < selectedStudentList.length; j++) {
          //check this current course is available in selected list if yes add with current obj students list
          if (classroomCourses[i].id ==
              selectedStudentList[j].profile!.courseId) {
            currentCourseObj.students!.add(selectedStudentList[j]);
          }
        }
// only add the current obj in list if students is atleast one available
        if (currentCourseObj.students?.isNotEmpty == true) {
          newClassroomCourseList.add(currentCourseObj);
        }
      }
      return newClassroomCourseList ?? [];
    } catch (e) {
      print(e);
      return [];
    }
  }

// this will remove the "select" word from msg to show on UI text and SnackBar text
  String msgForUi(String inputString) {
    try {
      if (inputString != null && inputString.isNotEmpty) {
        return inputString.replaceAll("select", "replace");
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
