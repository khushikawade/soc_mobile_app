import 'package:Soc/src/modules/pbis_plus/modal/course_modal.dart';
import 'package:Soc/src/modules/pbis_plus/modal/pbis_plus_action_interaction_modal.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_plus_utility.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/custom_rect_tween.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_appbar.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_bottom_sheet.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_fab.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_student_profile_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';

class PBISPlusStudentDashBoard extends StatefulWidget {
  final ValueNotifier<ClassroomStudents> studentValueNotifier;
  final String heroTag;
  // final String imageUrl;
  final Column StudentDetailWidget;

  PBISPlusStudentDashBoard(
      {Key? key,
      required this.heroTag,
      // required this.imageUrl,
      required this.studentValueNotifier,
      required this.StudentDetailWidget})
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
              FloatingActionButtonLocation.miniEndFloat,
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
                  height: MediaQuery.of(context).size.height * 0.21,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 20),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color:
                    //       Color(0xff000000) == Theme.of(context).backgroundColor
                    //           ? Color(0xffF7F8F9)
                    //           : Color(0xff111C20),
                    //   width: 0.5,
                    // ),
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
                  child: FittedBox(child: widget.StudentDetailWidget)

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
                  child: CommonProfileWidget(
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
                      child: Text(
                        PBISPlusUtility.numberAbbreviationFormat(
                            widget.studentValueNotifier.value!.profile!.like! +
                                widget.studentValueNotifier.value!.profile!
                                    .thanks! +
                                widget.studentValueNotifier.value!.profile!
                                    .helpful!),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
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
        headingRowHeight: 80,
        dataTextStyle: Theme.of(context).textTheme.headline2,
        headingTextStyle: Theme.of(context)
            .textTheme
            .headline2!
            .copyWith(fontWeight: FontWeight.bold),
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => Color.fromRGBO(50, 52, 67, 1)),
        dividerThickness: 3.0,
        border: TableBorder.all(
          color: Colors.grey,
          width: 1.0,
          borderRadius: BorderRadius.circular(5),
          style: BorderStyle.solid,
        ),
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
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            item.title,
          ),
        ],
      ));

  DataRow buildDataRow(int index) => DataRow(
        cells: [
          DataCell(Text(PBISPlusOverrides.data[index]['Date'].toString())),
          DataCell(Text(PBISPlusOverrides.data[index]['Engaged'].toString())),
          DataCell(Text(PBISPlusOverrides.data[index]['Nice Work'].toString())),
          DataCell(Text(PBISPlusOverrides.data[index]['Helpful'].toString())),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                boxShadow: [],
                color: Color.fromRGBO(148, 148, 148, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(PBISPlusUtility.numberAbbreviationFormat(
                      PBISPlusOverrides.data[index]['Total']))
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
            content: false,
            height: 100,
            title: '',
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
          );
        },
      );
}
