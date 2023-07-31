// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/plus_common_widgets/plus_screen_title_widget.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../modules/graded_plus/widgets/common_ocr_appbar.dart';

// ignore: must_be_immutable
class CommonPdfViewerPage extends StatefulWidget {
  final String? url;
  String? title = '';
  String? language;
  bool? isHomePage;
  bool? isOCRFeature;
  bool? isBackButton;
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  final IconData? titleIconData;
  bool isBottomSheet;
  CommonPdfViewerPage(
      {Key? key,
      @required this.isOCRFeature,
      @required this.url,
      @required this.title,
      required this.isBottomSheet,
      required this.language,
      this.isBackButton,
      required this.isHomePage,
      this.titleIconData})
      : super(key: key);
  @override
  _CommonPdfViewerPageState createState() => _CommonPdfViewerPageState();
}

class _CommonPdfViewerPageState extends State<CommonPdfViewerPage> {
  @override
  void dispose() {
    super.dispose();
  }

  appBarOCRWidget() {
    return CustomOcrAppBarWidget(
        commonLogoPath: Color(0xff000000) == Theme.of(context).backgroundColor
            ? "assets/images/graded+_dark.png"
            : "assets/images/graded+_light.png",
        refresh: (v) {
          setState(() {});
        },
        iconData: widget.titleIconData,
        plusAppName: 'GRADED+',
        fromGradedPlus: true,
        isSuccessState: ValueNotifier<bool>(true),
        isBackOnSuccess: widget.isBackFromCamera,
        key: GlobalKey(),
        isBackButton: true);
  }

  // String? remotePDFpath;
  final ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  ValueNotifier<int> currentPage = ValueNotifier<int>(1);
  ValueNotifier<int> totalPage = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();

    createFileOfPdfUrl().then((f) {
      remotePDFpath.value = f.path;
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final url = widget.url!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isOCRFeature == true
            ? appBarOCRWidget()
            : widget.isHomePage == true
                ? null
                : CustomAppBarWidget(
                    isSearch: false,
                    isShare: true,
                    appBarTitle: widget.title!,
                    sharedPopBodyText: widget.url.toString(),
                    sharedPopUpHeaderText: "Please check out this",
                    language: Globals.selectedLanguage),
        body: ValueListenableBuilder(
            valueListenable: remotePDFpath,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Stack(children: <Widget>[
                widget.url != null && widget.url != ""
                    ? remotePDFpath.value == null || remotePDFpath.value == ''
                        ? Center(
                            child: CircularProgressIndicator(
                                color: widget.isOCRFeature == true
                                    ? AppTheme.kButtonColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryVariant))
                        : Stack(children: [
                            widget.isBackButton == true
                                ? ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: PlusScreenTitleWidget(
                                                kLabelSpacing: 0,
                                                text: widget.title ?? '',
                                                backButton: true,
                                                backButtonOnTap: () {
                                                  Navigator.pop(context);
                                                })),
                                        Container(
                                            padding:
                                                EdgeInsets.only(bottom: 30),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: pdfWidget())
                                      ])
                                : pdfWidget(),
                            Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 50, right: 10),
                                      padding: const EdgeInsets.all(10.0),
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      child: ValueListenableBuilder(
                                          valueListenable: totalPage,
                                          child: Container(),
                                          builder: (BuildContext context,
                                              int value, Widget? child) {
                                            return ValueListenableBuilder(
                                                valueListenable: currentPage,
                                                child: Container(),
                                                builder: (BuildContext context,
                                                    int value, Widget? child) {
                                                  return FittedBox(
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10),
                                                          child: Text(
                                                              "${currentPage.value} / ${totalPage.value}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))));
                                                });
                                          }))
                                ])
                          ])
                    : NoDataFoundErrorWidget(
                        isResultNotFoundMsg: false,
                        isNews: false,
                        isEvents: false)
              ]);
            }));
  }

  Widget pdfWidget() {
    return PDFView(
        filePath: remotePDFpath.value,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        fitPolicy: FitPolicy.WIDTH,
        fitEachPage: true,
        preventLinkNavigation: false,
        onViewCreated: (PDFViewController pdfViewController) async {
          _controller.complete(pdfViewController);
        },
        // onLinkHandler: (String? uri) {
        //   print('goto uri: $uri');
        // },
        onPageChanged: (int? page, int? total) {
          totalPage.value = total!;
          currentPage.value = page! + 1;
        });
  }
}
