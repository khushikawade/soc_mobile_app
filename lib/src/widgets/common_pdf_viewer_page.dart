import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../modules/ocr/widgets/common_ocr_appbar.dart';

// ignore: must_be_immutable
class CommonPdfViewerPage extends StatefulWidget {
  final String? url;
  String? tittle = '';
  String? language;
  bool? isHomePage;
  bool? isOCRFeature;
  final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);

  bool isbuttomsheet;
  CommonPdfViewerPage(
      {Key? key,
      @required this.isOCRFeature,
      @required this.url,
      @required this.tittle,
      required this.isbuttomsheet,
      required this.language,
      required this.isHomePage})
      : super(key: key);
  @override
  _CommonPdfViewerPageState createState() => _CommonPdfViewerPageState();
}

class _CommonPdfViewerPageState extends State<CommonPdfViewerPage> {
  // bool isLoading = true;

  // String? pdfPath;
  // PDFDocument? document;

  // changePDF() async {
  //   document = await PDFDocument.fromURL(
  //     widget.url!,
  //   );
  //   if (document != null) {
  //     setState(() => isLoading = false);
  //   }
  // }

  // Future<File> createFileOfPdfUrl(_url) async {
  //   if (_url != null && _url != "") {
  //     Response<List<int>> rs = await Dio().get<List<int>>(
  //       _url,
  //       options: Options(responseType: ResponseType.bytes),
  //       onReceiveProgress: (int sent, int total) {
  //         if (!mounted) return;
  //       },
  //     );
  //     String dir = (await getApplicationDocumentsDirectory()).path;
  //     File file = new File('$dir/tempdoc.pdf');
  //     await file.writeAsBytes(rs.data!);
  //     return file;
  //   } else {
  //     return null!;
  //   }
  // }

  // @override
  // void didUpdateWidget(covariant CommonPdfViewerPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   changePDF();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   changePDF();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  appBarOCRWidget() {
    return CustomOcrAppBarWidget(
      isSuccessState: ValueNotifier<bool>(true),
      isbackOnSuccess: widget.isBackFromCamera,
      key: GlobalKey(),
      isBackButton: true,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       // backgroundColor: Colors.white,
  //       appBar: widget.isOCRFeature == true
  //           ? appBarOCRWidget()
  //           : widget.isHomePage == true
  //               ? null
  //               : CustomAppBarWidget(
  //                   isSearch: false,
  //                   isShare: true,
  //                   appBarTitle: widget.tittle!,
  //                   sharedpopBodytext: widget.url.toString(),
  //                   sharedpopUpheaderText: "Please check out this",
  //                   language: Globals.selectedLanguage,
  //                 ),
  //       body: widget.url != null && widget.url != ""
  //           ? document == null
  //               ? Center(
  //                   child: CircularProgressIndicator(
  //                   color: Theme.of(context).colorScheme.primaryVariant,
  //                   valueColor:
  //                       new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
  //                 ))
  //               : Padding(
  //                   // Todo: padding from bottom by which user can view long pdf to.
  //                   padding: EdgeInsets.only(bottom: 20),
  //                   child: PDFViewer(
  //                     document: document!,
  //                     enableSwipeNavigation: true,
  //                     lazyLoad: false,
  //                     progressIndicator: CircularProgressIndicator(
  //                       color: Theme.of(context).colorScheme.primaryVariant,
  //                     ),
  //                     // navigationBuilder: (p0, pageNumber, totalPages,
  //                     //         jumpToPage, animateToPage) =>
  //                     //     Container(),

  //                     showIndicator: true,
  //                     showNavigation: false,
  //                     showPicker: false,
  //                     zoomSteps: 2,
  //                     scrollDirection: Axis.vertical,
  //                   ),
  //                 )
  //           : NoDataFoundErrorWidget(
  //               isResultNotFoundMsg: false,
  //               isNews: false,
  //               isEvents: false,
  //             ));
  // }

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
      // setState(() {
      remotePDFpath.value = f.path;
      // });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    // print("Start download file from internet!");
    try {
      final url = widget.url!; //"http://www.pdf995.com/samples/pdf.pdf";
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
                    appBarTitle: widget.tittle!,
                    sharedpopBodytext: widget.url.toString(),
                    sharedpopUpheaderText: "Please check out this",
                    language: Globals.selectedLanguage,
                  ),
        body: ValueListenableBuilder(
            valueListenable: remotePDFpath,
            child: Container(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Stack(
                children: <Widget>[
                  widget.url != null && widget.url != ""
                      ? remotePDFpath.value == null || remotePDFpath.value == ''
                          ? Center(
                              child: CircularProgressIndicator(
                              color: widget.isOCRFeature == true
                                  ? AppTheme.kButtonColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                              // valueColor:
                              //     new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
                            ))
                          : Stack(children: [
                              PDFView(
                                filePath: remotePDFpath.value,
                                enableSwipe: true,
                                swipeHorizontal: false,
                                autoSpacing: false,
                                pageFling: true,
                                pageSnap: true,
                                fitPolicy: FitPolicy.WIDTH,
                                fitEachPage: true,
                                preventLinkNavigation: false,
                                onViewCreated: (PDFViewController
                                    pdfViewController) async {
                                  _controller.complete(pdfViewController);
                                },
                                onLinkHandler: (String? uri) {
                                  print('goto uri: $uri');
                                },
                                onPageChanged: (int? page, int? total) {
                                  totalPage.value = total!;
                                  currentPage.value = page! + 1;
                                },
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 10, right: 10),
                                      padding: const EdgeInsets.all(10.0),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                      ),
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
                                                      padding: EdgeInsets.only(
                                                          right: 10, left: 10),
                                                      child: Text(
                                                        "${currentPage.value} / ${totalPage.value}",
                                                        // "999 / 1000",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          })),
                                ],
                              )
                            ])
                      : NoDataFoundErrorWidget(
                          isResultNotFoundMsg: false,
                          isNews: false,
                          isEvents: false,
                        ),
                ],
              );
            }));
  }
}
