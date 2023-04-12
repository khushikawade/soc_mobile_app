import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/student_plus/services/student_plus_overrides.dart';
import 'package:Soc/src/modules/student_plus/widgets/header_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentPlusFilterWidget extends StatefulWidget {
  ValueNotifier<String> filterNotifier;
  final List<String> subjectList;
  final List<String> teacherList;
  StudentPlusFilterWidget(
      {Key? key,
      required this.filterNotifier,
      required this.subjectList,
      required this.teacherList})
      : super(key: key);

  @override
  State<StudentPlusFilterWidget> createState() =>
      _StudentPlusFilterWidgetState();
}

class _StudentPlusFilterWidgetState extends State<StudentPlusFilterWidget> {
  late PageController _pageController;
  List<String> filterOptionList = ["Subject", "Teacher"];
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
      height: 300 + progress * 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  physics: pageValue == 0
                      ? NeverScrollableScrollPhysics()
                      : BouncingScrollPhysics(),
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
        //  crossAxisAlignment: CrossAxisAlignment.end,
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
          HeaderWidget(kLabelSpacing: 20, text: 'Select Filter'),
          SpacerWidget(10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
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
              //  crossAxisAlignment: CrossAxisAlignment.end,
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
                  minLeadingWidth: 70,
                  title: HeaderWidget(
                      kLabelSpacing: 20,
                      text: selectedTypeFilterIndex == 0
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
                    itemCount: selectedTypeFilterIndex == 0
                        ? widget.subjectList.length
                        : widget.teacherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildRadioList(
                        index,
                        context,
                        selectedTypeFilterIndex == 0
                            ? widget.subjectList[index]
                            : widget.teacherList[index],
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
          selectedTypeFilterIndex = index;
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Utility.textWidget(
              text: text,
              maxLines: 2,
              context: context,
              textTheme: Theme.of(context).textTheme.headline4),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildRadioList(int index, context, String text) {
    return Container(
        height: 54,
        padding: EdgeInsets.symmetric(
          horizontal: 0,
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
              widget.filterNotifier.value = text;
              selectedIndex.value = index;

              Navigator.pop(context);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            groupValue: true,
            title: selectedIndex.value == index ||
                    widget.filterNotifier.value == text
                ? InkWell(
                    onTap: () {
                      if (widget.filterNotifier.value == text) {
                        widget.filterNotifier.value = '';
                        selectedIndex.value = 999;
                        Navigator.pop(context);
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Utility.textWidget(
                            text: text,
                            context: context,
                            textTheme: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold))

                        // Text(text,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .caption!
                        //         .copyWith(fontWeight: FontWeight.bold)),
                        ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Utility.textWidget(
                        text: text,
                        context: context,
                        textTheme: Theme.of(context).textTheme.headline4),
                  ),
          ),
        ));
  }
}
