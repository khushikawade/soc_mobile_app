import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/ui/common_ocr_appbar.dart';
import 'package:Soc/src/modules/ocr/ui/ocr_background_widget.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../google_drive/bloc/google_drive_bloc.dart';

class AssessmentSummary extends StatefulWidget {
  AssessmentSummary({Key? key}) : super(key: key);

  @override
  State<AssessmentSummary> createState() => _AssessmentSummaryState();
}

class _AssessmentSummaryState extends State<AssessmentSummary> {
  static const double _KVertcalSpace = 60.0;

  GoogleDriveBloc _driveBloc = GoogleDriveBloc();

  @override
  void initState() {
    // TODO: implement initState
    _driveBloc.add(GetSheetFromDrive());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonBackGroundImgWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerWidget(_KVertcalSpace * 0.50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: highlightText(
                    text: 'Assessment Summary',
                    theme: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpacerWidget(_KVertcalSpace / 3),
                BlocBuilder(
                    bloc: _driveBloc,
                    builder: (BuildContext contxt, GoogleDriveState state) {
                      if (state is GoogleDriveLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ));
                      } else if (state is GoogleDriveGetSuccess) {
                        return listView(state.obj);
                      } else if (state is GoogleNoAssessment) {
                        return Center(
                            child: Text(
                          "No assessment available",
                          style: Theme.of(context).textTheme.bodyText1!,
                        ));
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listView(List _list) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.75
          : MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: AppTheme.klistPadding),
        scrollDirection: Axis.vertical,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildList(_list, index);
        },
      ),
    );
  }

  Widget _buildList(List list, int index) {
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
              text: list[index].title.split('.')[0],
              theme: Theme.of(context).textTheme.headline2),
          // title: TranslationWidget(
          //     message: "No title",
          //     fromLanguage: "en",
          //     toLanguage: Globals.selectedLanguage,
          //     builder: (translatedMessage) {
          //       return Text(translatedMessage.toString(),
          //           style: Theme.of(context).textTheme.bodyText1!);
          //     }),
          trailing: Icon(Icons.arrow_forward_ios)),
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
