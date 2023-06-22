import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_classroom/bloc/google_classroom_bloc.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/plus_common_widgets/common_modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_utility.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:Soc/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class PBISPlusBottomSheet extends StatefulWidget {
  final bool? fromClassScreen;
  final double? constraintDeviceHeight;
  final double? height;
  final bool? content;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final List<ClassroomCourse> googleClassroomCourseworkList;
  final GlobalKey<State<StatefulWidget>>? scaffoldKey;
  final bool? isClassPage;

  final ScreenshotController? screenshotController;
  final ScreenshotController? headerScreenshotController;
  PBISPlusBottomSheet(
      {Key? key,
      required this.fromClassScreen,
      this.constraintDeviceHeight,
      this.height = 200,
      this.isClassPage,
      this.title,
      this.content = true,
      this.padding,
      required this.googleClassroomCourseworkList,
      required this.scaffoldKey,
      this.screenshotController,
      this.headerScreenshotController});
  @override
  State<PBISPlusBottomSheet> createState() => _PBISPlusBottomSheetState();
}

class _PBISPlusBottomSheetState extends State<PBISPlusBottomSheet> {
  late PageController _pageController;
  final pointPossibleController = TextEditingController();
  final ValueNotifier<bool> selectionChange = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  GoogleClassroomBloc classroomBloc = GoogleClassroomBloc();
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
  int pageValue = 0;
  bool classroomLoader = false;
  bool isShareLoader = false;

  //default value '0' to show 'All' in the course bottomsheet list by default selected
  List<ClassroomCourse> selectedCoursesList = [];

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });

    /*-------------------------User Activity Track START----------------------------*/
    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_save_and_share_bottomsheet");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_save_and_share_bottomsheet',
        screenClass: 'PBISPlusBottomSheet');
    /*-------------------------User Activity Track END----------------------------*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final double progress =
    //     _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
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
          height: pageValue == 1 //classroomMaxPointQue
              ? widget.height! * 1.2
              : pageValue == 2 //buildGoogleClassroomCourseWidget
                  ? widget.height! *
                      (widget.constraintDeviceHeight! < 800 ? 1.4 : 1.5)
                  : pageValue == 3 //commonLoaderWidget
                      ? widget.fromClassScreen!
                          ? (widget.height! * 0.6)
                          : (widget.height! * 1.3)
                      : widget.height, //saveAndShareOptions
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
          mainAxisAlignment: !widget.content!
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.all(0),
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
            SpacerWidget(widget?.title?.isNotEmpty == true ? 20 : 0),
            if (widget.content!) ...[
              _listTileMenu(
                  leading: SvgPicture.asset(
                    "assets/ocr_result_section_bottom_button_icons/Classroom.svg",
                    height: 30,
                    width: 30,
                  ),
                  title: 'Classroom',
                  onTap: () async {
                    PlusUtility.updateLogs(
                        activityType: 'PBIS+',
                        userType: 'Teacher',
                        activityId: '35',
                        description: 'G-Classroom Action Button',
                        operationResult: 'Success');

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
                    PlusUtility.updateLogs(
                        activityType: 'PBIS+',
                        userType: 'Teacher',
                        activityId: '32',
                        description: 'G-Excel Action Button',
                        operationResult: 'Success');

                    classroomLoader = false;
                    _pageController.jumpToPage(2);
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
                onTap: (() async {
                  await shareScreenDetails();
                  PlusUtility.updateLogs(
                      activityType: 'PBIS+',
                      userType: 'Teacher',
                      activityId: '13',
                      description: 'Share copy of screen as PDF',
                      operationResult: 'Success');
                })),
          ]),
    );
  }

  /* ------------------ Function to share screenshot as a pdf ----------------- */
  shareScreenDetails() async {
    try {
      isShareLoader = true;
      // to show loading
      _pageController.jumpToPage(3);
      //Utility.showLoadingDialog(context: context, isOCR: false);

      // taking screenshot and save it on Uint8List
      final headerUint8List = widget.headerScreenshotController == null
          ? null
          : await widget.headerScreenshotController!.capture();
      final uint8List = widget.screenshotController != null
          ? await widget.screenshotController!.capture()
          : null;

      // create pdf
      final pdf = pdfWidget.Document();

      // to get image size
      Size headerSize = widget.fromClassScreen == true
          ? Size(0, 0)
          : await getImageSize(headerUint8List!);
      Size size = uint8List != null
          ? await getImageSize(uint8List)
          : Size(headerSize.width, 0);

      // adding page to pdf
      pdf.addPage(
        pdfWidget.MultiPage(
          header: (context) {
            return pdfWidget.Container(height: 50);
          },
          pageFormat: PdfPageFormat(
              size.width,
              (headerSize.height + size.height) > 2000
                  ? (headerSize.height + size.height)
                  : (headerSize.height + size.height) + 500),
          mainAxisAlignment: pdfWidget.MainAxisAlignment.start,
          crossAxisAlignment: pdfWidget.CrossAxisAlignment.start,
          margin: pdfWidget.EdgeInsets.all(0),
          maxPages: 2000,
          build: (contxt) {
            return [
              headerUint8List == null
                  ? pdfWidget.Container()
                  : pdfWidget.Container(
                      color:
                          Color(0xff000000) != Theme.of(context).backgroundColor
                              ? PdfColor.fromHex("F7F8F9")
                              : PdfColor.fromHex("111C20"),
                      margin: pdfWidget.EdgeInsets.symmetric(horizontal: 50),
                      child: pdfWidget.Center(
                          child: pdfWidget.Image(
                              pdfWidget.MemoryImage(headerUint8List),
                              fit: pdfWidget.BoxFit.contain)),
                    ),
              uint8List != null
                  ? pdfWidget.Container(
                      padding: pdfWidget.EdgeInsets.symmetric(horizontal: 50),
                      child: pdfWidget.Image(
                        pdfWidget.MemoryImage(uint8List),
                      ),
                    )
                  : pdfWidget.Container(),
            ];
          },
        ),
      );

      var directory = (await getApplicationDocumentsDirectory()).path;
      final currentDate =
          Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy")
              .replaceAll('/', '-');
      String value = widget.isClassPage == true ? 'Class' : 'Student';
      final file = File(
          '$directory/PBIS_${value}_${Globals.appSetting.contactNameC}_$currentDate.pdf');

      await file.writeAsBytes(await pdf.save());

      // closing to loading dialog and bottom sheet
      // Navigator.pop(context);
      _pageController.jumpTo(3);

      Navigator.pop(context);
      FocusScope.of(context).requestFocus(FocusNode());
      isShareLoader = false;

      //share the file
      Share.shareFiles(
        [file.path],
      );
    } catch (e) {
      Utility.currentScreenSnackBar(
          'Something went wrong! Please try again', '');
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  /* ---------------------- Function to get size of image --------------------- */
  Future<Size> getImageSize(Uint8List imageData) async {
    final image = await decodeImageFromList(imageData);

    return Size(image.width.toDouble(), image.height.toDouble());
  }

  // pdfWidget.TableRow profileTile(
  //     {required String title,
  //     required String value,
  //     required pdfWidget.Context context}) {
  //   return pdfWidget.TableRow(children: [
  //     pdfWidget.Container(
  //       alignment: pdfWidget.Alignment.centerLeft,
  //       margin: pdfWidget.EdgeInsets.all(5),
  //       child: pdfWidget.Text(title,
  //           style: pdfWidget.Theme.of(context).tableHeader),
  //     ),
  //     pdfWidget.Container(
  //       alignment: pdfWidget.Alignment.centerLeft,
  //       margin: pdfWidget.EdgeInsets.all(5),
  //       child: pdfWidget.Text(value.toUpperCase(),
  //           style: pdfWidget.Theme.of(context).tableCell),
  //     ),
  //   ]);
  // }

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
          SpacerWidget(20),
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
                            .copyWith(
                                color: Theme.of(context).backgroundColor)),
                  ],
                )),
          ),
        ],
      ),
    );
  }

//page value=2
  Widget buildGoogleClassroomCourseWidget() {
    return SingleChildScrollView(
      child: Column(
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
                text: 'Select Course',
                textTheme: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            leading: IconButton(
              onPressed: () {
                _pageController.animateToPage(
                    classroomLoader == false ? 0 : pageValue - 1,
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
                  _pageController.jumpToPage(3);

                  //Create Google Classroom Assignment for Selected Courses if classroomLoader = true
                  if (classroomLoader) {
                    classroomBloc.add(CreatePBISClassroomCoursework(
                      pointPossible: pointPossibleController.text,
                      courseAndStudentList: selectedCoursesList.length == 0
                          ? widget.googleClassroomCourseworkList
                          : selectedCoursesList,
                      // studentAssessmentInfoDb: studentAssessmentInfoDb
                    ));
                  }
                  //Create Google Spreadsheet for Selected Courses if classroomLoader = false
                  else {
                    // if (PBISPlusOverrides
                    //         .pbisPlusGoogleDriveFolderId.isNotEmpty ==
                    //     true) {
                    //   //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY
                    //   _createSpreadSheet();
                    // } else {
                    //   //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
                    //   _checkDriveFolderExistsOrNot();
                    // }

                    _createSpreadSheet();
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
          // classroomLoader
          //     ? googleClassroomBlocListener()
          //     : googleDriveBlocListener()
        ],
      ),
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
                      child: Text(courseList[index].name!,
                          style: Theme.of(context).textTheme.headline4!))),
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
                ? 'Preparing Google Classroom Assignment'
                : isShareLoader == true
                    ? 'Preparing PDF'
                    : 'Preparing Google Spreadsheet',
            textTheme:
                Theme.of(context).textTheme.headline5!.copyWith(fontSize: 18)),
        classroomLoader
            ? googleClassroomBlocListener()
            : googleDriveBlocListener()
      ],
    );
  }

  Widget googleClassroomBlocListener() {
    return Container(
      height: 0,
      width: 0,
      child: BlocListener<GoogleClassroomBloc, GoogleClassroomState>(
          bloc: classroomBloc,
          listener: (context, state) async {
            if (state is CreateClassroomCourseWorkSuccess) {
              PlusUtility.updateLogs(
                  activityType: 'PBIS+',
                  userType: 'Teacher',
                  activityId: '34',
                  description: 'G-Classroom Created',
                  operationResult: 'Success');

              Navigator.pop(context, true);
              Utility.currentScreenSnackBar(
                  "Google Classroom Assignments Created Successfully.", null);
            }

            if (state is GoogleClassroomErrorState) {
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

  Widget googleDriveBlocListener() {
    return Container(
      height: 0,
      width: 0,
      child: BlocListener<GoogleDriveBloc, GoogleDriveState>(
          bloc: googleDriveBloc,
          listener: (context, state) async {
            if (state is GoogleSuccess) {
              //In case of Folder Id received
              _createSpreadSheet();
            }
            if (state is ExcelSheetCreated) {
              googleDriveBloc.add(PBISPlusUpdateDataOnSpreadSheetTabs(
                  spreadSheetFileObj: state.googleSpreadSheetFileObj,
                  classroomCourseworkList: selectedCoursesList?.isEmpty ?? true
                      ? widget.googleClassroomCourseworkList
                      : selectedCoursesList));
            }
            if (state is PBISPlusUpdateDataOnSpreadSheetSuccess) {
              Navigator.pop(context, true);
              Utility.currentScreenSnackBar(
                  "Google SpreadSheet Created Successfully.", null);
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
          child: EmptyContainer()),
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

  void _createSpreadSheet() async {
    List<UserInformation> userProfileInfoData =
        await UserGoogleProfile.getUserProfile();

    if (userProfileInfoData[0].pbisPlusGoogleDriveFolderId != null &&
        userProfileInfoData[0].pbisPlusGoogleDriveFolderId != "") {
      //CREATE SPREADSHEET ON DRIVE IF FOLDER ID IS NOT EMPTY
      //CREATE SPREADSHEET ON DRIVE
      googleDriveBloc.add(CreateExcelSheetToDrive(
          name:
              "PBIS_${Globals.appSetting.contactNameC}_${Utility.convertTimestampToDateFormat(DateTime.now(), "MM/dd/yy")}",
          folderId: userProfileInfoData[0].pbisPlusGoogleDriveFolderId ?? ''));
    } else {
      //CHECK AND FETCH FOLDER ID TO CREATE SPREADSHEET In
      _checkDriveFolderExistsOrNot();
    }
  }
}
