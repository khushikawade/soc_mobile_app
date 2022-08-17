import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  bool isLoading = true;

  String? pdfPath;
  PDFDocument? document;

  changePDF() async {
    document = await PDFDocument.fromURL(
      widget.url!,
    );
    if (document != null) {
      setState(() => isLoading = false);
    }
  }

  Future<File> createFileOfPdfUrl(_url) async {
    if (_url != null && _url != "") {
      Response<List<int>> rs = await Dio().get<List<int>>(
        _url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (int sent, int total) {
          if (!mounted) return;
        },
      );
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/tempdoc.pdf');
      await file.writeAsBytes(rs.data!);
      return file;
    } else {
      return null!;
    }
  }

  @override
  void didUpdateWidget(covariant CommonPdfViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    changePDF();
  }

  @override
  void initState() {
    super.initState();
    changePDF();
  }

  @override
  void dispose() {
    super.dispose();
  }

  appBarOCRWidget() {
    return CustomOcrAppBarWidget(
      isSuccessState: ValueNotifier<bool>(true),
      isbackOnSuccess: widget.isBackFromCamera,
      key: GlobalKey(),
      isBackButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
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
        body: widget.url != null && widget.url != ""
            ? document == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
                  ))
                : Padding(
                    // Todo: padding from bottom by which user can view long pdf to.
                    padding: EdgeInsets.only(bottom: 20),
                    child: PDFViewer(
                      document: document!,
                      enableSwipeNavigation: true,
                      lazyLoad: false,
                      progressIndicator: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                      showIndicator: true,
                      showNavigation: false,
                      showPicker: false,
                      zoomSteps: 2,
                      scrollDirection: Axis.vertical,
                    ),
                  )
            : NoDataFoundErrorWidget(
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
              ));
  }
}
