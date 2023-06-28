import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/widgets/screen_title_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentPlusFilterWidget extends StatefulWidget {
  ValueNotifier<String> filterNotifier;
  final List<String> subjectList;
  final List<String> teacherList;
  final double height;

  StudentPlusFilterWidget({
    Key? key,
    required this.filterNotifier,
    required this.subjectList,
    required this.teacherList,
    this.height = 150,
  }) : super(key: key);

  @override
  State<StudentPlusFilterWidget> createState() =>
      _StudentPlusFilterWidgetState();
}

class _StudentPlusFilterWidgetState extends State<StudentPlusFilterWidget> {
  late PageController _pageController;
  List<String> filterOptionList = ["All", "Subject", "Teacher"];
  int selectedTypeFilterIndex = 0;
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(999);
  int pageValue = 0;
  // double _progress;
  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "student_plus_filter_widget");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'student_plus_filter_widget',
        screenClass: 'StudentPlusFilterWidget');
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      height: pageValue == 0 ? widget.height : widget.height * 1.5,
      // MediaQuery.of(context).orientation == Orientation.landscape
      //     ? MediaQuery.of(context).size.height * 0.82
      //     : Globals.deviceType == "phone"
      //         ? MediaQuery.of(context).size.height * 0.32 //0.8
      //         : MediaQuery.of(context).size.height * 0.26,
      // 300 + progress * 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: ((value) {
                    pageValue = value;
                  }),
                  allowImplicitScrolling: false,
                  pageSnapping: false,
                  controller: _pageController,
                  children: [filterList(), detailedFilterList()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget filterList() {
    return Container(
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
            text: 'Select Filter',
          ),
          SpacerWidget(10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 25,
              ),
              scrollDirection: Axis.vertical,
              itemCount: filterOptionList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildList(index, context, filterOptionList[index]);
              },
            ),
          ),
          // _buildList(1, context, 'Subject'),
          // _buildList(0, context, 'Teachers'),
        ],
      ),
    );
  }

  Widget detailedFilterList() {
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
            decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: EdgeInsets.symmetric(
              horizontal: StudentPlusOverrides.kSymmetricPadding * 1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 16),
                    //color: Colors.amber,
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
                    )),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  // minLeadingWidth: 70,
                  title: PlusScreenTitleWidget(
                      kLabelSpacing: 20,
                      text: selectedTypeFilterIndex == 1
                          ? "Select Subject"
                          : 'Select Teacher'),
                  leading: IconButton(
                    onPressed: () {
                      _pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    icon: Icon(
                      IconData(0xe80d,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      color: AppTheme.kButtonColor,
                    ),
                  ),
                ),
                SpacerWidget(10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: selectedTypeFilterIndex == 1
                        ? widget.subjectList.length
                        : widget.teacherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (selectedTypeFilterIndex != 1
                              ? (widget.teacherList.length > 0)
                              : widget.subjectList.length > 0)
                          ? _buildRadioList(
                              index,
                              context,
                              selectedTypeFilterIndex == 1
                                  ? widget.subjectList[index]
                                  : widget.teacherList[index],
                            )
                          : NoDataFoundErrorWidget(
                              marginTop: 0,
                              isResultNotFoundMsg: false,
                              isNews: false,
                              isEvents: false,
                              errorMessage: 'No Data Found',
                            );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildList(int index, context, String text) {
    return Container(
      height: 54,
      // padding: EdgeInsets.symmetric(
      //   horizontal: 5,
      // ),
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
        onTap: () {
          // Index 0 represented selected All (Default option)
          if (index == 0) {
            widget.filterNotifier.value = '';
            selectedIndex.value = 999;
            Navigator.pop(context);
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            selectedTypeFilterIndex = index;
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);
          }
        },
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Utility.textWidget(
              text: text,
              maxLines: 2,
              context: context,
              // Checks to maintain selected colors
              textTheme: Theme.of(context).textTheme.headline4!.copyWith(
                  color: widget.filterNotifier.value == '' && text == 'All'
                      ? AppTheme.kButtonColor
                      : widget.subjectList
                                  .contains(widget.filterNotifier.value) &&
                              text == 'Subject'
                          ? AppTheme.kButtonColor
                          : widget.teacherList
                                      .contains(widget.filterNotifier.value) &&
                                  text == 'Teacher'
                              ? AppTheme.kButtonColor
                              : null)),
        ),
        // Checks to maintain selected colors
        trailing: Icon(
            text == 'All'
                ? (widget.filterNotifier.value == '' && text == 'All'
                    ? Icons.radio_button_checked_outlined
                    : Icons.radio_button_unchecked)
                : Icons.chevron_right,
            color: //text == 'All'
                // ?
                AppTheme.kButtonColor
            // ? (widget.filterNotifier.value == '' && text == 'All'
            //     ? AppTheme.kButtonColor
            //     : null)
            // : Theme.of(context).colorScheme.background == Color(0xff000000)
            //     ? AppTheme.klistTilePrimaryLight
            //     : AppTheme.klistTilePrimaryDark
            ),
      ),
    );
  }

  Widget _buildRadioList(int index, context, String text) {
    return InkWell(
      onTap: () {
        if (widget.filterNotifier.value == text) {
          widget.filterNotifier.value = '';
          selectedIndex.value = 999;
          Navigator.pop(context);
          FocusScope.of(context).requestFocus(FocusNode());
        } else {
          widget.filterNotifier.value = text;
          selectedIndex.value = index;

          Navigator.pop(context);
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Container(
          height: 54,
          padding: EdgeInsets.symmetric(
            horizontal: 0,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: (index % 2 == 0)
                  ? Theme.of(context).colorScheme.background ==
                          Color(0xff000000)
                      ? AppTheme.klistTilePrimaryDark
                      : AppTheme
                          .klistTilePrimaryLight //Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.background ==
                          Color(0xff000000)
                      ? AppTheme.klistTileSecoandryDark
                      : AppTheme
                          .klistTileSecoandryLight //Theme.of(context).colorScheme.secondary,
              ),
          child: IgnorePointer(
            child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: AppTheme.kButtonColor,
                ),
                child: RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,

                  activeColor: AppTheme
                      .kButtonColor, //Theme.of(context).colorScheme.primaryVariant,

                  contentPadding: EdgeInsets.zero,
                  value: selectedIndex.value == index ||
                          widget.filterNotifier.value == text
                      ? true
                      : false,
                  onChanged: (dynamic val) {
                    // widget.filterNotifier.value = text;
                    // selectedIndex.value = index;

                    // Navigator.pop(context);
                    // FocusScope.of(context).requestFocus(FocusNode());
                  },
                  groupValue: true,
                  title: selectedIndex.value == index ||
                          widget.filterNotifier.value == text
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(text,
                              // context: context,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.bold))

                          // Text(text,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .caption!
                          //         .copyWith(fontWeight: FontWeight.bold)),
                          )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(text,
                              // context: context,
                              style: Theme.of(context).textTheme.headline4),
                        ),
                )),
          )),
    );
  }
}
