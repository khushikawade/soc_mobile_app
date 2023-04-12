// ignore_for_file: deprecated_member_use

import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/widgets/pbis_plus_background_img.dart';
import 'package:Soc/src/modules/student_plus/model/student_plus_info_model.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_bottomsheet.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/ui/student_plus_search_page.dart';
import 'package:Soc/src/modules/student_plus/widgets/common_graph_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/scree_title_widget.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_app_bar.dart';
import 'package:Soc/src/modules/student_plus/widgets/student_plus_search_bar.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_utility.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class StudentPlusExamsScreen extends StatefulWidget {
  final StudentPlusDetailsModel studentDetails;
  const StudentPlusExamsScreen({Key? key, required this.studentDetails})
      : super(key: key);

  @override
  State<StudentPlusExamsScreen> createState() => _StudentPlusExamsScreenState();
}

class _StudentPlusExamsScreenState extends State<StudentPlusExamsScreen> {
  static const double _kLabelSpacing = 20.0;
  final _controller = TextEditingController();
  FocusNode myFocusNode = new FocusNode();

  @override
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
            appBar: StudentPlusAppBar(
              refresh: (v) {
                setState(() {});
              },
              titleIconCode: 0xe881,
            ),
            body: body()),
      ],
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: StudentPlusOverrides.kSymmetricPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentPlusScreenTitleWidget(
              kLabelSpacing: _kLabelSpacing,
              text: StudentPlusOverrides.studentPlusExamsTitle),
          StudentPlusInfoSearchBar(
            hintText:
                '${widget.studentDetails.firstNameC ?? ''} ${widget.studentDetails.lastNameC ?? ''}',
            isMainPage: false,
            autoFocus: false,
            onTap: () async {
              var result = await pushNewScreen(
                context,
                screen: StudentPlusSearchScreen(
                  fromStudentPlusDetailPage: true,
                ),
                withNavBar: false,
              );
              if (result == true) {
                Utility.closeKeyboard(context);
              }
            },
            controller: _controller,
            kLabelSpacing: _kLabelSpacing,
            focusNode: myFocusNode,
          ),
          tabWidget(),
        ],
      ),
    );
  }

  Widget tabWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          //shrinkWrap: true,
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Theme.of(context)
                  .colorScheme
                  .primaryVariant, //should be : Theme.of(context).colorScheme.primary,
              indicatorColor: AppTheme.kButtonColor,
              unselectedLabelColor:
                  Globals.themeType == "Dark" ? Colors.grey : Colors.black,
              unselectedLabelStyle: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              labelStyle: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              tabs: [
                TranslationWidget(
                  message: "MATH",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Tab(
                    text: translatedMessage.toString(),
                  ),
                ),
                TranslationWidget(
                  message: "ELA",
                  toLanguage: Globals.selectedLanguage,
                  fromLanguage: "en",
                  builder: (translatedMessage) => Tab(
                    text: translatedMessage.toString(),
                  ),
                ),
              ],
            ),
            Container(
              height: Globals.deviceType == "phone" &&
                      MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height * 0.55) //62
                  : Globals.deviceType == "phone" &&
                          MediaQuery.of(context).orientation ==
                              Orientation.landscape
                      ? MediaQuery.of(context).size.height * 0.65
                      : MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.5))),
              child: TabBarView(
                children: <Widget>[
                  Tab(
                    child: tabScreenWidget(isMathSection: true),
                  ),
                  Tab(
                    child: tabScreenWidget(isMathSection: false),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* -------------- Widget return exam tab view for ELA and MATH ------------- */
  Widget tabScreenWidget({required bool isMathSection}) {
    return ListView(
      shrinkWrap: true,
      children: [
        SpacerWidget(_kLabelSpacing),
        Center(
            child: Utility.textWidget(
                text: 'NYS',
                context: context,
                textTheme: Theme.of(context).textTheme.headline5)),
        SizedBox(
          height: _kLabelSpacing / 2,
        ),
        /* -------------------------- NYS graph widget card ------------------------- */
        nysGraphWidget(),
        SpacerWidget(_kLabelSpacing * 2),
        Container(
          height: 2,
          color: StudentPlusUtility.oppositeBackgroundColor(context: context),
        ),
        SpacerWidget(_kLabelSpacing * 1.5),
        Center(
            child: Utility.textWidget(
                text: 'iReady Grade-Level',
                context: context,
                textTheme: Theme.of(context).textTheme.headline5)),
        SpacerWidget(_kLabelSpacing),
        iReadySchoolYearTitleWidget(),
        SpacerWidget(10),
        iReadyGradeLevelWidget(),
        SpacerWidget(_kLabelSpacing),
        Row(
          children: [
            HeadingWidget(isInfoIcon: true, title: 'iReady Percentile Growth'),
            IconButton(
              padding: EdgeInsets.only(top: 2),
              onPressed: () {
                StudentPlusCommonBottomSheet.showBottomSheet(
                    title: 'iReady Percentile Growth',
                    kLabelSpacing: _kLabelSpacing,
                    context: context,
                    text: StudentPlusOverrides.examScreenPopupText);
              },
              icon: Icon(
                Icons.info,
                size: Globals.deviceType == 'tablet' ? 35 : null,
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xff111C20)
                    : Color(0xffF7F8F9), //Colors.grey.shade400,
              ),
            ),
          ],
        ),
        iReadyGraphWidget(),
        SpacerWidget(_kLabelSpacing * 3)
      ],
    );
  }

  Widget nysGraphWidget() {
    return Card(
      color: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color.fromARGB(255, 12, 20, 23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      elevation: 10.0,
      shadowColor: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 40, bottom: 20, top: 0),
        height: MediaQuery.of(context).size.height * 0.55,
        child: CommonLineGraphWidget(isIReadyGraph: false),
      ),
    );
  }

  Widget iReadyGraphWidget() {
    return Card(
      color: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Color(0xffF7F8F9)
          : Color.fromARGB(255, 12, 20, 23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 10.0,
      shadowColor: Color(0xff000000) != Theme.of(context).backgroundColor
          ? Colors.white
          : Colors.black,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 30, bottom: 20, top: 30),
        height: MediaQuery.of(context).size.height * 0.38,
        width: MediaQuery.of(context).size.width * 0.9,
        child: CommonLineGraphWidget(
          isIReadyGraph: true,
        ),
      ),
    );
  }

  Widget iReadySchoolYearTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Utility.textWidget(
              text: 'Previous \nSchool Year',
              context: context,
              textTheme: Theme.of(context).textTheme.headline4),
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04),
            child: Utility.textWidget(
                text: 'Current School Year',
                context: context,
                textTheme: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
    );
  }

  Widget iReadyGradeLevelWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Container(
                alignment: Alignment.centerLeft,
                child: circularAvatarWidget(centreText: 'NA', subTitle: 'EOY')),
          ),
          Container(
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  circularAvatarWidget(centreText: '542', subTitle: 'BOY'),
                  SizedBox(
                    width: 7,
                  ),
                  circularAvatarWidget(centreText: '653', subTitle: 'MOY'),
                  SizedBox(
                    width: 7,
                  ),
                  circularAvatarWidget(centreText: 'NA', subTitle: 'EOY')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget HeadingWidget({required String title, required bool isInfoIcon}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Utility.textWidget(
            text: title,
            context: context,
            textTheme: Theme.of(context).textTheme.headline5));
  }

  Widget circularAvatarWidget(
      {required String centreText, required String subTitle}) {
    return Column(
      children: [
        SpacerWidget(10),
        CircleAvatar(
          backgroundColor:
              Color(0xff000000) != Theme.of(context).backgroundColor
                  ? Color(0xff111C20)
                  : Color(0xffF7F8F9),
          radius: MediaQuery.of(context).size.width * 0.07,
          child: Utility.textWidget(
              text: centreText,
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Theme.of(context).colorScheme.background)),
        ),
        SpacerWidget(10),
        Utility.textWidget(
            text: subTitle,
            context: context,
            textTheme: Theme.of(context).textTheme.headline4)
      ],
    );
  }
}
