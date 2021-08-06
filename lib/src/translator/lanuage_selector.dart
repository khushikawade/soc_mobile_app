import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class LanguageSelector {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  LanguageSelector(context, item, onLanguageChanged) {
    geLanguage(context, onLanguageChanged);
  }

  static final List<String> languagesList = Translations.supportedLanguages;
  static List<String> newList = [""];
  final _controller = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  bool? issuggestionList = false;
  static const double _kLabelSpacing = 16.0;

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

  Widget _listTile(
          String language, context, onLanguageChanged, bool issuggestionList) =>
      Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
        color: (languagesList.indexOf(language) % 2 == 0)
            ? Theme.of(context).backgroundColor
            : AppTheme.kListBackgroundColor2,
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: AppTheme.kListIconColor3,
          ),
          child: RadioListTile(
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            value: selectedLanguage == language ? true : false,
            onChanged: (dynamic val) {
              selectedLanguage == language
                  ? print("already selected")
                  // Utility.showSnackBar(
                  //     _scaffoldKey, "It already selected change ", context)
                  : setLanguage(language, context, onLanguageChanged);
            },
            groupValue: true,
            title: selectedLanguage == language
                ? InkWell(
                    onTap: () {
                      if (issuggestionList) {
                        Utility.showSnackBar(
                            _scaffoldKey, "It already selected  ", context);
                      }
                    },
                    child: Text(language,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                  )
                : Text(language,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
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
                    SpacerWidget(_kLabelSpacing),
                    ListTile(
                      title: Text(
                        "Select language",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: AppTheme.kBottomSheetTitleSize),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Icon(
                          Icons.clear,
                          size: Globals.deviceType == "phone" ? 20 : 28,
                        ),
                      ),
                    ),
                    // SpacerWidget(_kLabelSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: _kLabelSpacing / 1.5,
                          vertical: _kLabelSpacing),
                      child: SizedBox(
                        height: 51,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: _kLabelSpacing / 3,
                                horizontal: _kLabelSpacing / 2),
                            color: AppTheme.kFieldbackgroundColor,
                            child: TextFormField(
                                focusNode: myFocusNode,
                                controller: _controller,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Search',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Theme.of(context).backgroundColor,
                                  prefixIcon: Icon(
                                    const IconData(0xe805,
                                        fontFamily: Overrides.kFontFam,
                                        fontPackage: Overrides.kFontPkg),
                                    size:
                                        Globals.deviceType == "phone" ? 20 : 28,
                                  ),
                                  suffixIcon: _controller.text.isEmpty
                                      ? null
                                      : InkWell(
                                          onTap: () {
                                            _controller.clear();
                                            issuggestionList = false;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: Globals.deviceType == "phone"
                                                ? 20
                                                : 28,
                                          ),
                                        ),
                                ),
                                onChanged: (value) {
                                  onItemChanged(value, setState);
                                })),
                      ),
                    ),
                    issuggestionList!
                        ? _buildsuggestiontlist(context, onLanguageChanged)
                        : Container(
                            height: 0,
                          ),
                    issuggestionList!
                        ? Container(
                            height: 0,
                          )
                        : Expanded(
                            child:
                                _buildLanguagesList(context, onLanguageChanged),
                          ),
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
          .where(
              (string) => string.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    });
    issuggestionList = true;

    if (value.isEmpty) {
      issuggestionList = false;
    }
  }

  _buildLanguagesList(context, onLanguageChanged) {
    return ListView(
      children: languagesList
          .map<Widget>((i) => _listTile(i, context, onLanguageChanged, false))
          .toList(),
    );
  }

  Widget _buildsuggestiontlist(context, onLanguageChanged) {
    return Expanded(
      child: Container(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(12.0),
              children: newList
                  .map<Widget>((data) =>
                      _listTile(data, context, onLanguageChanged, true))
                  .toList()

              //  ListTile(
              //     title: Text(
              //       data,
              //     ),
              //     onTap: () {
              //       issuggestionList = false;
              //       setLanguage(data, context, onLanguageChanged);
              //     });
              // }).toList(),
              )),
    );
  }
}
