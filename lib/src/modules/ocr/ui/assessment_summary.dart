import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class AssessmentSummary extends StatefulWidget {
  AssessmentSummary({Key? key}) : super(key: key);

  @override
  State<AssessmentSummary> createState() => _AssessmentSummaryState();
}

class _AssessmentSummaryState extends State<AssessmentSummary> {
  static const double _KVertcalSpace = 60.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomOcrAppBarWidget(isBackButton: true),
      
      // AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(
      //       IconData(0xe80d,
      //           fontFamily: Overrides.kFontFam,
      //           fontPackage: Overrides.kFontPkg),
      //       color: AppTheme.kButtonColor,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     Container(
      //       padding: EdgeInsets.only(right: 10),
      //       child: Icon(
      //         IconData(0xe874,
      //             fontFamily: Overrides.kFontFam,
      //             fontPackage: Overrides.kFontPkg),
      //         color: AppTheme.kButtonColor,
      //       ),
      //     ),
      //   ],
      // ),
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            highlightText(
                text: 'Assessment Summary',
                theme: Theme.of(context).textTheme.headline6),
            SpacerWidget(_KVertcalSpace / 3),
            listView()
          ],
        ),
      ),
    );
  }

  Widget listView() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.80
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(index);
        },
      ),
    );
  }

  Widget _buildList(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          // width: 0.65,
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        // onTap: () {
        //   _navigate(obj, index);
        // },
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        // contentPadding:
        //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading: highlightText(
            text: 'Assessment $index',
            theme: Theme.of(context).textTheme.headline2),
        // title: TranslationWidget(
        //     message: "No title",
        //     fromLanguage: "en",
        //     toLanguage: Globals.selectedLanguage,
        //     builder: (translatedMessage) {
        //       return Text(translatedMessage.toString(),
        //           style: Theme.of(context).textTheme.bodyText1!);
        //     }),
        trailing: highlightText(
            text: index.toString(), theme: Theme.of(context).textTheme.headline2),
      ),
    );
  }

  Widget highlightText({required String text, theme}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TranslationWidget(
        message: text,
        toLanguage: Globals.selectedLanguage,
        fromLanguage: "en",
        builder: (translatedMessage) => Text(
          translatedMessage.toString(),
          textAlign: TextAlign.center,
          style: theme != null ? theme : Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
