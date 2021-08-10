import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSelector {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPreferencesFn _sharedPref = SharedPreferencesFn();
  String? selectedLanguage;

  LanguageSelector(context, onLanguageChanged) {
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
        margin: EdgeInsets.only(
          top: 5,
          left: 30,
          right: 30,
        ),
        color: (languagesList.indexOf(language) % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: RadioListTile(
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            value: selectedLanguage == language ? true : false,
            onChanged: (dynamic val) {
              print(val);
              if (selectedLanguage != language) {
                setLanguage(language, context, onLanguageChanged);
              }
            },
            groupValue: true,
            title: selectedLanguage == language
                ? InkWell(
                    onTap: () {
                      final scaffoldKey = Scaffold.of(context);
                      scaffoldKey.showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Language already selected',
                          ),
                          backgroundColor: Colors.black.withOpacity(0.8),
                        ),
                      );
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
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return new OrientationBuilder(builder: (context, orientation) {
                orientation == Orientation.landscape
                    ? SystemChrome.setEnabledSystemUIOverlays(
                        [SystemUiOverlay.bottom])
                    : SystemChrome.setEnabledSystemUIOverlays(
                        SystemUiOverlay.values);
                return SafeArea(
                  child: Container(
                    height: orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.965
                        : MediaQuery.of(context).size.height * 0.60,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Select language",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontSize: AppTheme.kBottomSheetTitleSize),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: _kLabelSpacing / 1.5),
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor:
                                          Theme.of(context).backgroundColor,
                                      prefixIcon: Icon(
                                        const IconData(0xe805,
                                            fontFamily: Overrides.kFontFam,
                                            fontPackage: Overrides.kFontPkg),
                                        size: Globals.deviceType == "phone"
                                            ? 20
                                            : 28,
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
                                                size: Globals.deviceType ==
                                                        "phone"
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
                                child: _buildLanguagesList(
                                    context, onLanguageChanged),
                              ),
                      ],
                    ),
                  ),
                );
              });
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: ListView(
        children: languagesList
            .map<Widget>((i) => _listTile(i, context, onLanguageChanged, false))
            .toList(),
      ),
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
                  .toList())),
    );
  }
}
