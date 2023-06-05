import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/user_profile.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_home.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/debouncer.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:Soc/src/widgets/error_widget.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class StudentPlusSearchScreen extends StatefulWidget {
  final bool fromStudentPlusDetailPage;
  final int index;
  final StudentPlusDetailsModel studentDetails;
  const StudentPlusSearchScreen(
      {Key? key,
      required this.fromStudentPlusDetailPage,
      required this.index,
      required this.studentDetails})
      : super(key: key);

  @override
  State<StudentPlusSearchScreen> createState() =>
      _StudentPlusSearchScreenState();
}

class _StudentPlusSearchScreenState extends State<StudentPlusSearchScreen> {
  // used for space between the widgets
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  // search text editing controller
  final _searchController = TextEditingController();
  // hide animated container
  final ValueNotifier<bool> moveToTopNotifier = ValueNotifier<bool>(false);
  // to show and hide recent list
  final ValueNotifier<bool> isRecentList = ValueNotifier<bool>(false);
  // to show error message
  final ValueNotifier<bool> showErrorInSearch = ValueNotifier<bool>(false);
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  double _width = 100;
  double _height = Globals.deviceType == "phone" ? 180 : 450;
  final _deBouncer = Debouncer(milliseconds: 500);
  GoogleDriveBloc googleDriveBloc = GoogleDriveBloc();

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  @override
  void dispose() {
    _studentPlusBloc.close();
    super.dispose();
  }

  initMethod() {
    StudentPlusUtility.setLocked();
    if (widget.fromStudentPlusDetailPage == true) {
      moveToTopNotifier.value = true;
      isRecentList.value = true;
      _height = 0;
      _width = 0;
    } else {
      //It will trigger the drive event to check is that (SOLVED STUDENT+) folder in drive
      //is available or not if not this will create one or the available get the drive folder id
      _checkDriveFolderExistsOrNot();
    }

    /*-------------------------User Activity Track START----------------------------*/
    Utility.updateLogs(
        activityType: 'STUDENT+',
        activityId: '41',
        description: 'Search STUDENT+',
        operationResult: 'Success');

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_search_screen");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_search_screen',
        screenClass: 'StudentPlusSearchScreen');
    /*-------------------------User Activity Track End----------------------------*/
  }

  /* --------------- Things Perform on On changes in search bar --------------- */
  onItemChanged(String value) {
    _deBouncer.run(() {
      if (_searchController.text.length >= 3) {
        isRecentList.value = false;
        showErrorInSearch.value = false;
        _studentPlusBloc
            .add(StudentPlusSearchEvent(keyword: _searchController.text));
      } else {
        isRecentList.value = true;
        showErrorInSearch.value = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: StudentPlusAppBar(
              // refresh: (v) {
              //   setState(() {});
              // },
              ),
          backgroundColor: Colors.transparent,
          body: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                return connected
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: StudentPlusOverrides.kSymmetricPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            animatedContainer(),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: Utility.textWidget(
                                text: StudentPlusOverrides.titleSearchPage,
                                context: context,
                                textTheme:
                                    Theme.of(context).textTheme.headline6,
                              ),
                              minLeadingWidth:
                                  Globals.deviceType == "phone" ? 55 : 65,
                              leading: IconButton(
                                onPressed: () {
                                  //To dispose the snackbar message before navigating back if exist
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  Utility.closeKeyboard(context);

                                  Navigator.pop(context, true);
                                },
                                icon: Icon(
                                  IconData(0xe80d,
                                      fontFamily: Overrides.kFontFam,
                                      fontPackage: Overrides.kFontPkg),
                                  color: AppTheme.kButtonColor,
                                ),
                              ),
                            ),
                            //SpacerWidget(20),
                            searchBarWidget(),
                            validationMessageWidget(),
                            recentSearchHeader(),
                            buildSearchList(),

                            blocListener(),
                          ],
                        ),
                      )
                    : NoInternetErrorWidget(
                        connected: connected,
                        isSplashScreen: false,
                      );
              },
              child: Container()),
        ),
      ],
    );
  }

  /* ------------- widget to fetch student Detail and show loader ------------ */

  Widget blocListener() {
    return BlocListener<StudentPlusBloc, StudentPlusState>(
      bloc: _studentPlusBloc,
      listener: (context, state) async {
        if (state is StudentPlusGetDetailsLoading) {
          Utility.showLoadingDialog(
            context: context,
            isOCR: true,
          );
        } else if (state is StudentPlusInfoSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => StudentPlusHome(
                        studentPlusStudentInfo: state.obj,
                        index: widget.index,
                      )),
              (_) => true);
        }
      },
      child: Container(),
    );
  }

  /* ------------ widget to build search bar according to position ------------ */
  Widget searchBarWidget() {
    return ValueListenableBuilder(
        valueListenable: moveToTopNotifier,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return StudentPlusInfoSearchBar(
            iconOnTap: () {
              _searchController.text = '';
              isRecentList.value = true;
            },
            hintText: StudentPlusOverrides.searchHintText,
            isMainPage: moveToTopNotifier.value,
            autoFocus: widget.fromStudentPlusDetailPage == true
                ? true
                : moveToTopNotifier.value,
            controller: _searchController,
            kLabelSpacing: _kLabelSpacing,
            focusNode: myFocusNode,
            onTap: moveToTopNotifier.value == true
                ? null
                : () {
                    _height = 0;
                    _width = 0;
                    moveToTopNotifier.value = true;
                    isRecentList.value = true;
                  },
            onItemChanged:
                moveToTopNotifier.value == true ? onItemChanged : false,
          );
        });
  }

  /* ---------- Common list view widget to search and recent list ---------- */
  Widget searchResultList({required List<StudentPlusSearchModel> list}) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff162429)
                          : Color(
                              0xffF7F8F9) //Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff111C20)
                          : Color(0xffE9ECEE)),
              child: ListTile(
                onTap: () {
                  if (list[index].id == null || list[index].id == '') {
                    Utility.currentScreenSnackBar(
                        'Unable to get details for ${list[index].firstNameC} ${list[index].lastNameC}',
                        null);
                  } else {
                    StudentPlusUtility.addStudentInfoToLocalDb(
                        studentInfo: list[index]);
                    _studentPlusBloc.add(
                        GetStudentPlusDetails(studentId: list[index].id ?? ''));
                  }
                },
                contentPadding: EdgeInsets.only(left: 20),
                title: Text(
                  "${list[index].firstNameC ?? ''} ${list[index].lastNameC ?? ''}",
                  // context: context,
                  style: Theme.of(context).textTheme.headline5,
                ),
                trailing: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utility.textWidget(
                          text: "${list[index].classC ?? 'NA'}",
                          context: context,
                          textTheme: Theme.of(context).textTheme.headline2),
                      Utility.textWidget(
                          text: StudentPlusOverrides.searchTileStaticWord,
                          context: context,
                          textTheme: Theme.of(context).textTheme.subtitle2)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  /* ----------------------- Widget To show recent list ----------------------- */
  Widget _buildRecentSearchStudentList() {
    return FutureBuilder(
        future: StudentPlusUtility.getRecentStudentSearchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data.length == 0) {
              isRecentList.value =
                  false; // Condition to show and hide recent header in case of no list
            } else {
              isRecentList.value = true;
            }
            return snapshot.data != null && snapshot.data.length > 0
                ? searchResultList(list: snapshot.data)
                : EmptyContainer();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                    child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppTheme.kButtonColor,
                )),
              ),
            );
          } else
            return Scaffold();
        });
  }

  /* ------------------ widget to return recent search header ----------------- */
  Widget recentSearchHeader() {
    return ValueListenableBuilder(
        valueListenable: isRecentList,
        child: Container(),
        builder: (BuildContext context, bool value, Widget? child) {
          return isRecentList.value == true
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Utility.textWidget(
                    text: StudentPlusOverrides.recentSearchHeader,
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.w100),
                  ),
                )
              : Container();
        });
  }

  /* ------------------ widget to hide and show the container ----------------- */
  Widget animatedContainer() {
    return ValueListenableBuilder(
        valueListenable: moveToTopNotifier,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
            height: _height,
            width: _width,
          );
        });
  }

  /* ----------- Widget to show error related to maximum three digit ---------- */
  Widget validationMessageWidget() {
    return ValueListenableBuilder(
        valueListenable: showErrorInSearch,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return showErrorInSearch.value == true
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Utility.textWidget(
                      text: StudentPlusOverrides.errorMessageOnSearchPage,
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.red)),
                )
              : Container();
        });
  }

  /* ---------- widget To build main list (search list / recent list) --------- */
  Widget buildSearchList() {
    return ValueListenableBuilder(
        valueListenable: isRecentList,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return isRecentList.value == true
              ? _buildRecentSearchStudentList()
              : _buildSearchStudentResultList();
        });
  }

  Widget _buildSearchStudentResultList() {
    return ValueListenableBuilder(
        valueListenable: moveToTopNotifier,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return moveToTopNotifier.value == true
              ? BlocBuilder<StudentPlusBloc, StudentPlusState>(
                  bloc: _studentPlusBloc,
                  builder: (BuildContext contxt, StudentPlusState state) {
                    if (state is StudentPlusLoading) {
                      return Expanded(
                        // height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppTheme.kButtonColor,
                            ),
                          ),
                        ),
                      );
                    } else if (state is StudentPlusSearchSuccess) {
                      return state.obj.length > 0
                          ? searchResultList(list: state.obj)
                          : Expanded(
                              child: NoDataFoundErrorWidget(
                                marginTop:
                                    MediaQuery.of(context).size.height * 0.15,
                                isResultNotFoundMsg: false,
                                isNews: false,
                                isEvents: false,
                                isSearchpage: true,
                              ),
                            );
                    } else if (state is StudentPlusErrorReceived) {
                      return ErrorMsgWidget(
                        isStudentSearch: true,
                      );
                    }
                    return Container();
                  },
                )
              : Container();
        });
  }

  void _checkDriveFolderExistsOrNot() async {
    //FOR STUDENT PLUS

    StudentPlusOverrides.studentPlusGoogleDriveFolderId = '';
    StudentPlusOverrides.studentPlusGoogleDriveFolderPath = '';

    //this is get the user profile details
    final List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    final UserInformation userProfile = _profileData[0];

    print("callig the the event to check the folder available or not ");

    //It will trigger the drive event to check is that (SOLVED STUDENT+) folder in drive
    //is available or not if not this will create one or the available get the drive folder id
    googleDriveBloc.add(GetDriveFolderIdEvent(
        fromGradedPlusAssessmentSection: false,
        isReturnState: false,
        token: userProfile.authorizationToken,
        folderName: "SOLVED STUDENT+",
        refreshToken: userProfile.refreshToken));
  }
}
