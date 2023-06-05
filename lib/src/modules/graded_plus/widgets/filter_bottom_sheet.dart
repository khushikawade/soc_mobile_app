import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class FilterBottomSheet extends StatefulWidget {
  FilterBottomSheet({
    Key? key,
    required this.update,
    required this.title,
    required this.selectedValue,
  }) : super(key: key);
  final String title;
  final String selectedValue;

  final Function({String? filterValue}) update;
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> filterList = ['All', 'Constructed Response', 'Multiple Choice'];

  final ValueNotifier<String> selectedValue = ValueNotifier<String>('');
  @override
  void initState() {
    selectedValue.value = widget.selectedValue;
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets / 1.1,
      controller: ModalScrollController.of(context),
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * 0.82
            : MediaQuery.of(context).size.width *
                0.74, //MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xff000000) != Theme.of(context).backgroundColor
              ? Color(0xffF7F8F9)
              : Color(0xff111C20),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
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
            Container(
              //  height: 60,
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide.none),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Container(
                alignment: Alignment.center,
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
          return Container(
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
                if (selectedValue.value == filterList[index]) {
                  //         // ignore: deprecated_member_use
                  Utility.currentScreenSnackBar(
                      '${filterList[index]} Filter is already selected', null);
                } else {
                  selectedValue.value = filterList[index];
                  widget.update(filterValue: filterList[index]);
                  Navigator.pop(context);
                }
              },
              title: Utility.textWidget(
                  text: filterList[index],
                  context: context,
                  textTheme: Theme.of(context).textTheme.headline2),
              trailing: Icon(
                selectedValue.value == filterList[index]
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppTheme.kButtonColor,
              ),
            ),

            //  Theme(
            //   data: ThemeData(unselectedWidgetColor: AppTheme.kButtonColor
            //       // Theme.of(context).colorScheme.onBackground,
            //       ),
            //   child: RadioListTile(
            //     controlAffinity: ListTileControlAffinity.trailing,
            //     activeColor: AppTheme.kButtonColor,
            //     title: Utility.textWidget(
            //         text: filterList[index],
            //         context: context,
            //         textTheme: Theme.of(context).textTheme.headline2),
            //     groupValue: true,
            //     value: selectedValue.value == filterList[index] ? true : false,

            //     onChanged: (bool? value) {
            //       if (selectedValue.value == filterList[index]) {
            //         // ignore: deprecated_member_use
            //         Utility.currentScreenSnackBar(
            //             '${filterList[index]} Filter is already selected',
            //             null);
            //       }

            //       selectedValue.value = filterList[index];
            //       widget.update(filterValue: filterList[index]);
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
          );
        });
  }
}
