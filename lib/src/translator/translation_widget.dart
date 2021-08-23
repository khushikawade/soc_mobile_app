import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/language_list.dart';
import 'package:Soc/src/translator/translator_api.dart';
import 'package:Soc/src/widgets/shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class TranslationWidget extends StatefulWidget {
  final String? message;
  final String? fromLanguage;
  final String? toLanguage;
  final Widget Function(String translation)? builder;

  TranslationWidget({
    @required this.message,
    this.fromLanguage,
    @required this.toLanguage,
    @required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String? translation;
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final toLanguageCode =
        Translations.supportedLanguagesCodes(widget.toLanguage!);
    ConnectivityResult? connectivity;

    void callsnackbar() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Globals.rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: const Text(
            'Unable to translate please check internet connection',
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
        ));
      });
    }

    return FutureBuilder(
      future: TranslationAPI.translate(widget.message!, toLanguageCode),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildWaiting();
          default:
            if (snapshot.hasError) {
              if (Globals.isNetworkError == false) {
                final bool connected = connectivity != ConnectivityResult.none;
                translation = "Network error";
                Globals.isNetworkError = true;
              } else {
                translation = widget.toLanguage!;
              }
              // callsnackbar();
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
            height: 20,
            width: 40,
            // child: Text(widget.message!),
            color: Colors.white,
          ),
        )
      : widget.builder!(translation!);
}
