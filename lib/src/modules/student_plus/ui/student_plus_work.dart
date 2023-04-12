import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_work_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/scree_title_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/image_popup.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusWorkScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  const StudentPlusWorkScreen({Key? key, required this.studentDetails})
      : super(key: key);

  @override
  State<StudentPlusWorkScreen> createState() => _StudentPlusWorkScreenState();
}

class _StudentPlusWorkScreenState extends State<StudentPlusWorkScreen> {
  // Used for space between the  widget
  static const double _kLabelSpacing = 20.0;

  // controller used for search page
  final _controller = TextEditingController();

  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  FocusNode myFocusNode = new FocusNode();

  @override
  void initState() {
    _studentPlusBloc.add(
        FetchStudentWorkEvent(studentId: widget.studentDetails.studentIdC));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: StudentPlusAppBar(
              titleIconCode: 0xe885,
              isWorkPage: true,
              refresh: (v) {
                setState(() {});
              },
            ),
            body: body()),
      ],
    );
  }

/* ------------------------ Main Body ----------------------- */
  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          StudentPlusScreenTitleWidget(
              kLabelSpacing: _kLabelSpacing,
              text: StudentPlusOverrides.studentPlusWorkTitle),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          StudentPlusInfoSearchBar(
            hintText:
                '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
            isMainPage: false,
            autoFocus: false,
            onTap: () {
              pushNewScreen(
                context,
                screen: StudentPlusSearchScreen(
                  fromStudentPlusDetailPage: true,
                ),
                withNavBar: false,
              );
            },
            controller: _controller,
            kLabelSpacing: _kLabelSpacing,
            focusNode: myFocusNode,
          ),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          listViewWidget(),
          SpacerWidget(20)
        ],
      ),
    );
  }

  /* ------------------------ widget to build work list ----------------------- */
  Widget listViewWidget() {
    return BlocBuilder<StudentPlusBloc, StudentPlusState>(
      bloc: _studentPlusBloc,
      builder: (BuildContext contxt, StudentPlusState state) {
        if (state is StudentPlusLoading) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              alignment: Alignment.center,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppTheme.kButtonColor,
              ));
        } else if (state is StudentPlusWorkSuccess) {
          return state.obj.length > 0
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: state.obj.length, // studentWorkList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return studentWorkTile(
                          studentWorkModel: state.obj[index], index: index);
                    },
                  ),
                )
              : Expanded(
                  child: NoDataFoundErrorWidget(
                    errorMessage: StudentPlusOverrides.studentWorkErrorMessage,
                    //  marginTop: 0,
                    isResultNotFoundMsg: false,
                    isNews: false,
                    isEvents: false,
                    isSearchpage: true,
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  /* ----------------- widget to show work detail in listTile ----------------- */
  Widget studentWorkTile(
      {required StudentPlusWorkModel studentWorkModel, required int index}) {
    return InkWell(
      onTap: () {
        if (studentWorkModel.assessmentImageC == null ||
            studentWorkModel.assessmentImageC == '') {
          Utility.currentScreenSnackBar(
              StudentPlusOverrides.studentWorkSnackbar, null,
              marginFromBottom: 120);
        } else {
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (_) =>
                  ImagePopup(imageURL: studentWorkModel.assessmentImageC!));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff162429)
                    : Color(
                        0xffF7F8F9) //Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff111C20)
                    : Color(0xffE9ECEE)),
        child: Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width * 0.25) - 20,
              child: CircleAvatar(
                backgroundColor: AppTheme.kButtonColor,
                radius: MediaQuery.of(context).size.width * 0.065,
                child: CircleAvatar(
                  backgroundColor: (index % 2 == 0)
                      ? Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff162429)
                          : Color(
                              0xffF7F8F9) //Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background ==
                              Color(0xff000000)
                          ? Color(0xff111C20)
                          : Color(0xffE9ECEE),
                  radius: MediaQuery.of(context).size.width * 0.060,
                  child: Utility.textWidget(
                      text:
                          "${studentWorkModel.resultC!}/${StudentPlusUtility.getMaxPointPossible(rubric: studentWorkModel.rubricC ?? '')}",
                      context: context,
                      textAlign: TextAlign.center,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(
                              color: AppTheme.kButtonColor,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utility.textWidget(
                      text: studentWorkModel.nameC!,
                      context: context,
                      textTheme: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    height: 5,
                  ),
                  Utility.textWidget(
                      context: context,
                      textTheme: Theme.of(context).textTheme.subtitle2,
                      text:
                          "${Utility.convertDateUSFormat(studentWorkModel.dateC)}  |  ${studentWorkModel.teacherEmail!.split('@')[0]}"),
                ],
              ),
            ),
            Container(
                width: (MediaQuery.of(context).size.width * 0.25) - 20,
                //  color: Colors.yellow,0xe88c
                child: Icon(
                  IconData(0xe88c,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                  // size: 20,
                  color: Theme.of(context).colorScheme.background ==
                          Color(0xff000000)
                      ? Color(0xffF7F8F9)
                      : Color(0xff162429),
                ))
          ],
        ),
      ),
    );
  }
}
