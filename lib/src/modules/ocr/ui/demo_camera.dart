import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';

import 'package:Soc/src/modules/ocr/ui/subject_selection.dart';

import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_html/shims/dart_ui_real.dart';

class DemoCamera extends StatefulWidget {
  const DemoCamera({Key? key}) : super(key: key);

  @override
  State<DemoCamera> createState() =>
      _DemoCameraState();
}

class _DemoCameraState
    extends State<DemoCamera> {
  static const double _KVertcalSpace = 60.0;
  final assessmentController = TextEditingController();
  final classController = TextEditingController();
  int indexColor = 2;
  int scoringColor = 0;
  final HomeBloc _homeBloc = new HomeBloc();
  @override
  void initState() {
    setState(() {
      Globals.hideBottomNavbar = true;
    });
    _homeBloc.add(FetchStandardNavigationBar());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: highlightText(text: 'Demo Camera Screen'),
      ),
      // CustomOcrAppBarWidget(
      //   isBackButton: false,
      // ), 
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
            ],
          ),
        ),
      ),
      
    );
  }
  Widget textActionButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubjectSelection()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.kButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        height: 54,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: highlightText(
            text: 'Next',
            theme: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Theme.of(context).colorScheme.background),
          ),
        ),
      ),
    );
  }

 

  Widget highlightText({required String text,theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        textAlign: TextAlign.center,
        style: theme != null ? theme :Theme.of(context)
            .textTheme
            .headline1!
            ,
      ),
    );
  }
}
