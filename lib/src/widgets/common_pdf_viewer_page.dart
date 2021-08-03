import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/internalbuttomnavigation.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class CommonPdfViewerPage extends StatefulWidget {
  final String? url;
  String? tittle = '';
  String? language;

  bool isbuttomsheet;
  CommonPdfViewerPage(
      {Key? key,
      @required this.url,
      @required this.tittle,
      required this.isbuttomsheet,
      required this.language})
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
        appBar: CustomAppBarWidget(
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
            : Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Globals.selectedLanguage != null &&
                        Globals.selectedLanguage != "English"
                    ? TranslationWidget(
                        message: "No Document Found",
                        fromLanguage: "en",
                        toLanguage: Globals.selectedLanguage,
                        builder: (translatedMessage) => Text(
                          translatedMessage.toString(),
                        ),
                      )
                    : Text("No Document Found"),
              ),
        bottomNavigationBar: widget.isbuttomsheet && Globals.homeObjet != null
            ? InternalButtomNavigationBar()
            : null);
  }
}
