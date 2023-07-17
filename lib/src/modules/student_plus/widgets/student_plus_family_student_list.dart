import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/bloc/student_plus_bloc.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_search_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_home.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class StudentPlusFamilyStudentList extends StatefulWidget {
  final double height;
  final int currentIndex;
  StudentPlusFamilyStudentList(
      {Key? key, this.height = 150, required this.currentIndex})
      : super(key: key);

  @override
  State<StudentPlusFamilyStudentList> createState() =>
      _StudentPlusFamilyStudentListState();
}

class _StudentPlusFamilyStudentListState
    extends State<StudentPlusFamilyStudentList> {
  final StudentPlusBloc _studentPlusBloc = StudentPlusBloc();

  // double _progress;
  @override
  void initState() {
    _studentPlusBloc.add(GetStudentListFamilyLogin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Color(0xffF7F8F9)
                : Color(0xff111C20),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        height: widget.height,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: StudentPlusOverrides.kSymmetricPadding * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 16),
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
                ),
              ),
              PlusScreenTitleWidget(
                kLabelSpacing: 20,
                text: 'Select Student',
              ),
              SpacerWidget(10),
              blocBuilder(),
              // _buildList(1, context, 'Subject'),
              // _buildList(0, context, 'Teachers'),
            ],
          ),
        ));
  }

  /* ---------------------------------- bloc builder to show list --------------------------------- */

  Widget blocBuilder() {
    return BlocBuilder<StudentPlusBloc, StudentPlusState>(
      builder: (context, state) {
        if (state is FamilyLoginLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (state is StudentPlusSearchSuccess) {
          return studentList(list: state.obj);
        } else {
          return Container();
        }
      },
      bloc: _studentPlusBloc,
    );
  }

  /* ---------- Common list view widget to search and recent list ---------- */
  Widget studentList({required List<StudentPlusSearchModel> list}) {
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
                  if (list[index].studentIDC == null ||
                      list[index].studentIDC == '') {
                    Utility.currentScreenSnackBar(
                        'Unable to get details for ${list[index].firstNameC} ${list[index].lastNameC}',
                        null);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => StudentPlusHome(
                                  sectionType: "Family",
                                  studentPlusStudentInfo:
                                      StudentPlusDetailsModel(
                                          studentIdC: list[index].studentIDC,
                                          firstNameC: list[index].firstNameC,
                                          lastNameC: list[index].lastNameC,
                                          classC: list[index].classC),
                                  index: widget.currentIndex,
                                  //   index: widget.index,
                                )),
                        (_) => true);
                  }
                },
                contentPadding: EdgeInsets.only(left: 20),
                title: Text(
                  "${list[index].firstNameC ?? ''} ${list[index].lastNameC ?? ''}",
                  style: Theme.of(context).textTheme.headline1,
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
}
