import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/ocr/widgets/common_ocr_appbar.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class OcrPdfViewer extends StatefulWidget {
  final String? url;
  String? tittle = '';
  String? language;

  bool isbuttomsheet;
  OcrPdfViewer({
    Key? key,
    @required this.url,
    @required this.tittle,
    required this.isbuttomsheet,
    required this.language,
  }) : super(key: key);
  @override
  _OcrPdfViewerState createState() => _OcrPdfViewerState();
}

class _OcrPdfViewerState extends State<OcrPdfViewer> {
  // bool isLoading = true;

  String? pdfPath;
  PDFDocument? document;
 final ValueNotifier<bool> isBackFromCamera = ValueNotifier<bool>(false);
  changePDF() async {
    document = await PDFDocument.fromURL(
      widget.url!,
    );
    if (document != null) {
      // setState(() => isLoading = false);
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
  void didUpdateWidget(covariant OcrPdfViewer oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: CustomOcrAppBarWidget(key: GlobalKey(), isBackButton: true,isbackOnSuccess: isBackFromCamera),
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
