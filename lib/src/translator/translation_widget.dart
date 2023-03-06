import 'package:Soc/src/globals.dart';
import 'package:Soc/src/services/analytics.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translator_api.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class TranslationWidget extends StatefulWidget {
  final double? shimmerHeight;
  final String? message;
  final String? fromLanguage;
  final String? toLanguage;
  final Widget Function(String translation)? builder;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  var isUserInteraction;

  TranslationWidget({
    this.scaffoldKey,
    this.shimmerHeight,
    @required this.message,
    this.fromLanguage,
    @required this.toLanguage,
    @required this.builder,
    this.isUserInteraction,
    Key? key,
  }) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  ConnectivityResult? connectivity;
  String? translation;

  // @override
  // void initState() {
  // TODO: implement initState
  // FirebaseAnalyticsService.addCustomAnalyticsEvent(
  //     "language_translation_screen");
  // FirebaseAnalyticsService.setCurrentScreen(
  //     screenTitle: 'language_translation_screen',
  //     screenClass: 'LanguageTranslation');
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final toLanguageCode =
        Translations.supportedLanguagesCodes(widget.toLanguage!);

    if (toLanguageCode == 'en' || toLanguageCode == '') {
      return widget.builder!(widget.message!);
    }

    return FutureBuilder(
      future: TranslationAPI.translate(
          widget.message!, toLanguageCode, widget.isUserInteraction),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return widget.isUserInteraction == true
                ? Container()
                : buildWaiting();
          default:
            if (snapshot.hasError) {
              if (Globals.isNetworkError == false) {
                Globals.isNetworkError = true;
                Future.delayed(const Duration(seconds: 3), () {
                  Utility.showSnackBar(
                      Globals.scaffoldKey,
                      'Unable to translate, Please check the Internet connection',
                      context,
                      null);
                });
              }
              translation = widget.message!;
            } else {
              translation = snapshot.data;
              Globals.isNetworkError = false;
            }
            return widget.builder!(translation!);
        }
      },
    );
  }

  Widget buildWaiting() => translation == null
      ? ShimmerLoading(
          isLoading: true,
          child: Container(
            height: widget.shimmerHeight ?? 20,
            width: 40,
            color: Colors.white,
          ),
        )
      : widget.builder!(translation!);
}
