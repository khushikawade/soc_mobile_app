import 'package:Soc/src/globals.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/shared_preference.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class LanguageSelector {
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

  Widget divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 0.5,
      decoration: BoxDecoration(color: Color(0xffD9D6D5)),
    );
  }

  Widget _listTile(
          String language, context, onLanguageChanged, bool issuggestionList) =>
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            color: Theme.of(context).colorScheme.secondary,
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: Theme.of(context).colorScheme.primaryVariant,
                contentPadding: EdgeInsets.zero,
                value: selectedLanguage == language ? true : false,
                onChanged: (dynamic val) {
                  if (selectedLanguage != language) {
                    setLanguage(language, context, onLanguageChanged);
                  }
                },
                groupValue: true,
                title: selectedLanguage == language
                    ? InkWell(
                        onTap: () {
                          final scaffoldKey = ScaffoldMessenger.of(context);
                          // ignore: deprecated_member_use
                          Utility.showSnackBar(
                              scaffoldKey,
                              '$selectedLanguage language is already selected',
                              context,
                              null);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(language,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(language,
                            style: Theme.of(context).textTheme.caption!),
                      ),
              ),
            ),
          ),
          divider(context),
        ],
      );

  _openSettingsBottomSheet(context, onLanguageChanged) {
    Future<void> future = showModalBottomSheet<void>(
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
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom / 2),
                  child: SafeArea(
                      child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.height * 0.82
                        : MediaQuery.of(context).size.height * 0.60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          icon: Icon(
                            Icons.clear,
                            size: Globals.deviceType == "phone" ? 28 : 36,
                          ),
                        ),
                        Center(
                          child: TranslationWidget(
                              message: "Select language",
                              fromLanguage: "en",
                              toLanguage: Globals.selectedLanguage,
                              builder: (translatedMessage) {
                                return Text(
                                  translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: Globals.deviceType == "phone"
                                            ? AppTheme.kBottomSheetTitleSize
                                            : AppTheme.kBottomSheetTitleSize *
                                                1.3,
                                      ),
                                );
                              }),
                        ),
                        SpacerWidget(_kLabelSpacing * 1.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: _kLabelSpacing / 1.5),
                          child: SizedBox(
                            height: 51,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              child: TranslationWidget(
                                  message: 'Search',
                                  fromLanguage: "en",
                                  toLanguage: Globals.selectedLanguage,
                                  builder: (translatedMessage) {
                                    return TextFormField(
                                        focusNode: myFocusNode,
                                        controller: _controller,
                                        cursorColor: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                        decoration: InputDecoration(
                                          hintText:
                                              translatedMessage.toString(),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                width: 2),
                                          ),
                                          prefixIcon: Icon(
                                            const IconData(0xe805,
                                                fontFamily: Overrides.kFontFam,
                                                fontPackage:
                                                    Overrides.kFontPkg),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
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
                                                        .requestFocus(
                                                            FocusNode());
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.clear,
                                                    size: Globals.deviceType ==
                                                            "phone"
                                                        ? 20
                                                        : 28,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryVariant,
                                                  ),
                                                ),
                                        ),
                                        onChanged: (value) {
                                          onItemChanged(value, setState);
                                        });
                                  }),
                            ),
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
                  )),
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
    return ListView(
      padding: const EdgeInsets.only(bottom: 35),
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
                  .toList())),
    );
  }
}
