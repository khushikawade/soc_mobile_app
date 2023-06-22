import 'package:Soc/src/globals.dart';
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
  final StudentPlusDetailsModel studentDetails;
  final List<ResultSummaryIcons> resultSummaryIconsModalList;

  const StudentPlusOptionBottomSheet(
      {Key? key,
      this.title,
      this.height = 200,
      required this.resultSummaryIconsModalList,
      required this.studentDetails});

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

  @override
  void initState() {
    initMethod();

    super.initState();
  }

  initMethod() async {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return SingleChildScrollView(
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
    );
  }

  Widget _listTileMenu({required ResultSummaryIcons element}) {
    return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 20,
        leading: element.title == "Sync Presentation"
            ? Icon(Icons.sync,
                color: Color(0xff000000) == Theme.of(context).backgroundColor
                    ? Color(0xffF7F8F9)
                    : Color(0xff111C20))
            : SvgPicture.asset(
                element.svgPath!,
                height: 30,
                width: 30,
                // color: element.title == "Dashboard"
                //     ? Color(0xff000000) == Theme.of(context).backgroundColor
                //         ? Color(0xffF7F8F9)
                //         : Color(0xff111C20)
                //     : null
              ),
        title: Utility.textWidget(
            text: element.title!,
            context: context,
            textTheme: Theme.of(context).textTheme.headline3!),
        onTap: () {
          bottomIconsOnTap(
              title: element.title ?? '',
              url: widget.studentDetails.googlePresentationUrl ?? '');
        });
  }

  bottomIconsOnTap({required String title, required String url}) async {
    switch (title) {
      case 'Go to Presentation':
        if ((url?.isNotEmpty ?? false) && (url != 'NA')) {
          Utility.launchUrlOnExternalBrowser(url);
        }

        break;
      case 'Sync Presentation':
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);

        //check student+ folder available or not if not create one
        // if (StudentPlusOverrides?.studentPlusGoogleDriveFolderId?.isNotEmpty ??
        //     false) {
        //   print("Trigger to check the folder ");
        //   studentPlusGooglePresentationIsAvailable();
        // } else {
        //   _checkDriveFolderExistsOrNot();
        // }
        List<UserInformation> userProfileInfoData =
            await UserGoogleProfile.getUserProfile();
        if (userProfileInfoData[0].studentPlusGoogleDriveFolderId != null &&
            userProfileInfoData[0].studentPlusGoogleDriveFolderId != '') {
          print("Trigger to check the folder ");
          studentPlusGooglePresentationIsAvailable();
        } else {
          _checkDriveFolderExistsOrNot();
        }

        break;
      default:
        Utility.currentScreenSnackBar('$title is Not available ', null);
    }
    // if (((url?.isEmpty ?? true) || (url == 'NA'))) {
    //   Utility.currentScreenSnackBar('$title is Not available ', null);
    // }
  }

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
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.kButtonColor,
                size: Globals.deviceType == "phone" ? 28 : 36,
              ),
            ),
          ),
          widget?.title?.isNotEmpty ?? false
              ? Utility.textWidget(
                  context: context,
                  text: widget.title!,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18))
              : Container(),
          ...widget.resultSummaryIconsModalList.map(
              (ResultSummaryIcons element) => _listTileMenu(element: element)),
        ],
      ),
    );
  }

//page value=4
  Widget commonLoaderWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
              text: 'Google Presentation Syncing',
              textTheme: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontSize: 18)),
          if (pageValue == 1)
            Column(
              children: [
                googleDriveBlocListener(),
                googleSlidesPresentationBlocListener()
              ],
            )
        ],
      ),
    );
  }

  BlocListener googleDriveBlocListener() {
    return BlocListener<GoogleDriveBloc, GoogleDriveState>(
        bloc: googleDriveBloc,
        child: Container(),
        listener: (context, state) async {
          // if (state is GoogleSuccess) {

          //   if (StudentPlusOverrides
          //           ?.studentPlusGoogleDriveFolderId?.isNotEmpty ??
          //       false) {
          //     studentPlusGooglePresentationIsAvailable();
          //   } else {
          //     Navigator.of(context).pop();
          //     Utility.currentScreenSnackBar(
          //         "Something Went Wrong. Please Try Again.", null);
          //   }
          // }

          if (state is GoogleSuccess) {
            List<UserInformation> userProfileInfoData =
                await UserGoogleProfile.getUserProfile();
            if (userProfileInfoData[0].studentPlusGoogleDriveFolderId != null &&
                userProfileInfoData[0].studentPlusGoogleDriveFolderId != '') {
              studentPlusGooglePresentationIsAvailable();
            } else {
              Navigator.of(context).pop();
              Utility.currentScreenSnackBar(
                  "Something Went Wrong. Please Try Again.", null);
            }
          }
          if (state is ErrorState) {
            Navigator.of(context).pop();
            if (state.errorMsg == 'ReAuthentication is required') {
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: false,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  "Something Went Wrong. Please Try Again.", null);
            }
          }
        });
  }

  BlocListener googleSlidesPresentationBlocListener() {
    return BlocListener<GoogleSlidesPresentationBloc,
            GoogleSlidesPresentationState>(
        bloc: googleSlidesPresentationBloc,
        child: Container(),
        listener: (context, state) async {
          print("On student work ------------$state---------");

          if (state is StudentPlusGooglePresentationSearchSuccess) {
            LocalDatabase<StudentPlusWorkModel> _localDb = LocalDatabase(
                "${StudentPlusOverrides.studentWorkList}_${widget.studentDetails.studentIdC}");

            List<StudentPlusWorkModel>? _localData = await _localDb.getData();
            _localData.sort((a, b) => b.dateC!.compareTo(a.dateC!));
            print("update the presentation event trigger");
            googleSlidesPresentationBloc.add(
                StudentPlusCreateAndUpdateNewSlidesToGooglePresentation(
                    googlePresentationFileId: state.googlePresentationFileId,
                    studentDetails: widget.studentDetails,
                    allRecords: _localData));
          }

          if (state is StudentPlusCreateAndUpdateSlideSuccess) {
            Navigator.of(context).pop();
          }

          if (state is GoogleSlidesPresentationErrorState) {
            Navigator.of(context).pop();

            if (state.errorMsg == 'ReAuthentication is required') {
              // await Utility.refreshAuthenticationToken(
              //     isNavigator: false,
              //     errorMsg: state.errorMsg!,
              //     context: context,
              //     scaffoldKey: scaffoldKey);
              await Authentication.reAuthenticationRequired(
                  context: context,
                  errorMessage: state.errorMsg!,
                  scaffoldKey: scaffoldKey);
            } else {
              Utility.currentScreenSnackBar(
                  state.errorMsg == 'NO_CONNECTION'
                      ? 'No Internet Connection'
                      : "Something Went Wrong. Please Try Again.",
                  null);
            }
          }
        });
  }

  void _checkDriveFolderExistsOrNot() async {
    //FOR STUDENT PLUS
    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    //It will trigger the drive event to check is that (SOLVED STUDENT+) folder in drive
    //is available or not if not this will create one or the available get the drive folder id
    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: true,
        token: userProfile.authorizationToken,
        folderName: "SOLVED STUDENT+",
        refreshToken: userProfile.refreshToken));
  }

  Future<void> studentPlusGooglePresentationIsAvailable() async {
    List<UserInformation> userProfileInfoData =
        await UserGoogleProfile.getUserProfile();

    googleSlidesPresentationBloc.add(SearchStudentPresentationStudentPlus(
      studentPlusDriveFolderId:
          userProfileInfoData[0].studentPlusGoogleDriveFolderId ?? '',
      studentDetails: widget.studentDetails,
    ));
  }
}
