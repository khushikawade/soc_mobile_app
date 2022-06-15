import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/widgets/ocr_background_widget.dart';
import 'package:Soc/src/modules/ocr/ui/results_summary.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
// import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
// import 'package:Soc/src/modules/ocr/widgets/bottom_sheet_widget.dart';

class AssessmentSummary extends StatefulWidget {
  AssessmentSummary({Key? key}) : super(key: key);
  @override
  State<AssessmentSummary> createState() => _AssessmentSummaryState();
}

class _AssessmentSummaryState extends State<AssessmentSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  @override
  void initState() {
    _driveBloc.add(GetHistoryAssessmentFromDrive());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.kButtonColor,
      key: refreshKey,
      onRefresh: refreshPage,
      child: Stack(
        children: [
          CommonBackGroundImgWidget(),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomOcrAppBarWidget(
              isbackOnSuccess: isBackFromCamera,
              key: GlobalKey(),
              isBackButton: true,
              assessmentDetailPage: true,
              assessmentPage: true,
              scaffoldKey: _scaffoldKey,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SpacerWidget(_KVertcalSpace * 0.50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Utility.textWidget(
                    text: 'Assessment History',
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpacerWidget(_KVertcalSpace / 3),
                BlocBuilder(
                    bloc: _driveBloc,
                    builder: (BuildContext contxt, GoogleDriveState state) {
                      if (state is GoogleDriveGetSuccess) {
                        return state.obj!.length > 0
                            ? Expanded(child: listView(state.obj!))
                            : Expanded(
                                child: NoDataFoundErrorWidget(
                                    isResultNotFoundMsg: true,
                                    isNews: false,
                                    isEvents: false),
                              );
                      }
                      return Container(
                          // height: MediaQuery.of(context).size.height * 0.7,
                          // child: Center(
                          //     child: CircularProgressIndicator(
                          //   color: Theme.of(context).colorScheme.primaryVariant,
                          // )),
                          );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(List<HistoryAssessment> _list) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.792
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        // padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(_list, index);
        },
      ),
    );
  }

  Widget _buildList(List<HistoryAssessment> list, int index) {
    return InkWell(
      onTap: () {
        print(list[index].fileid);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultsSummary(
                    fileId: list[index].fileid,
                    assessmentDetailPage: true,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(
            //   // color: Theme.of(context).colorScheme.background,
            //   // width: 0.65,
            // ),
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff162429)
                    : Color(
                        0xffF7F8F9) //Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.background == Color(0xff000000)
                    ? Color(0xff111C20)
                    : Color(0xffE9ECEE)),
        child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            leading: Utility.textWidget(
                text: list[index].title!.split('.')[0],
                context: context,
                textTheme: Theme.of(context).textTheme.headline2),
            trailing: InkWell(
              onTap: () {
                list[index].webContentLink != null &&
                        list[index].webContentLink != ''
                    ? Share.share(list[index].webContentLink!)
                    : print("no web link $index");
              },
              child: Icon(
                IconData(Globals.ocrResultIcons[0],
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: Color(0xff000000) != Theme.of(context).backgroundColor
                    ? Color(0xff111C20)
                    : Color(0xffF7F8F9),
              ),
            )),
      ),
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _driveBloc.add(GetHistoryAssessmentFromDrive());
  }
}
