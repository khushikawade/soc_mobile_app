import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/weburllauncher.dart';
import 'package:flutter/material.dart';
import 'hori_spacerwidget.dart';

// ignore: must_be_immutable
class ListBorderWidget extends StatefulWidget {
  final String? title;
  final Widget? child;
  ListBorderWidget({required this.title, required this.child});
  @override
  _ListBorderWidgetState createState() => _ListBorderWidgetState();
}

class _ListBorderWidgetState extends State<ListBorderWidget> {
  static const double _kLabelSpacing = 16.0;

  static const double _kboxborderwidth = 0.75;
  bool issuccesstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  UrlLauncherWidget urlobj = new UrlLauncherWidget();
  final HomeBloc homebloc = new HomeBloc();
  bool? iserrorstate = false;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            border: Border.all(
              width: _kboxborderwidth,
              color: AppTheme.kTxtfieldBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 2),
          child: Row(
            children: [
              TranslationWidget(
                message: "${widget.title} :",
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              HorzitalSpacerWidget(_kLabelSpacing / 2),
              Container(
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
