import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary({Key? key}) : super(key: key);

  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isBackButton: false,
              isResultScreen: true,
            ),

            // AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   actions: [
            //     Container(
            //         child: IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         IconData(0xe874,
            //             fontFamily: Overrides.kFontFam,
            //             fontPackage: Overrides.kFontPkg),
            //         color: AppTheme.kButtonColor,
            //         size: 30,
            //       ),
            //     )),
            //     Container(
            //         padding: EdgeInsets.only(right: 5),
            //         child: IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => FinishedScreen()),
            //             );
            //           },
            //           icon: Icon(
            //             IconData(0xe877,
            //                 fontFamily: Overrides.kFontFam,
            //                 fontPackage: Overrides.kFontPkg),
            //             color: AppTheme.kButtonColor,
            //             size: 30,
            //           ),
            //         )),
            //   ],
            // ),
            body: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacerWidget(_KVertcalSpace * 0.50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: highlightText(
                        text: 'Results Summary',
                        theme: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  SpacerWidget(_KVertcalSpace / 3),
                  listView()
                ],
              ),
            ),
            floatingActionButton: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      new BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 20.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.086
                        : MediaQuery.of(context).size.width * 0.086,
                width: MediaQuery.of(context).size.width * 0.9,
                //  color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Globals.ocrResultIcons
                      .map<Widget>((element) =>
                          _iconButton(Globals.ocrResultIcons.indexOf(element)))
                      .toList(),

                  // [
                  //   Icon(Icons.star_border),
                  //   Icon(Icons.star_border),
                  //   Icon(Icons.star_border),
                  //   Icon(Icons.star_border),
                  // ],
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }

  Widget _iconButton(int index) {
    return Container(
      // padding: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: index == 1 ? null : EdgeInsets.only(top: 10),
            child: highlightText(
                text: Globals.ocrResultIconsName[index],
                theme: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
          index == 1
              ? Image(
                  image: AssetImage("assets/images/drive.png"),
                )
              : IconButton(
                  icon: Icon(
                    IconData(Globals.ocrResultIcons[index],
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    size: 32,
                    color: index == 2
                      ? Theme.of(context).backgroundColor == Color(0xff000000)
                          ? Colors.white
                          : Colors.black
                        : index == 3
                            ? Colors.green
                            : AppTheme.kButtonColor,
                  ),
                  onPressed: () {
                    if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssessmentSummary()),
                      );
                    }
                    if (index == 0) {
                      Share.share(Globals.shareableLink!);
                    }
                  },
                  
                ),
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
        itemCount: Globals.studentInfo!.length, // Globals.gradeList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(index);
        },
      ),
    );
  }

  Widget _buildList(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
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
            text: Globals.studentInfo![index].studentId ?? 'Unknown',
            theme: Theme.of(context).textTheme.headline2!),
        // title: TranslationWidget(
        //     message: "No title",
        //     fromLanguage: "en",
        //     toLanguage: Globals.selectedLanguage,
        //     builder: (translatedMessage) {
        //       return Text(translatedMessage.toString(),
        //           style: Theme.of(context).textTheme.bodyText1!);
        //     }),
        trailing: highlightText(
            text: Globals.studentInfo![index].studentGrade == ''
                ? '2/2'
                : '${Globals.studentInfo![index].studentGrade}/2', // '${Globals.gradeList[index]} /2',
            theme: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
