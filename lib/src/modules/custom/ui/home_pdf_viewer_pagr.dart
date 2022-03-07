import 'dart:io';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class HomePdfViewerPage extends StatefulWidget {
  final String? url;
  String? language;

  bool isbuttomsheet;
  HomePdfViewerPage(
      {Key? key,
      @required this.url,
 
      required this.isbuttomsheet,
      required this.language})
      : super(key: key);
  @override
  _HomePdfViewerPageState createState() => _HomePdfViewerPageState();
}

class _HomePdfViewerPageState extends State<HomePdfViewerPage> {
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
  void didUpdateWidget(covariant HomePdfViewerPage oldWidget) {
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
    return  widget.url != null && widget.url != ""
            ? document == null
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
                  ))
                : PDFViewer(
                    document: document!,
                    enableSwipeNavigation: true,
                    showIndicator: true,
                    lazyLoad: false,
                    showNavigation: false,
                    showPicker: false,
                    zoomSteps: 2,
                    scrollDirection: Axis.vertical,
                  )
            : NoDataFoundErrorWidget(
                isResultNotFoundMsg: false,
                isNews: false,
                isEvents: false,
              );
  }
}
