import 'package:Soc/src/modules/graded_plus/widgets/common_fab.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_background_img_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_login_common_widget.dart';
import 'package:Soc/src/modules/student_plus/ui/family_ui/family_student_plus_list.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_home.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPlusFamilyLogInSuccess extends StatefulWidget {
  final String token;
  final String email;
  StudentPlusFamilyLogInSuccess({Key? key, required this.token,required this.email})
      : super(key: key);

  @override
  State<StudentPlusFamilyLogInSuccess> createState() =>
      _StudentPlusFamilyLogInSuccessState();
}

class _StudentPlusFamilyLogInSuccessState
    extends State<StudentPlusFamilyLogInSuccess> {
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();
  bool isLoading = false;

  @override
  void initState() {
    _studentPlusBloc.add(GetStudentListFamilyLogin(
       ));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: FamilyLoginCommonWidget.familyLoginAppBar(
              context: context, isBackButton: false),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SpacerWidget(MediaQuery.of(context).size.height * 0.2),
                FamilyLoginCommonWidget.familyCircularIcon(
                    context: context,
                    assetImageUrl: 'assets/images/success_lock.png'),
                SpacerWidget(MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: Utility.textWidget(
                      context: context,
                      textAlign: TextAlign.center,
                      text: 'Your account has been verified successfully.',
                      textTheme: Theme.of(context).textTheme.headline6),
                ),
                SpacerWidget(MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
          floatingActionButton: fabButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }

  /* ----------------------------- widget to show generate otp button ----------------------------- */
  Widget fabButton() {
    return BlocConsumer(
      bloc: _studentPlusBloc,
      builder: (context, state) {
        return GradedPlusCustomFloatingActionButton(
          isExtended: true,
          fabWidth: MediaQuery.of(context).size.width * 0.7,
          title: 'Get Started',
          onPressed: () async {
            if (state is StudentPlusSearchSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => StudentPlusHome(
                            sectionType: "Family",
                            studentPlusStudentInfo: StudentPlusDetailsModel(
                                studentIdC: state.obj[0].studentIDC,
                                firstNameC: state.obj[0].firstNameC,
                                lastNameC: state.obj[0].lastNameC,
                                classC: state.obj[0].classC),
                            index: 0,
                            //   index: widget.index,
                          )),
                  (_) => true);
            } else {
              isLoading = true;
              Utility.showLoadingDialog(
                context: context,
                isOCR: true,
              );
            }
          },
        );
      },
      listener: (context, state) {
        if (state is StudentPlusSearchSuccess && isLoading) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => StudentPlusHome(
                        sectionType: "Family",
                        studentPlusStudentInfo: StudentPlusDetailsModel(
                            studentIdC: state.obj[0].studentIDC,
                            firstNameC: state.obj[0].firstNameC,
                            lastNameC: state.obj[0].lastNameC,
                            classC: state.obj[0].classC),
                        index: 0,
                        //   index: widget.index,
                      )),
              (_) => true);
        }
      },
    );
  }
}
