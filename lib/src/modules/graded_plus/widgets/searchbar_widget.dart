import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:flutter/material.dart';

import '../../../styles/theme.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String stateName;
  final onSaved;
  final onTap;
  final bool? isCommonCore;
  final bool? isSearchPage;
  final bool? isSubLearningPage;
  final bool? readOnly;
  const SearchBar(
      {Key? key,
      this.suffixIcon,
      required this.stateName,
      required this.controller,
      required this.onSaved,
      this.onTap,
      this.isSearchPage,
      this.isCommonCore,
      this.isSubLearningPage,
      required this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        //  padding: EdgeInsets.symmetric(
        //      vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing / 2),
        child: TranslationWidget(
            message: isSearchPage == true
                ? isCommonCore == true
                    ? 'Common Core'
                    : 'Search Learning Standard and $stateName Learning Standard '
                : isSubLearningPage == true
                    ? isCommonCore == true
                        ? 'Common Core'
                        : 'Search $stateName Learning Standard'
                    : 'Search',
            fromLanguage: "en",
            toLanguage: Globals.selectedLanguage,
            builder: (translatedMessage) {
              return TextFormField(
                readOnly: readOnly ?? false,
                autofocus: isSearchPage == true ? true : false,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant),
                //  focusNode: myFocusNode,
                controller: controller,
                cursorColor: Theme.of(context).colorScheme.primaryVariant,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: AppTheme.kSelectedColor, width: 2),
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      )),
                  hintText: translatedMessage.toString(),
                  hintStyle: TextStyle(color: Color(0xffAAAAAA), fontSize: 15),
                  fillColor:
                      Color(0xff000000) != Theme.of(context).backgroundColor
                          ? Color.fromRGBO(0, 0, 0, 0.1)
                          : Color.fromRGBO(255, 255, 255, 0.16),
                  prefixIcon: Icon(
                    const IconData(0xe805,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Color(0xffAAAAAA),
                    size: Globals.deviceType == "phone" ? 18 : 16,
                  ),
                  suffixIcon: controller.text.isEmpty
                      ? null
                      : suffixIcon == null
                          ? InkWell(
                              onTap: () {
                                controller.clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                                size: Globals.deviceType == "phone" ? 20 : 28,
                              ),
                            )
                          : suffixIcon,
                ),
                onChanged: onSaved,
                onTap: onTap,
              );
            }),
      ),
    );
  }
}
