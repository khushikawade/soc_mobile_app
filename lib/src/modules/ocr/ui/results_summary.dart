import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/bloc/google_drive_bloc.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
import 'package:Soc/src/modules/ocr/ui/assessment_summary.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

class ResultsSummary extends StatefulWidget {
  ResultsSummary({Key? key, required this.assessmentDetailPage, this.fileId})
      : super(key: key);
  final bool? assessmentDetailPage;
  final String? fileId;
  @override
  State<ResultsSummary> createState() => _ResultsSummaryState();
}

class _ResultsSummaryState extends State<ResultsSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.assessmentDetailPage!) {
      _driveBloc.add(GetAssessmentDetail(fileId: widget.fileId));
    }

    super.initState();
  }

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
              isBackButton: widget.assessmentDetailPage! ? true : false,
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
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.red,
                  //     )),
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
                  !widget.assessmentDetailPage!
                      ? listView(
                          Globals.studentInfo!,
                        )
                      : BlocBuilder(
                          bloc: _driveBloc,
                          builder:
                              (BuildContext contxt, GoogleDriveState state) {
                            if (state is AssessmentDetailSuccess) {
                              return listView(
                                state.obj,
                              );
                            } else if (state is GoogleNoAssessment) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                    child: Text(
                                  "No assessment available",
                                  style: Theme.of(context).textTheme.bodyText1!,
                                )),
                              );
                            }
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              )),
                            );
                          })
                ],
              ),
            ),
            floatingActionButton: !widget.assessmentDetailPage!
                ? Container(
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
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.086
                        : MediaQuery.of(context).size.width * 0.086,
                    width: MediaQuery.of(context).size.width * 0.9,
                    //  color: Colors.blue,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: Globals.ocrResultIcons
                          .map<Widget>((element) => _iconButton(
                              Globals.ocrResultIcons.indexOf(element)))
                          .toList(),

                      // [
                      //   Icon(Icons.star_border),
                      //   Icon(Icons.star_border),
                      //   Icon(Icons.star_border),
                      //   Icon(Icons.star_border),
                      // ],
                    ))
                : Container(),
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
                image: AssetImage(
                  "assets/images/drive_ico.png",
                ),
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

  Widget listView(List<StudentAssessmentInfo> _list) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.72
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length, // Globals.gradeList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(index, _list, context);
        },
      ),
    );
  }

  Widget _buildList(int index, List<StudentAssessmentInfo> _list, context) {
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
        // contentPadding:
        //     EdgeInsets.only(left: _kLabelSpacing, right: _kLabelSpacing / 2),
        leading:
            //  Text(_list[index].studentId!),

            Utility.textWidget(
                text: _list[index].studentName ?? 'Unknown',
                context: context,
                textTheme: Theme.of(context).textTheme.headline2!),

        trailing:
            // Text(_list[index].pointpossible!),
            Utility.textWidget(
                text: _list[index].studentGrade == ''
                    ? '2/2'
                    : '${_list[index].studentGrade}/2', // '${Globals.gradeList[index]} /2',
                context: context,
                textTheme: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
