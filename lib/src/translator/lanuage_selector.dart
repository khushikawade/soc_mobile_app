import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class LanguageSelector {
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  LanguageSelector(context, item, onLanguageChanged) {
    geLanguage(context, onLanguageChanged);
  }

  static final List<String> languagesList = Translations.supportedLanguages;
  static List<String> newList = [""];
  static const double _kLabelSpacing = 20.0;
  var _controller = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  bool? issuggestionList = false;

  void setLanguage(language, context, onLanguageChanged) async {
    selectedLanguage = language;
    await _sharedPref.setString('selected_language', language);
    onLanguageChanged(language);
    print(language);
    Navigator.pop(context);
  }

  geLanguage(context, onLanguageChanged) async {
    String _languageCode = await _sharedPref.getString('selected_language');
    selectedLanguage = _languageCode;
    if (selectedLanguage == null) {
      selectedLanguage = "English";
    }
    _openSettingsBottomSheet(context, onLanguageChanged);
  }

  Widget _listTile(String language, context, onLanguageChanged) => Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
        // color: AppTheme.kListTileColor,
        color: (languagesList.indexOf(language) % 2 == 0)
            ? Theme.of(context).backgroundColor
            : AppTheme.kListBackgroundColor2,
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: AppTheme.kListIconColor3,
          ),
          child: RadioListTile(
            activeColor: AppTheme.kAccentColor,
            contentPadding: EdgeInsets.zero,
            value: selectedLanguage == language ? true : false,
            onChanged: (dynamic val) {
              setLanguage(language, context, onLanguageChanged);
            },
            groupValue: true,
            title: Text(language, style: Theme.of(context).textTheme.caption),
          ),
        ),
      );

  _openSettingsBottomSheet(context, onLanguageChanged) {
    showModalBottomSheet(
        // isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(AppTheme.kBottomSheetModalUpperRadius),
                topRight:
                    Radius.circular(AppTheme.kBottomSheetModalUpperRadius))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Container(
                height: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "Select language",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: AppTheme.kBottomSheetTitleSize),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Icon(
                      //     Icons.clear,
                      //     size: Globals.deviceType == "phone" ? 20 : 28,
                      //   ),
                      // ),
                    ]),

                    // TextFormField(
                    //     focusNode: myFocusNode,
                    //     controller: _controller,
                    //     cursorColor: Colors.black,
                    //     decoration: InputDecoration(
                    //       isDense: true,
                    //       hintText: 'Search',
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(15.0),
                    //           borderSide: BorderSide.none),
                    //       filled: true,
                    //       fillColor: Theme.of(context).backgroundColor,
                    //       prefixIcon: Icon(
                    //         const IconData(0xe805,
                    //             fontFamily: Overrides.kFontFam,
                    //             fontPackage: Overrides.kFontPkg),
                    //         size: Globals.deviceType == "phone" ? 20 : 28,
                    //       ),
                    //       suffixIcon: _controller.text.isEmpty
                    //           ? null
                    //           : InkWell(
                    //               onTap: () {
                    //                 _controller.clear();

                    //                 FocusScope.of(context)
                    //                     .requestFocus(FocusNode());
                    //               },
                    //               child: Icon(
                    //                 Icons.clear,
                    //                 size:
                    //                     Globals.deviceType == "phone" ? 20 : 28,
                    //               ),
                    //             ),
                    //     ),
                    //     onChanged: (value) {
                    //       onItemChanged(value, setState);
                    //     }),

                    issuggestionList!
                        ? _buildsuggestiontlist(context, onLanguageChanged)
                        : Container(
                            height: 0,
                          ),

                    // _buildSearchbar(context, setState),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 30, left: 30, right: 15, bottom: 30),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       // _buildSearchbar(context),
                    //     ],
                    //   ),
                    // ),

                    Expanded(
                      child: _buildLanguagesList(context, onLanguageChanged),
                    ),
                    // SpacerWidget(30)
                  ],
                ),
              );
            });
          }
        });
  }

  onItemChanged(String value, StateSetter setState) {
    setState(() {
      newList = languagesList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    issuggestionList = true;
  }

  // //   Utility.showBottomSheet(
  // //       Container(
  // //         height: MediaQuery.of(context).size.width * 0.95,
  // //         child: Column(
  // //           mainAxisSize: MainAxisSize.min,
  // //           children: [
  // //             // Row(
  // //             //   children: [
  // //             //     Expanded(
  // //             //       // wrap your Column in Expanded
  // //             //       child: Container(child: _buildSearchbar(co)),
  // //             //     ),
  // //             //   ],
  // //             // ),
  // //             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  // //               Text(
  // //                 "Select language",
  // //                 style: Theme.of(context)
  // //                     .textTheme
  // //                     .headline6!
  // //                     .copyWith(fontSize: AppTheme.kBottomSheetTitleSize),
  // //               ),
  // //               InkWell(
  // //                 onTap: () {
  // //                   Navigator.pop(context);
  // //                 },
  // //                 child: Icon(
  // //                   Icons.clear,
  // //                   size: Globals.deviceType == "phone" ? 20 : 28,
  // //                 ),
  // //               ),
  // //             ]),

  // //         TextFormField(
  // //     focusNode: myFocusNode,
  // //     controller: _controller,
  // //     cursorColor: Colors.black,
  // //     decoration: InputDecoration(
  // //       isDense: true,
  // //       hintText: 'Search',
  // //       border: OutlineInputBorder(
  // //           borderRadius: BorderRadius.circular(15.0),
  // //           borderSide: BorderSide.none),
  // //       filled: true,
  // //       fillColor: Theme.of(context).backgroundColor,
  // //       prefixIcon: Icon(
  // //         const IconData(0xe805,
  // //             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
  // //         size: Globals.deviceType == "phone" ? 20 : 28,
  // //       ),
  // //       suffixIcon: _controller.text.isEmpty
  // //           ? null
  // //           : InkWell(
  // //               onTap: () {
  // //                 _controller.clear();

  // //                 FocusScope.of(context).requestFocus(FocusNode());
  // //               },
  // //               child: Icon(
  // //                 Icons.clear,
  // //                 size: Globals.deviceType == "phone" ? 20 : 28,
  // //               ),
  // //             ),
  // //     ),
  // //     onChanged: onItemChanged(),
  // //   )

  // //             // _buildSearchbar(context, setState),
  // //             // Padding(
  // //             //   padding: const EdgeInsets.only(
  // //             //       top: 30, left: 30, right: 15, bottom: 30),
  // //             //   child: Row(
  // //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // //             //     mainAxisSize: MainAxisSize.max,
  // //             //     children: [
  // //             //       // _buildSearchbar(context),
  // //             //     ],
  // //             //   ),
  // //             // ),

  // //             Expanded(
  // //               child: _buildLanguagesList(context, onLanguageChanged),
  // //             ),
  // //             // SpacerWidget(30)
  // //           ],
  // //         ),
  // //       ),
  // //       context);
  // // }

  // Widget _buildSearchbar(BuildContext context, StateSetter setState) {
  //   return TextFormField(
  //     focusNode: myFocusNode,
  //     controller: _controller,
  //     cursorColor: Colors.black,
  //     decoration: InputDecoration(
  //       isDense: true,
  //       hintText: 'Search',
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //           borderSide: BorderSide.none),
  //       filled: true,
  //       fillColor: Theme.of(context).backgroundColor,
  //       prefixIcon: Icon(
  //         const IconData(0xe805,
  //             fontFamily: Overrides.kFontFam, fontPackage: Overrides.kFontPkg),
  //         size: Globals.deviceType == "phone" ? 20 : 28,
  //       ),
  //       suffixIcon: _controller.text.isEmpty
  //           ? null
  //           : InkWell(
  //               onTap: () {
  //                 _controller.clear();

  //                 FocusScope.of(context).requestFocus(FocusNode());
  //               },
  //               child: Icon(
  //                 Icons.clear,
  //                 size: Globals.deviceType == "phone" ? 20 : 28,
  //               ),
  //             ),
  //     ),
  //     onChanged: onItemChanged(),
  //   );
  // }

  // onItemChanged() {
  //   // suggestionlist = true;
  //   // setState(() {
  //   //   languagesList
  //   //       .where((string) => string.toLowerCase().contains(value.toLowerCase()))
  //   //       .toList();
  //   // });
  // }

  _buildLanguagesList(context, onLanguageChanged) {
    return ListView(
      children: languagesList
          .map<Widget>((i) => _listTile(i, context, onLanguageChanged))
          .toList(),
    );
  }

  Widget _buildsuggestiontlist(context, onLanguageChanged) {
    return Expanded(
      child: Container(
          child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(12.0),
        children: newList.map((data) {
          return ListTile(
              title: Text(
                data,
                style: TextStyle(
                    fontFamily: 'SF UI Display Bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 17),
              ),
              onTap: () {
                setLanguage(data, context, onLanguageChanged);
                // =data
              });
        }).toList(),
      )),
    );
  }
}
