// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:Soc/src/modules/google_presentation/bloc/google_presentation_bloc.dart';
import 'package:Soc/src/modules/graded_plus/helper/result_action_icon_modal.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';

class StudentPlusOptionBottomSheet extends StatefulWidget {
  final String? title;
  final double? height;
  StudentPlusDetailsModel studentDetails;
  final String? filterName;
  final List<ResultSummaryIcons> resultSummaryIconsModalList;

  StudentPlusOptionBottomSheet(
      {Key? key,
      this.title,
      this.height = 200,
      required this.resultSummaryIconsModalList,
      required this.studentDetails,
      required this.filterName});

  @override
  State<StudentPlusOptionBottomSheet> createState() =>
      _GradedPlusResultOptionBottomSheetState();
}

class _GradedPlusResultOptionBottomSheetState
    extends State<StudentPlusOptionBottomSheet>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int pageValue = 0;

  final GoogleSlidesPresentationBloc googleSlidesPresentationBloc =
      GoogleSlidesPresentationBloc();
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  StudentPlusBloc studentPlusBloc = StudentPlusBloc();
  final ValueNotifier<bool> isStateRecived = ValueNotifier<bool>(false);
  @override
  void initState() {
    initMethod();

    super.initState();
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------initMethod----------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  initMethod() async {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------dispose-----------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  @override
  void dispose() {
    _pageController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------MAIN METHOD---------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    return body();
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------BODY FRAME---------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  Widget body() {
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: Color(0xff000000) != Theme.of(context).backgroundColor
                  ? Color(0xffF7F8F9)
                  : Color(0xff111C20),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            // padding: EdgeInsets.only(left: 16),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: PageView(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: ((value) {
                  pageValue = value;
                }),
                allowImplicitScrolling: false,
                pageSnapping: false,
                controller: _pageController,
                children: [
                  buildOptions(),
                  commonLoaderWidget(),
                ])),
      ),
    );
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------_listTileMenu-------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  Widget _listTileMenu({required ResultSummaryIcons element}) {
    return Opacity(
      opacity: (widget.studentDetails.studentGooglePresentationUrl == null ||
                  widget.studentDetails.studentGooglePresentationUrl == '') &&
              element.title == "Open Presentation"
          ? 0.5
          : 1,
      child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 20,
          leading: element.title == "Sync Presentation"
              ? Icon(Icons.sync,
                  size: 30,
                  color: Color(0xff000000) == Theme.of(context).backgroundColor
                      ? Color(0xffF7F8F9)
                      : Color(0xff111C20))
              : SvgPicture.asset(element.svgPath!, height: 30, width: 30),
          title: Utility.textWidget(
              text: element.title!,
              context: context,
              textTheme: Theme.of(context).textTheme.headline3!),
          onTap: () {
            bottomIconsOnTap(
                title: element.title ?? '',
                url: widget.studentDetails.studentGooglePresentationUrl ?? '');
          }),
    );
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------bottomIconsOnTap-------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  bottomIconsOnTap({required String title, required String url}) async {
    switch (title) {
      case 'Open Presentation':
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Utility.launchUrlOnExternalBrowser(url);
        }
        break;

      case 'Sync Presentation':
        navigateToPage(pageIndex: 1);

        if (widget.studentDetails.studentGooglePresentationId == null ||
            widget.studentDetails.studentGooglePresentationId == '') {
          createStudentGooglePresentation();
        } else {
          updateStudentGooglePresentation();
        }
        break;

      default:
        Utility.currentScreenSnackBar('$title is not available', null);
    }
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------buildOptions---------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  Widget buildOptions() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.of(context).pop(widget.studentDetails);
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36,
              ),
            ),
          ),
          widget?.title?.isNotEmpty ?? false
              ? Column(
                  children: [
                    PlusScreenTitleWidget(
                      kLabelSpacing: 8,
                      text: widget.title!,
                    ),
                    SpacerWidget(10)
                  ],
                )
              : Container(),
          ...widget.resultSummaryIconsModalList
              .map((ResultSummaryIcons element) => Builder(builder: (context) {
                    return ValueListenableBuilder(
                        valueListenable: isStateRecived,
                        builder: (context, value, child) {
                          return _listTileMenu(element: element);
                        });
                  })),
        ],
      ),
    );
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------commonLoaderWidget-------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
//page value=4
  Widget commonLoaderWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // SpacerWidget(50),
          CircularProgressIndicator.adaptive(
            backgroundColor: AppTheme.kButtonColor,
          ),
          SpacerWidget(30),
          Utility.textWidget(
              context: context,
              textAlign: TextAlign.center,
              text: 'Google Presentation Syncing',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontSize: 18)),
          if (pageValue == 1)
            Column(
              children: [
                // googleDriveBlocListener(),
                googleSlidesPresentationBlocListener(),
                studentPlusBlocListener()
              ],
            )
        ],
      ),
    );
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------googleSlidesPresentationBlocListener--------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  BlocListener googleSlidesPresentationBlocListener() {
    return BlocListener<GoogleSlidesPresentationBloc,
            GoogleSlidesPresentationState>(
        bloc: googleSlidesPresentationBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is GoogleSlidesPresentationErrorState) {
            widget.studentDetails.studentGooglePresentationId = '';
            widget.studentDetails.studentGooglePresentationUrl = '';
            isStateRecived.value = !isStateRecived.value;
            navigateToPage(pageIndex: 0);

            if (state.errorMsg == 'ReAuthentication is required') {
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION'
                      ? 'No Internet Connection'
                      : state.errorMsg == "404"
                          ? "Ahh! Looks like the Google Presentation moved to trash. Try again to create a new Google Presentation."
                          : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }

          if (state is StudentPlusCreateStudentWorkGooglePresentationSuccess) {
            //update the current student object
            widget.studentDetails.studentGooglePresentationId =
                state.googlePresentationFileId;

            //now update the student google Presentation on drive
            updateStudentGooglePresentation();
          }
          if (state is StudentPlusUpdateStudentWorkGooglePresentationSuccess) {
            if (state.isSaveStudentGooglePresentationWorkOnDataBase == false) {
              isStateRecived.value = !isStateRecived.value;

              navigateToPage(pageIndex: 0);
              Utility.currentScreenSnackBar(
                  "Student presentation synced to google drive successfully.",
                  null);
            } else {
              // //now update the save the student google Presentation work on database
              widget.studentDetails = state.studentDetails;
              //now update the save the student google Presentation work on database
              studentPlusBloc.add(SaveStudentGooglePresentationWorkEvent(
                  filterName: widget.filterName ?? '',
                  studentDetails: state.studentDetails));
            }
          }
        });
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------createStudentGooglePresentation-----------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  Future<void> createStudentGooglePresentation() async {
    List<UserInformation> userProfileInfoData =
        await UserGoogleProfile.getUserProfile();

    googleSlidesPresentationBloc.add(
        StudentPlusCreateGooglePresentationForStudent(
            filterName: widget.filterName ?? '',
            studentPlusDriveFolderId:
                userProfileInfoData[0].studentPlusGoogleDriveFolderId ?? '',
            studentDetails: widget.studentDetails));
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------updateStudentGooglePresentation-----------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  updateStudentGooglePresentation() async {
    LocalDatabase<StudentPlusWorkModel> _localDb = LocalDatabase(
        "${StudentPlusOverrides.studentWorkList}_${widget.studentDetails.studentIdC}");

    List<StudentPlusWorkModel>? _localData = await _localDb.getData();
    _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
    List<StudentPlusWorkModel> studentWorkUpdatedList = [];
    //Filtered Records
    for (int i = 0; i < _localData.length; i++) {
      if (_localData[i].subjectC == widget.filterName ||
          widget.filterName == '' ||
          widget.filterName ==
              "${_localData[i].firstName ?? ''} ${_localData[i].lastName ?? ''}") {
        studentWorkUpdatedList.add(_localData[i]);
      }
    }

    googleSlidesPresentationBloc.add(
        StudentPlusUpdateGooglePresentationForStudent(
            studentDetails: widget.studentDetails,
            allRecords: studentWorkUpdatedList));
  }

/*-------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------studentPlusBlocListener---------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------*/
  BlocListener studentPlusBlocListener() {
    return BlocListener(
        bloc: studentPlusBloc,
        child: Container(),
        listener: (context, state) async {
          if (state is SaveStudentGooglePresentationWorkEventSuccess) {
            // Navigator.of(context).pop(widget.studentDetails);
            Utility.currentScreenSnackBar(
                "Student presentation synced to google drive successfully.",
                null);
            isStateRecived.value = !isStateRecived.value;
            navigateToPage(pageIndex: 0);
          }
          if (state is StudentPlusErrorReceived) {
            widget.studentDetails.studentGooglePresentationId = '';
            widget.studentDetails.studentGooglePresentationUrl = '';
            // Navigator.of(context).pop();
            Utility.currentScreenSnackBar(
                "Something went wrong. Please try Again.", null);
            isStateRecived.value = !isStateRecived.value;
            navigateToPage(pageIndex: 0);
          }
        });
  }

  void navigateToPage({required int pageIndex}) {
    _pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }
}
