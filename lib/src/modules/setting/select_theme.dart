import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectTheme extends StatefulWidget {
  @override
  SelectTheme({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => SelectThemeState();
}

bool _systemDefault = true;
bool _light = false;
bool _dark = false;

class SelectThemeState extends State<SelectTheme>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: Globals.deviceType == "phone" ? 40 : null,
                      width: Globals.deviceType == "phone" ? 40 : null,
                      // margin: EdgeInsets.all(20),
                      // padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent,
                          border: Border.all(width: 2, color: Colors.white)),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: Globals.deviceType == "phone" ? 25 : 30,
                        ),
                      )),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Theme.of(context).backgroundColor,
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslationWidget(
                              message: 'Choose Theme',
                              fromLanguage: "en",
                              toLanguage: Globals.selectedLanguage,
                              builder: (translatedMessage) => Text(
                                    translatedMessage.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline1!,
                                  )),
                          CheckboxListTile(
                            checkColor: Theme.of(context).primaryColor,
                            activeColor: Theme.of(context).primaryColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.zero,
                            isThreeLine: false,
                            title: headingText('System default'),
                            value: _systemDefault,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _systemDefault = value!;
                                  _light = false;
                                  _dark = false;
                                  AdaptiveTheme.of(context).setSystem();
                                } else if (_light == true || _dark == true) {
                                  _systemDefault = value!;
                                } else {
                                  errorSnakbar();
                                }
                              });
                            },
                          ),
                          divider(context),
                          CheckboxListTile(
                            checkColor: Theme.of(context).primaryColor,
                            activeColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.zero,
                            isThreeLine: false,
                            title: headingText('Light'),
                            value: _light,
                            
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _light = value!;
                                  _systemDefault = false;
                                  _dark = false;
                                  AdaptiveTheme.of(context).setLight();
                                } else if (_systemDefault == true ||
                                    _dark == true) {
                                  _light = value!;
                                } else {
                                  final scaffoldKey = Scaffold.of(context);
                                  // ignore: deprecated_member_use
                                  scaffoldKey.showSnackBar(
                                    SnackBar(
                                      content: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 40,
                                        child: Text(
                                          'Mode is already selected',
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08),
                                      padding: EdgeInsets.only(
                                        left: 16,
                                      ),
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                          divider(context),
                          CheckboxTheme(
                            data: Theme.of(context).checkboxTheme,
                            child: CheckboxListTile(
                              checkColor: Theme.of(context).primaryColor,
                              activeColor: Theme.of(context).primaryColor,
                              controlAffinity: ListTileControlAffinity.trailing,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: EdgeInsets.zero,
                              isThreeLine: false,
                              title: headingText('Dark'),
                              value: _dark,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _dark = value!;
                                    _light = false;
                                    _systemDefault = false;
                                    AdaptiveTheme.of(context).setDark();
                                  }
                                  if (_systemDefault == true ||
                                      _light == true) {
                                    _dark = value!;
                                  }
                                });
                              },
                            ),
                          ),
                          divider(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 0.5,
      decoration: BoxDecoration(color: Color(0xffD9D6D5)),
    );
  }

  Widget headingText(message) {
    return TranslationWidget(
        message: message,
        fromLanguage: "en",
        toLanguage: Globals.selectedLanguage,
        builder: (translatedMessage) => Text(
              translatedMessage.toString(),
              style: Theme.of(context).textTheme.headline3!,
            ));
  }

  errorSnakbar() {
    final scaffoldKey = Scaffold.of(context);
    // ignore: deprecated_member_use
    scaffoldKey.showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.centerLeft,
          height: 40,
          child: Text(
            'Mode is already selected',
            textAlign: TextAlign.left,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.08),
        padding: EdgeInsets.only(
          left: 16,
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
    );
  }
}
