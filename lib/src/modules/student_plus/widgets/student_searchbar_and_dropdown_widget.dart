import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_family_student_list.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusSearchBarAndDropdown extends StatefulWidget {
  final String sectionType;
  final StudentPlusDetailsModel studentDetails;
  final int index;
  const StudentPlusSearchBarAndDropdown(
      {Key? key, required this.sectionType, required this.studentDetails,required this.index})
      : super(key: key);

  @override
  State<StudentPlusSearchBarAndDropdown> createState() =>
      _StudentPlusSearchBarAndDropdownState();
}

class _StudentPlusSearchBarAndDropdownState
    extends State<StudentPlusSearchBarAndDropdown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.sectionType == "Family") {
          showModalBottomSheet(
            useRootNavigator: true,
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(42),
                topRight: Radius.circular(42),
              ),
            ),
            builder: (_) => LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return StudentPlusFamilyStudentList(
                height: MediaQuery.of(context).size.height * 0.4, //0.45,
                currentIndex: widget.index,
              );
            }),
          );
        } else {
          var result = await pushNewScreen(context,
              screen: StudentPlusSearchScreen(
                  fromStudentPlusDetailPage: true,
                  index: widget.index,
                  studentDetails: widget.studentDetails),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.fade);
          if (result == true) {
            Utility.closeKeyboard(context);
          }
        }
      },
      child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.symmetric(vertical: 20 / 3, horizontal: 20 / 3.5),
          child: Card(
            color: Color(0xff000000) != Theme.of(context).backgroundColor
                ? Theme.of(context).colorScheme.secondary
                : Color.fromARGB(255, 12, 20, 23),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                    Icon(
                        widget.sectionType == "Family"
                            ? Icons.arrow_drop_down_circle_sharp
                            : IconData(0xe805,
                                fontFamily: Overrides.kFontFam,
                                fontPackage: Overrides.kFontPkg),
                        color: Theme.of(context).colorScheme.primaryVariant,
                        size: Globals.deviceType == "phone" ? 20 : 28)
                  ]),
            ),
          )),
    );
  }
}
