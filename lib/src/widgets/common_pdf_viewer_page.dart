import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CommonPdfViewerPage extends StatefulWidget {
  final String? url;
  String? tittle = '';
  bool isbuttomsheet;
  CommonPdfViewerPage(
      {Key? key,
      @required this.url,
      @required this.tittle,
      required this.isbuttomsheet})
      : super(key: key);
  @override
  _CommonPdfViewerPageState createState() => _CommonPdfViewerPageState();
}

class _CommonPdfViewerPageState extends State<CommonPdfViewerPage> {
  bool _isLoading = true;
  String? pdfPath;
  PDFDocument? document;

  changePDF() async {
    document = await PDFDocument.fromURL(
      widget.url!,
    );
    // print(document);
    if (document != null) {
      setState(() => _isLoading = false);
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
//_loadPdf();
    changePDF();
  }

  @override
  void initState() {
    super.initState();
    //_loadPdf();
    changePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: true,
          sharedpopBodytext: widget.url.toString(),
          sharedpopUpheaderText: "Please check out this",
        ),
        body: widget.url != null && widget.url != ""
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
            : Text("No Document Found"),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}

// CustomAppBarWidget
