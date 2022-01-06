import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatefulWidget {
  final String? buttonTitle;
  final String? title;
  final String? body;
  final obj;
  ButtonWidget({
    required this.title,
    required this.buttonTitle,
    required this.body,
    required this.obj,
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
                final String title = widget.title!;
                String body = widget.body!;
                obj.callFunction(context, body, title);
              },
              child: TranslationWidget(
                message: widget.buttonTitle.toString(),
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<String> _buildlink(obj) async {
  //   String link = obj.link.toString();
  //   RegExp exp =
  //       new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  //   Iterable<RegExpMatch> matches = exp.allMatches("link");
  //   matches.forEach((match) {
  //   String  link2 = link.substring(match.start, match.end);
  //   });
  //   return 'link2';
  // }
}
