import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/games/v1.dart';
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerWidget(_KVertcalSpace * 0.50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                      text: 'Results Summary',
                      context: context,
                      textTheme: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                SpacerWidget(_KVertcalSpace / 3),
                resultList()
              ],
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
                margin: EdgeInsets.symmetric(horizontal: 16),
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.1
                        : MediaQuery.of(context).size.width * 0.086,
                // width: MediaQuery.of(context).size.width * 0.9,
                //  color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Globals.ocrResultIcons
                      .map<Widget>((element) =>
                          _iconButton(Globals.ocrResultIcons.indexOf(element)))
                      .toList(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: index == 1 ? null : EdgeInsets.only(top: 12),
          child: Utility.textWidget(
              text: Globals.ocrResultIconsName[index],
              context: context,
              textTheme: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        index == 1
            ? Image(
               width: Globals.deviceType == "phone" ? 34 : 32,
          height: Globals.deviceType == "phone" ? 34 : 32,
                image: AssetImage("assets/images/drive_ico.png",),
              )
            : Expanded(
                child: IconButton(
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
              ),
      ],
    );
  }

  Widget resultList() {
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
        ),
        borderRadius: BorderRadius.circular(0.0),
        color: (index % 2 == 0)
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
        leading: Utility.textWidget(
            text: Globals.studentInfo![index].studentId ?? 'Unknown',
            context: context,
            textTheme: Theme.of(context).textTheme.headline2!),
        trailing: Utility.textWidget(
            text: Globals.studentInfo![index].studentGrade == ''
                ? '2/2'
                : '${Globals.studentInfo![index].studentGrade}/2', // '${Globals.gradeList[index]} /2',
            context: context,
            textTheme: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
