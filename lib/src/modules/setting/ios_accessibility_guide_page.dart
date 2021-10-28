import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class IosAccessibilityGuidePage extends StatefulWidget {
  @override
  _IosAccessibilityGuidePageState createState() =>
      _IosAccessibilityGuidePageState();
}

class _IosAccessibilityGuidePageState extends State<IosAccessibilityGuidePage> {
  Widget _tutorialStep(String step, String imagePath) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslationWidget(
                message: '$step',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(
                    translatedMessage.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: Color.fromRGBO(0, 122, 255, 1)),
                  );
                }),
            Center(
              child: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Image.asset(
                    '$imagePath',
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      );

  Widget _body() => Container(
        padding: EdgeInsets.all(AppTheme.kBodyPadding),
        child: ListView(
          children: [
            TranslationWidget(
                message:
                    'There are lots of built-in Accessibility features are provided by iOS, perform the following steps to learn how to enable them.',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) {
                  return Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline1,
                  );
                }),
            SpacerWidget(AppTheme.kBodyPadding),
            _tutorialStep('1. Go to Settings  > Accessibility.',
                'assets/images/accessibility-1.png'),
            _tutorialStep('2. Choose any of the following features:',
                'assets/images/accessibility-2.png'),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => InAppUrlLauncer(
                                isbuttomsheet: true,
                                language: Globals.selectedLanguage,
                                url: 'https://www.apple.com/accessibility/',
                                title: 'Accessibility',
                              )));
                },
                child: Row(
                  children: [
                    TranslationWidget(
                        message: 'Click here to learn more',
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) {
                          return Text(
                            translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color: Color.fromRGBO(0, 122, 255, 1),
                                    decoration: TextDecoration.underline),
                          );
                        }),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
                    )
                  ],
                )),
            SpacerWidget(AppTheme.kBodyPadding)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          marginLeft: 20,
          hideAccessibilityButton: true,
          refresh: (v) {
            setState(() {});
          },
        ),
        body: _body());
  }
}
