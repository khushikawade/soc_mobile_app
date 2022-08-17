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

  String? remotePDFpath;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
    super.initState();

    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = widget.url!; //"http://www.pdf995.com/samples/pdf.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      // print("Download files");
      // print("${dir.path}/$filename");
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
      body: Stack(
        children: <Widget>[
          widget.url != null && widget.url != ""
              ? remotePDFpath == null
                  ? Center(
                      child: CircularProgressIndicator(
                      color: widget.isOCRFeature == true
                          ? AppTheme.kButtonColor
                          : Theme.of(context).colorScheme.primaryVariant,
                      // valueColor:
                      //     new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
                    ))
                  : PDFView(
                      filePath: remotePDFpath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: true,
                      pageSnap: true,
                      // defaultPage: currentPage!,
                      fitPolicy: FitPolicy.WIDTH,
                      fitEachPage: true,
                      // nightMode: Theme.of(context).colorScheme.background ==
                      //         Color(0xff000000)
                      //     ? true
                      //     : false,
                      preventLinkNavigation: false,
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        print('goto uri: $uri');
                      },
                    )
              : NoDataFoundErrorWidget(
                  isResultNotFoundMsg: false,
                  isNews: false,
                  isEvents: false,
                ),
        ],
      ),
    );
  }
}
