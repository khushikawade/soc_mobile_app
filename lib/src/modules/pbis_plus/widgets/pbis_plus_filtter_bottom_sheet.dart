import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/pbis_plus/services/pbis_overrides.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class PBISPlusHistoryFilterBottomSheet extends StatefulWidget {
  PBISPlusHistoryFilterBottomSheet({
    Key? key,
    required this.update,
    required this.title,
    required this.selectedValue,
    required this.scaffoldKey,
    this.height = 150,
  }) : super(key: key);
  final String title;
  final String selectedValue;
  final Key scaffoldKey;

  final Function({String? filterValue}) update;
  final double? height;
  @override
  State<PBISPlusHistoryFilterBottomSheet> createState() =>
      _PBISPlusHistoryFilterBottomSheetState();
}

class _PBISPlusHistoryFilterBottomSheetState
    extends State<PBISPlusHistoryFilterBottomSheet> {
  List<String> filterList = ['All', 'Google Classroom', 'Google Sheet'];

  final ValueNotifier<String> selectedValue =
      ValueNotifier<String>(PBISPlusOverrides.pbisPlusFilterValue);

  @override
  void initState() {
    selectedValue.value = widget.selectedValue;

    super.initState();

    FirebaseAnalyticsService.addCustomAnalyticsEvent(
        "pbis_plus_filter_bottomsheet");
    FirebaseAnalyticsService.setCurrentScreen(
        screenTitle: 'pbis_plus_filter_bottomsheet',
        screenClass: 'PBISPlusHistoryFilterBottomSheet');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.1,
      controller: ModalScrollController.of(context),
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: widget.height!,
        // MediaQuery.of(context).orientation == Orientation.landscape
        //     ? MediaQuery.of(context).size.height * 0.82
        //     : Globals.deviceType == "phone"
        //         ? MediaQuery.of(context).size.height * 0.38 //0.8
        //         : MediaQuery.of(context).size.height * 0.28,
        // MediaQuery.of(context).size.width *
        //     0.8, //MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16),
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
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Utility.textWidget(
                  context: context,
                  text: widget.title,
                  textTheme: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Color(0xff000000) ==
                                Theme.of(context).backgroundColor
                            ? Color(0xffFFFFFF)
                            : Color(0xff000000),
                        fontSize: Globals.deviceType == "phone"
                            ? AppTheme.kBottomSheetTitleSize
                            : AppTheme.kBottomSheetTitleSize * 1.3,
                      )),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filterList.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: listTile(index: index, list: filterList));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTile({required int index, required List<String> list}) {
    return ValueListenableBuilder(
        valueListenable: selectedValue,
        child: Container(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return InkWell(
            onTap: () {
              /*-------------------------User Activity Track START----------------------------*/
              FirebaseAnalyticsService.addCustomAnalyticsEvent(
                  'Filter option click PBIS+'
                      .toLowerCase()
                      .replaceAll(" ", "_"));
              /*-------------------------User Activity Track END----------------------------*/

              if (selectedValue.value == filterList[index]) {
                Utility.showSnackBar(
                    widget.scaffoldKey,
                    '\'${filterList[index]}\' filter is already selected',
                    context,
                    null);
              }
              selectedValue.value = filterList[index];
              widget.update(filterValue: filterList[index]);
              Navigator.pop(context);
            },
            child: Container(
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
              child: IgnorePointer(
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: AppTheme.kButtonColor
                      // Theme.of(context).colorScheme.onBackground,
                      ),
                  child: RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: AppTheme.kButtonColor,
                    title: Utility.textWidget(
                        text: filterList[index],
                        context: context,
                        textTheme: Theme.of(context).textTheme.headline2),
                    groupValue: true,
                    value:
                        selectedValue.value == filterList[index] ? true : false,
                    onChanged: (bool? value) {
                      // selectedValue.value = filterList[index];
                      // widget.update(filterValue: filterList[index]);
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
