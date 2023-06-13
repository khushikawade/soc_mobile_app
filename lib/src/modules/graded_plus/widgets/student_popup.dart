import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

import '../../../services/local_database/local_db.dart';
import '../../../translator/translation_widget.dart';

class NonCourseGoogleClassroomStudentPopup extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  List<StudentAssessmentInfo> notPresentStudentsInSelectedClass;
  LocalDatabase<StudentAssessmentInfo> studentInfoDb;
  final VoidCallback onTapCallback;
  final String? message;
  NonCourseGoogleClassroomStudentPopup(
      {Key? key,
      required this.title,
      this.titleStyle,
      required this.notPresentStudentsInSelectedClass,
      required this.studentInfoDb,
      required this.onTapCallback,
      this.message})
      : super(key: key);
  @override
  NonCourseGoogleClassroomStudentPopupState createState() =>
      NonCourseGoogleClassroomStudentPopupState();
}

class NonCourseGoogleClassroomStudentPopupState
    extends State<NonCourseGoogleClassroomStudentPopup> {
  ValueNotifier<List<StudentAssessmentInfo>>
      notPresentStudentsInSelectedClassValueNotifier =
      ValueNotifier<List<StudentAssessmentInfo>>([]);

  @override
  void initState() {
    // Call the superclass initState() method.
    super.initState();

    notPresentStudentsInSelectedClassValueNotifier.value =
        widget.notPresentStudentsInSelectedClass;
  }

  void closeDialog() {
    // Close the dialog from inside
    Navigator.of(context).pop();
  }

  Future removeStudentFromList(
      {required var student,
      required List<StudentAssessmentInfo>
          notPresentStudentsInSelectedClass}) async {
    try {
      List<StudentAssessmentInfo> studentInfo =
          await widget.studentInfoDb.getData();

//       int indexToRemoveFromStudentDB =
//           studentInfo.indexWhere((e) => e.studentId == student.studentId);
//       if (indexToRemoveFromStudentDB != -1) {
//         // removing student from local db
//         await widget.studentInfoDb.deleteAt(indexToRemoveFromStudentDB);
//       }
// // removing stuednt from present list
//       notPresentStudentsInSelectedClass
//           .removeWhere((s) => s.studentId == student.studentId);
// //updating the valuenotifier with new values
//       notPresentStudentsInSelectedClassValueNotifier.value =
//           notPresentStudentsInSelectedClass;
//       ;

      // removing student from local db
      int indexToRemoveFromStudentDB =
          studentInfo.indexWhere((e) => e.studentId == student.studentId);

      // removing stuednt from present list
      int indexToRemoveFromCureentList = notPresentStudentsInSelectedClass
          .indexWhere((e) => e.studentId == student.studentId);

      if ((indexToRemoveFromCureentList != -1
          //  &&
          //         notPresentStudentsInSelectedClass.length > 1
          ) &&
          (indexToRemoveFromStudentDB != -1 && studentInfo.length > 1)) {
        print(indexToRemoveFromCureentList);
        // removing student from local db
        await widget.studentInfoDb.deleteAt(
            indexToRemoveFromStudentDB); // removing stuednt from present list

        notPresentStudentsInSelectedClass
            .removeAt(indexToRemoveFromCureentList);
      } else {
        Utility.currentScreenSnackBar(
            'Action Not Performed. Student List Cannot Be Empty.', null,
            marginFromBottom: 90);
      }
    } catch (e) {
      //updating the valuenotifier with new values
      notPresentStudentsInSelectedClassValueNotifier.value =
          notPresentStudentsInSelectedClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor:
          Theme.of(context).colorScheme.background == Color(0xff000000)
              ? Color(0xff162429)
              : null,
      title: Column(
        children: [
          TranslationWidget(
              message: widget.title,
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) {
                return Text(translatedMessage.toString(),
                    textAlign: TextAlign.center,
                    style: widget.titleStyle ??
                        Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: AppTheme.kButtonColor));
              }),
          if (widget.message != null)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TranslationWidget(
                  message: widget.message,
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) {
                    return Text(
                      translatedMessage.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(),
                    );
                  }),
            ),
        ],
      ),
      content: _buildContentWidget(
        notPresentStudentsInSelectedClass:
            widget.notPresentStudentsInSelectedClass,
      ),
      actions: actionButtonWidget(
        title: "Continue",
      ),
    );
  }

  Widget _buildContentWidget({
    required List<StudentAssessmentInfo> notPresentStudentsInSelectedClass,
  }) {
    return ValueListenableBuilder(
        valueListenable: notPresentStudentsInSelectedClassValueNotifier,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.3,
            child: notPresentStudentsInSelectedClassValueNotifier
                        ?.value?.isEmpty ??
                    true
                ? Center(
                    child: Utility.textWidget(
                        context: context,
                        text:
                            "You have removed all the students not belong to the selected course.",
                        textAlign: TextAlign.center,
                        textTheme: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith()
                            .copyWith(fontWeight: FontWeight.bold)),
                  )
                : ListView.builder(
                    itemCount: notPresentStudentsInSelectedClassValueNotifier
                        .value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        subtitle: Utility.textWidget(
                            context: context,
                            text: notPresentStudentsInSelectedClassValueNotifier
                                .value[index].studentId!,
                            textTheme: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontSize: 10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        title: Utility.textWidget(
                            context: context,
                            text: notPresentStudentsInSelectedClassValueNotifier
                                .value[index].studentName!,
                            textTheme: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold)),
                        trailing: Container(
                          child: Tooltip(
                            message:
                                'Remove ${notPresentStudentsInSelectedClassValueNotifier.value[index].studentName!}',
                            child: OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.red,
                                    width: Globals.deviceType == "phone"
                                        ? 1.5
                                        : 2.5,
                                    style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await removeStudentFromList(
                                  student:
                                      notPresentStudentsInSelectedClassValueNotifier
                                          .value[index],
                                  notPresentStudentsInSelectedClass: List<
                                          StudentAssessmentInfo>.from(
                                      notPresentStudentsInSelectedClassValueNotifier
                                          .value),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                    Globals.deviceType == "phone" ? 4.0 : 10.0),
                                child: TranslationWidget(
                                  message: "Remove",
                                  toLanguage: Globals.selectedLanguage,
                                  fromLanguage: "en",
                                  builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.red,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }

  List<Widget> actionButtonWidget({
    required String title,
  }) {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          widget.onTapCallback();
        },
        child: Utility.textWidget(
            context: context,
            text: title.toString(),
            textTheme: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
    ];
  }
}
