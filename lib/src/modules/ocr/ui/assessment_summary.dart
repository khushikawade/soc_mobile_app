import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/google_drive/model/assessment.dart';
import 'package:Soc/src/modules/ocr/modal/student_assessment_info_modal.dart';
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
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import '../../../services/local_database/local_db.dart';
import '../../google_drive/bloc/google_drive_bloc.dart';
import '../widgets/searchbar_widget.dart';
// import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
// import 'package:Soc/src/modules/ocr/widgets/bottom_sheet_widget.dart';

class AssessmentSummary extends StatefulWidget {
  bool isFromHomeSection;
  AssessmentSummary({Key? key, required this.isFromHomeSection})
      : super(key: key);
  @override
  State<AssessmentSummary> createState() => _AssessmentSummaryState();
}

class _AssessmentSummaryState extends State<AssessmentSummary> {
  static const double _KVertcalSpace = 60.0;
  GoogleDriveBloc _driveBloc = GoogleDriveBloc();
  GoogleDriveBloc _driveBloc2 = GoogleDriveBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
//  OcrBloc _ocrBloc = OcrBloc();
  TextEditingController searchAssessmentController = TextEditingController();

  final ValueNotifier<bool> isSearch = ValueNotifier<bool>(false);
  LocalDatabase<StudentAssessmentInfo> _historyStudentInfoDb =
      LocalDatabase('history_student_info');
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
          WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              appBar: CustomOcrAppBarWidget(
                isSuccessState: ValueNotifier<bool>(true),
                isbackOnSuccess: isBackFromCamera,
                key: GlobalKey(),
                isBackButton: widget.isFromHomeSection,
                assessmentDetailPage: true,
                assessmentPage: true,
                scaffoldKey: _scaffoldKey,
                isFromResultSection:
                    widget.isFromHomeSection == false ? true : null,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SpacerWidget(_KVertcalSpace / 4),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 30),
                    child: SearchBar(
                      isSearchPage: false,
                      isSubLearningPage: false,
                      controller: searchAssessmentController,
                      onSaved: (String value) {
                        if (value != null && value.isNotEmpty) {
                          isSearch.value = true;

                          //Calling local search only
                          _driveBloc2
                              .add(GetAssessmentSearchDetails(keyword: value));
                        }
                      },
                      onTap: () {
                        // print('taped');
                      },
                    ),
                  ),
                  SpacerWidget(_KVertcalSpace / 5),
                  ValueListenableBuilder(
                      valueListenable: isSearch,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return BlocConsumer(
                          bloc: isSearch.value == false
                              ? _driveBloc
                              : _driveBloc2,
                          builder:
                              (BuildContext contxt, GoogleDriveState state) {
                            if (state is GoogleDriveGetSuccess) {
                              return state.obj!.length > 0
                                  ? Expanded(child: listView(state.obj!))
                                  : Expanded(
                                      child: NoDataFoundErrorWidget(
                                          isResultNotFoundMsg: true,
                                          isNews: false,
                                          isEvents: false),
                                    );
                            } else if (state is GoogleDriveLoading) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                )),
                              );
                            }

                            return Container();
                          },
                          listener: (BuildContext contxt,
                              GoogleDriveState state) async {
                            if (state is ErrorState) {
                              if (state.errorMsg ==
                                  'Reauthentication is required') {
                                await Utility.refreshAuthenticationToken(
                                    isNavigator: false,
                                    errorMsg: state.errorMsg!,
                                    context: context,
                                    scaffoldKey: _scaffoldKey);

                                _driveBloc.add(GetHistoryAssessmentFromDrive());
                              } else {
                                Navigator.of(context).pop();
                                Utility.currentScreenSnackBar(
                                    "Something Went Wrong. Please Try Again.");
                              }
                            }
                          },
                        );
                      }),
                ],
              ),
            ),
          )
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
    return Column(
      children: [
        InkWell(
          onTap: () async {
            bool createdAsPremium = false;
            if (list[index].isCreatedAsPremium == "true") {
              createdAsPremium = true;
            }
            await _historyStudentInfoDb.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultsSummary(

                        createdAsPremium: createdAsPremium,
                        obj: list[index],
                        asssessmentName: list[index].title!,
                        shareLink: list[index].webContentLink,
                        fileId: list[index].fileid,
                        assessmentDetailPage: true,
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                color: (index % 2 == 0)
                    ? Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff162429)
                        : Color(
                            0xffF7F8F9) //Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.background ==
                            Color(0xff000000)
                        ? Color(0xff111C20)
                        : Color(0xffE9ECEE)),
            child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                subtitle: Utility.textWidget(
                    context: context,
                    textTheme: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Colors.grey.shade500),
                    text: list[index].modifiedDate != null
                        ? Utility.convertTimestampToDateFormat(
                            DateTime.parse(list[index].modifiedDate!),
                            "MM/dd/yy")
                        : ""),
                title: Utility.textWidget(
                    text: list[index].title!.split('.')[0],
                    context: context,
                    textTheme: Theme.of(context).textTheme.headline2),
                // subtitle:
                trailing: GestureDetector(
                  onTap: () {
                    Utility.updateLoges(
                        activityId: '13',
                        sessionId: list[index].sessionId != ''
                            ? list[index].sessionId
                            : '',
                        description:
                            'Teacher tap on Share Button on assessment summery page',
                        operationResult: 'Success');
                    list[index].webContentLink != null &&
                            list[index].webContentLink != ''
                        ? Share.share(list[index].webContentLink!)
                        : print("no web link $index");
                  },
                  child: Icon(
                    IconData(Globals.ocrResultIcons[0],
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color:
                        Color(0xff000000) != Theme.of(context).backgroundColor
                            ? Color(0xff111C20)
                            : Color(0xffF7F8F9),
                    size: Globals.deviceType == 'phone' ? 28 : 38,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _driveBloc.add(GetHistoryAssessmentFromDrive());
  }
}
