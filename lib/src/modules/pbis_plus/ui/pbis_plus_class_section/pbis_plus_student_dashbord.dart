import 'package:Soc/src/modules/pbis_plus/modal/pbis_course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_circular_profile_name.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PBISPlusStudentDashBoard extends StatefulWidget {
  final ValueNotifier<ClassroomStudents> studentValueNotifier;
  final String heroTag;
  // final String imageUrl;
  final Column StudentDetailWidget;
  final Function(ValueNotifier<ClassroomStudents>) onValueUpdate;
  ValueNotifier<bool> isValueChangeNotice = ValueNotifier<bool>(false);

  PBISPlusStudentDashBoard(
      {Key? key,
      required this.heroTag,
      // required this.imageUrl,
      required this.studentValueNotifier,
      required this.StudentDetailWidget,
      required this.onValueUpdate,
      required this.isValueChangeNotice})
      : super(key: key);

  @override
  State<PBISPlusStudentDashBoard> createState() =>
      _PBISPlusStudentDashBoardState();
}

class _PBISPlusStudentDashBoardState extends State<PBISPlusStudentDashBoard> {
  final double profilePictureSize = 45;
  final double circleSize = 35;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PBISPlusAppBar(
            title: "Dashboard",
            backButton: true,
          ),
          body: body(context),
          floatingActionButton: floatingActionButton(
            context,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: widget.heroTag,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(16, 40, 16, 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.kButtonColor,
                        Theme.of(context).backgroundColor
                      ],
                      stops: [
                        0.6,
                        0.5,
                      ],
                    ),
                  ),
                  child: FittedBox(
                      child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: widget.StudentDetailWidget))

                  //  Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: <Widget>[
                  //     SpacerWidget(50),
                  //     Text(
                  //       widget.student['profile']['name']['fullName'],
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .subtitle1!
                  //           .copyWith(fontWeight: FontWeight.bold),
                  //     ),
                  //     SpacerWidget(20),
                  //     Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 20),
                  //         height: 40,
                  //         width: MediaQuery.of(context).size.width * 0.7,
                  //         child: widget.row)
                  //   ],
                  // ),
                  ),
              Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(
                    //   color:
                    //       Color(0xff000000) == Theme.of(context).backgroundColor
                    //           ? Color(0xffF7F8F9)
                    //           : Color(0xff111C20),
                    //   width: 2,
                    // ),
                  ),
                  child: widget.studentValueNotifier.value!.profile!.photoUrl!
                          .contains('default-user')
                      ? PBISCircularProfileName(
                          firstLetter: widget.studentValueNotifier.value
                              .profile!.name!.givenName!
                              .substring(0, 1),
                          lastLetter: widget.studentValueNotifier.value.profile!
                              .name!.familyName!
                              .substring(0, 1),
                          profilePictureSize: profilePictureSize,
                        )
                      : PBISCommonProfileWidget(
                          profilePictureSize: profilePictureSize,
                          imageUrl: widget
                              .studentValueNotifier.value!.profile!.photoUrl!),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.03,
                right: MediaQuery.of(context).size.width * 0.33,
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xffF7F8F9)
                            : Color(0xff111C20),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: widget.isValueChangeNotice,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return ValueListenableBuilder<ClassroomStudents>(
                                  valueListenable: widget.studentValueNotifier,
                                  builder: (BuildContext context,
                                      ClassroomStudents value, Widget? child) {
                                    return Text(
                                      PBISPlusUtility.numberAbbreviationFormat(
                                          widget.studentValueNotifier.value!
                                                  .profile!.engaged! +
                                              widget.studentValueNotifier.value!
                                                  .profile!.niceWork! +
                                              widget.studentValueNotifier.value!
                                                  .profile!.helpful!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    );
                                  });
                            })),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 0.43,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            // color: Theme.of(context).backgroundColor,
            // border: Border.all(
            //   color: Color(0xff000000) == Theme.of(context).backgroundColor
            //       ? Color(0xffF7F8F9)
            //       : Color(0xff111C20),
            //   width: 0.5,
            // ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FittedBox(child: _buildDataTable()),
          ),
        ),
      ],
    );
  }

  DataTable _buildDataTable() => DataTable(
        headingRowHeight: 90,
        dataRowHeight: 60,
        dataTextStyle: Theme.of(context).textTheme.headline2,
        showBottomBorder: false,
        headingTextStyle: Theme.of(context)
            .textTheme
            .headline2!
            .copyWith(fontWeight: FontWeight.bold),
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => Color.fromRGBO(50, 52, 67, 1)),
        dividerThickness: 5.0,
        border: TableBorder(
          horizontalInside: BorderSide(
            width: 2.0,
            color: Colors.white,
          ),
          // verticalInside: BorderSide(
          //   width: 1.0,
          //   color: Colors.grey,
          // ),
        ),
        // TableBorder.all(
        //   color: Colors.white,
        //   width: 3.0,
        //   borderRadius: BorderRadius.circular(5),
        //   style: BorderStyle.solid,
        // ),
        columns: PBISPlusDataTableModal.PBISPlusDataTableHeadingRaw.map(
            (PBISPlusDataTableModal item) {
          return buildDataColumn(item);
        }).toList(),
        rows: List<DataRow>.generate(
            PBISPlusOverrides.data.length, (index) => buildDataRow(index)),
      );

  DataColumn buildDataColumn(PBISPlusDataTableModal item) => DataColumn(
          label: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.iconData,
            color: item.color,
            size: 35,
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Utility.textWidget(
            context: context,
            text: item.title,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ));

  DataRow buildDataRow(int index) => DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Theme.of(context).backgroundColor; // Use the default value.
        }),
        cells: [
          DataCell(Utility.textWidget(
            text: PBISPlusOverrides.data[index]['Date'].toString(),
            context: context,
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: PBISPlusOverrides.data[index]['Engaged'].toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: PBISPlusOverrides.data[index]['Nice Work'].toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(Utility.textWidget(
            context: context,
            text: PBISPlusOverrides.data[index]['Helpful'].toString(),
            textAlign: TextAlign.center,
            textTheme: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          )),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                boxShadow: [],
                color: Color.fromRGBO(148, 148, 148, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utility.textWidget(
                    context: context,
                    text: PBISPlusUtility.numberAbbreviationFormat(
                        PBISPlusOverrides.data[index]['Total']),
                    textAlign: TextAlign.center,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  Widget floatingActionButton(
    BuildContext context,
  ) =>
      PBISPlusCustomFloatingActionButton(
        onPressed: () {
          _modalBottomSheetMenu();
        },
      );

  void _modalBottomSheetMenu() => showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        // animationCurve: Curves.easeOutQuart,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return PBISPlusBottomSheet(
            googleClassroomCourseworkList: [], //No list is required since no list os used from this bottomsheet
            content: false,
            height: 100,
            title: '',
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
          );
        },
      );
}
