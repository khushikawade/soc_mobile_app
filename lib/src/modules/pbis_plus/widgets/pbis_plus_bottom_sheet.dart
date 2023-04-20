import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PBISPlusBottomSheet extends StatefulWidget {
  final double height;
  final bool content;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final List<ClassroomCourse> googleClassroomCourseworkList;
  final GlobalKey<State<StatefulWidget>>? scaffoldKey;
  PBISPlusBottomSheet(
      {Key? key,
      this.height = 200,
      this.title,
      this.content = true,
      this.padding,
      required this.googleClassroomCourseworkList,
      required this.scaffoldKey});
  @override
  State<PBISPlusBottomSheet> createState() => _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusBottomSheet> {
  late PageController _pageController;
  final pointPossibleController = TextEditingController();
  final ValueNotifier<bool> selectionChange = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  GoogleClassroomBloc classroomBloc = GoogleClassroomBloc();

  int pageValue = 0;
  bool classroomLoader = false;

  //default value '0' to show 'All' in the course bottomsheet list by default selected
  List<ClassroomCourse> selectedCoursesList = [];

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final double progress =
    //     _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.3,
      controller: ModalScrollController.of(context),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          // padding: widget.padding ?? EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          height: pageValue == 1
              ? widget.height * 1.4
              : pageValue == 2
                  ? widget.height * 1.8
                  : pageValue == 3
                      ? widget.height * 0.8
                      : widget.height,
          child: PageView(
            physics:
                // pageValue == 0
                // ?
                NeverScrollableScrollPhysics(),
            // : BouncingScrollPhysics(),
            onPageChanged: ((value) {
              pageValue = value;
            }),
            allowImplicitScrolling: false,
            pageSnapping: false,
            controller: _pageController,
            children: [
              saveAndShareOptions(),
              classroomMaxPointQue(),
              buildGoogleClassroomCourseWidget(),
              commonLoaderWidget()
            ],
          )),
    );
  }

//page value=0
  Widget saveAndShareOptions() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: !widget.content
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.topRight,

                // padding: EdgeInsets.only(top: 16),
                //color: Colors.amber,
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
            if (widget?.title?.isNotEmpty ?? false)
              Utility.textWidget(
                  context: context,
                  text: widget.title!,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            SpacerWidget(20),
            if (widget.content) ...[
              _listTileMenu(
                  leading: SvgPicture.asset(
                    "assets/ocr_result_section_bottom_button_icons/Classroom.svg",
                    height: 30,
                    width: 30,
                  ),
                  title: 'Classroom',
                  onTap: () {
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  }),
              _listTileMenu(
                  leading: SvgPicture.asset(
                    "assets/ocr_result_section_bottom_button_icons/Spreadsheet.svg",
                    height: 30,
                    width: 30,
                  ),
                  title: 'Spreadsheet',
                  onTap: () {
                    classroomLoader = false;
                    _pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease);
                  }),
              Container(
                padding: EdgeInsets.only(right: 16),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
              ),
            ],
            _listTileMenu(
                leading: Icon(
                  Icons.share,
                  color: Colors.grey,
                ),
                title: 'Share',
                onTap: (() {})),
          ]),
    );
  }

  ListTile _listTileMenu({Widget? leading, String? title, Function()? onTap}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 20,
      leading: leading,
      title: Utility.textWidget(
          text: title!,
          context: context,
          textTheme: Theme.of(context).textTheme.headline3!),
      onTap: onTap,
    );
  }

//page value=1
  Widget classroomMaxPointQue() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.topRight,

            // padding: EdgeInsets.only(top: 16),
            //color: Colors.amber,
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
          minLeadingWidth: 70,
          title: Utility.textWidget(
              context: context,
              // textAlign: TextAlign.center,
              text: 'Google Classroom',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            onPressed: () {
              _pageController.animateToPage(pageValue - 1,
                  duration: const Duration(milliseconds: 400),
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
        SpacerWidget(15),
        Utility.textWidget(
            context: context,
            textAlign: TextAlign.center,
            text:
                'This information will be saved to Google Classroom as an assignment. Please input the total points possible as required by Google Classroom.',
            textTheme: Theme.of(context).textTheme.bodyText1!),
        SpacerWidget(30),
        Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextFieldWidget(
                  hintText: 'Points Possible',
                  msg: "Field is required",
                  keyboardType: TextInputType.number,
                  controller: pointPossibleController,
                  onSaved: (String value) {})),
        ),
        SpacerWidget(30),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease);

                  classroomLoader = true;
                }
              },
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utility.textWidget(
                      text: 'Next',
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

//page value=2
  Widget buildGoogleClassroomCourseWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.topRight,

            // padding: EdgeInsets.only(top: 16),
            //color: Colors.amber,
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
          // minLeadingWidth: 70,
          title: Utility.textWidget(
              context: context,
              // textAlign: TextAlign.center,
              text: 'Select Google Classroom Course',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            onPressed: () {
              _pageController.animateToPage(pageValue - 1,
                  duration: const Duration(milliseconds: 400),
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
                height: MediaQuery.of(context).size.height * 0.36,
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
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: FloatingActionButton.extended(
              backgroundColor: AppTheme.kButtonColor.withOpacity(1.0),
              onPressed: () async {
                _pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease);

                classroomLoader = true;

                classroomBloc.add(CreatePBISClassroomCoursework(
                  pointPossible: pointPossibleController.text,
                  courseAndStudentList: selectedCoursesList.length == 0
                      ? widget.googleClassroomCourseworkList
                      : selectedCoursesList,
                  // studentAssessmentInfoDb: studentAssessmentInfoDb
                ));
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
                          .copyWith(color: Theme.of(context).backgroundColor)),
                ],
              )),
        ),
        blocListener()
      ],
    );
  }

  Widget _classroomCourseRadioList(
      int index, context, List<ClassroomCourse> courseList) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          //In case of ALL no other course can be selected individually
          selectedCoursesList.clear();
          // selectedCoursesList.addAll(courseList);
        } else if (!selectedCoursesList.contains(courseList[index])) {
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
                  // value: selectedIndex.value == index ||
                  //         widget.filterNotifier.value == text
                  //     ? true
                  //     : false,
                  onChanged: (dynamic val) {},
                  // groupValue: true,
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
            text: classroomLoader
                ? 'Please be patient while your \'Google Classroom\' assignment is being created. It may take a while.'
                : 'Preparing Google Spreadsheet',
            textTheme:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 18)),
        blocListener()
      ],
    );
  }

  Widget blocListener() {
    return Container(
      height: 0,
      width: 0,
      child: BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
          bloc: classroomBloc,
          listener: (context, state) async {
            if (state is CreateClassroomCourseWorkSuccess) {
              Navigator.pop(context);
              Utility.currentScreenSnackBar(
                  "Google Classroom Assignments Created Successfully.", null);
            }
            if (state is GoogleClassroomErrorState) {
              if (state.errorMsg == 'ReAuthentication is required') {
                await Utility.refreshAuthenticationToken(
                    isNavigator: true,
                    errorMsg: state.errorMsg!,
                    context: context,
                    scaffoldKey: widget.scaffoldKey);

                classroomBloc.add(CreatePBISClassroomCoursework(
                  pointPossible: pointPossibleController.text,
                  courseAndStudentList: selectedCoursesList.length == 0
                      ? widget.googleClassroomCourseworkList
                      : selectedCoursesList,
                  // studentAssessmentInfoDb: studentAssessmentInfoDb
                ));
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
          child: EmptyContainer()),
    );
  }
}
