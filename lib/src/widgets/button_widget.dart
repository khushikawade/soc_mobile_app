import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatefulWidget {
  final String? title;
  ButtonWidget({
    required this.title,
  });
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? iserrorstate = false;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(_kPadding / 3),
            constraints: BoxConstraints(
              minWidth: _KButtonSize,
              maxWidth: 130.0,
              minHeight: _KButtonSize / 2,
              maxHeight: _KButtonSize / 2,
            ),
            child: ElevatedButton(
              onPressed: () async {
                SharePopUp obj = new SharePopUp();
                String link = await _buildlink();
                // final String body =
                //     "${object.title["__cdata"].toString().replaceAll(new RegExp(r'[\\]+'), '\n').replaceAll("n.", ".").replaceAll("\nn", "\n")}"
                //             " " +
                //         link;
                obj.callFunction(context, "body", "");
              },
              child: Globals.selectedLanguage != null &&
                      Globals.selectedLanguage != "English" &&
                      Globals.selectedLanguage != ""
                  ? TranslationWidget(
                      message: widget.title.toString(),
                      toLanguage: Globals.selectedLanguage,
                      fromLanguage: "en",
                      builder: (translatedMessage) => Text(
                        translatedMessage.toString(),
                      ),
                    )
                  : Text(widget.title.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _buildlink() async {
    // link = object.link.toString();
    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches("link");
    matches.forEach((match) {
      // link2 = link.substring(match.start, match.end);
    });
    return 'link2';
  }
}
