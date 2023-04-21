import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/ui/pbis_plus_class_section/pbis_plus_student_dashbord.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusPBISScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  final int index;
  const StudentPlusPBISScreen(
      {Key? key, required this.studentDetails, required this.index})
      : super(key: key);

  @override
  State<StudentPlusPBISScreen> createState() => _StudentPlusPBISScreenState();
}

class _StudentPlusPBISScreenState extends State<StudentPlusPBISScreen> {
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  final _controller = TextEditingController(); // textController for search
  List<StudentPlusInfoModel> studentInfoList =
      []; // list to show student details
  ValueNotifier<ClassroomStudents> studentValueNotifier =
      ValueNotifier<ClassroomStudents>(ClassroomStudents());
  ValueNotifier<bool> isValueChangeNotice = ValueNotifier<bool>(false);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    studentValueNotifier.value = ClassroomStudents(
        profile: ClassroomProfile(
            emailAddress: widget.studentDetails.emailC ?? '',
            photoUrl: 'default-user',
            helpful: 0,
            engaged: 0,
            niceWork: 0,
            name: ClassroomProfileName(
                fullName:
                    '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
                familyName: widget.studentDetails.lastNameC,
                givenName: widget.studentDetails.firstNameC ?? '')));
    studentInfoList = StudentPlusUtility.createStudentList(
        studentDetails: widget
            .studentDetails); // function to get student details with label
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
              titleIconCode: 0xe883,
            ),
            body: body()),
      ],
    );
  }

  /*--------------------- Main Body ---------------------*/
  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          StudentPlusScreenTitleWidget(
              kLabelSpacing: _kLabelSpacing,
              text: StudentPlusOverrides.studentPBISPageTitle),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
          StudentPlusInfoSearchBar(
            hintText:
                '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
            onTap: () async {
              var result = await pushNewScreen(context,
                  screen: StudentPlusSearchScreen(
                    fromStudentPlusDetailPage: true,
                    studentDetails: widget.studentDetails,
                    index: widget.index,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade);
              if (result == true) {
                Utility.closeKeyboard(context);
              }
            },
            isMainPage: false,
            autoFocus: false,
            controller: _controller,
            kLabelSpacing: _kLabelSpacing,
            focusNode: myFocusNode,
            onItemChanged: null,
          ),
          SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
          pbisDashboardWidget()
        ],
      ),
    );
  }

  /* --------------------- widget to show pbis Dashboard --------------------- */
  Widget pbisDashboardWidget() {
    return PBISPlusStudentDashBoard(
      isValueChangeNotice: isValueChangeNotice,
      isFromStudentPlus: true,
      studentValueNotifier: studentValueNotifier,
      StudentDetailWidget: Column(),
      onValueUpdate: (ValueNotifier<ClassroomStudents> data) {},
      heroTag: '',
      scaffoldKey: scaffoldKey,
    );
  }
}