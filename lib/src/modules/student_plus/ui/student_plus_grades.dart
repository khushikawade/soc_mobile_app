import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bouncing_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusGradesPage extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
 
  const StudentPlusGradesPage(
      {Key? key, required this.studentDetails})
      : super(key: key);

  @override
  State<StudentPlusGradesPage> createState() => individual();
}

class individual extends State<StudentPlusGradesPage> {
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  final _controller = TextEditingController(); // textController for search
  final ValueNotifier<int> selectedValue = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: StudentPlusAppBar(
            titleIconCode: 0xe883,
            // refresh: (v) {
            //   setState(() {});
            // },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: StudentPlusOverrides.kSymmetricPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                StudentPlusScreenTitleWidget(
                    kLabelSpacing: _kLabelSpacing,
                    text: StudentPlusOverrides.studentGradesPageTitle),
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding),
                StudentPlusInfoSearchBar(
                  hintText:
                      '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
                  onTap: () async {
                    var result = await pushNewScreen(context,
                        screen: StudentPlusSearchScreen(
                          fromStudentPlusDetailPage: true,
                          index:3,
                          studentDetails: widget.studentDetails
                          
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
                gradesChipListWidget(), // widget to grades chip List
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
                SpacerWidget(_kLabelSpacing / 2),
                HeaderTitle(), // widget to show header of list
                SpacerWidget(StudentPlusOverrides.kSymmetricPadding / 2),
                gradesListSectionWidget() // widget to show grades class wise
              ],
            ),
          ),
        ),
      ],
    );
  }

  /* ------------------ Widget to show grades horizontal list ------------------ */
  Widget gradesChipListWidget() {
    return Container(
      height: _kLabelSpacing * 1.8,
      padding: EdgeInsets.symmetric(horizontal: _kLabelSpacing / 2),
      child: ListView.builder(
        controller: null,
        itemBuilder: (BuildContext context, int index) {
          return gradesChip(context, index);
        },
        itemCount: gradeList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /* ---------------- Widget to show individual chips of grades ---------------- */
  Widget gradesChip(
    context,
    currentIndex,
  ) {
    return ValueListenableBuilder(
        valueListenable: selectedValue,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return GestureDetector(
            onTap: () {
              selectedValue.value = currentIndex;
            },
            child: Bouncing(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  boxShadow: [],
                  color: //Colors.transparent,
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color(0xffF7F8F9)
                          : Color(0xff111C20),
                  border: Border.all(
                      color: selectedValue.value == currentIndex
                          ? AppTheme.kSelectedColor
                          : Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Utility.textWidget(
                        text: gradeList[currentIndex],
                        context: context,
                        textTheme: Theme.of(context).textTheme.headline4)),
              ),
            ),
          );
        });
  }

  /* ---------- Widget to show vertical list of class and grade list ---------- */
  Widget gradesListSectionWidget() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
        scrollDirection: Axis.vertical,
        itemCount: gradeDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(index, context);
        },
      ),
    );
  }

  /* ---------- Widget to show list tile (to show individual grades) ---------- */
  Widget _buildList(int index, context) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? AppTheme.klistTilePrimaryDark
                  : AppTheme
                      .klistTilePrimaryLight //Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background == Color(0xff000000)
                  ? AppTheme.klistTileSecoandryDark
                  : AppTheme
                      .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
          ),
      child: ListTile(
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Utility.textWidget(
              text: gradeDataList[index].label,
              maxLines: 2,
              context: context,
              textTheme: Theme.of(context).textTheme.headline2!),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
              vertical: _kLabelSpacing / 4, horizontal: _kLabelSpacing / 2),
          decoration: BoxDecoration(
            color: AppTheme.kButtonColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Utility.textWidget(
              text: gradeDataList[index].value,
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  /* ------------------- widget to show title of grades list ------------------ */
  Widget HeaderTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 50.0,
            margin: const EdgeInsets.only(bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Theme.of(context).backgroundColor == Color(0xff000000)
                  ? Color(0xff162429)
                  : Color(0xffF7F8F9),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  offset: Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Container(
                child: ListTile(
              leading: Utility.textWidget(
                  text: StudentPlusOverrides.gradesTitleLeft,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
              trailing: Utility.textWidget(
                  text: StudentPlusOverrides.gradesTitleRight,
                  context: context,
                  textTheme: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.bold)),
            )),
          ),
        ),
      ),
    );
  }

  List<String> gradeList = ['First', 'Second', 'Third', 'Fourth'];
  List<StudentPlusInfoModel> gradeDataList = [
    StudentPlusInfoModel(label: "Math", value: "62"),
    StudentPlusInfoModel(label: "Science", value: "95"),
    StudentPlusInfoModel(label: "ELA", value: "78"),
  ];
}
