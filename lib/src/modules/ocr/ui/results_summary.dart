import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/finished_screen.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary({Key? key}) : super(key: key);

  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinishedScreen()),
                );
              },
              child: highlightText(
                  text: 'Done', theme: Theme.of(context).textTheme.headline3))
        ],
      ),
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            highlightText(
                text: 'Results Summary',
                theme: Theme.of(context).textTheme.headline6),
            SpacerWidget(_KVertcalSpace / 3),
            listView()
          ],
        ),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.09
              : MediaQuery.of(context).size.width * 0.09,
          width: MediaQuery.of(context).size.width * 0.9,
        //  color: Colors.blue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Globals.ocrResultIcons
                .map<Widget>(
                    (element) => _iconButton(Globals.icons.indexOf(element)))
                .toList(),

            // [
            //   Icon(Icons.star_border),
            //   Icon(Icons.star_border),
            //   Icon(Icons.star_border),
            //   Icon(Icons.star_border),
            // ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _iconButton(int index) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          highlightText(
              text: Globals.ocrResultIconsName[index],
              theme: Theme.of(context).textTheme.subtitle2),
          Icon(IconData(Globals.ocrResultIcons[index])),
        ],
      ),
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Text(
        translatedMessage.toString(),
        // maxLines: 2,
        //overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
        style: theme,
      ),
    );
  }

  Widget listView() {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.72
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: 50,
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
            text: 'Benjamin Dalgleish',
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
            text: '0/2', theme: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}
