import 'dart:io';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  final ValueNotifier<String> url = ValueNotifier<String>('');
  // final _controller = PageController();

  String? pdfPath;
  PDFDocument? document;
  PDFDocument? document1;
  String? pdfUrl;
  bool? changePdf = false;
  // final refreshKey = GlobalKey<RefreshIndicatorState>();
  // HomeBloc _homeBloc = HomeBloc();

  changePDF() async {
    document = await PDFDocument.fromURL(
      widget.url!,
      cacheManager: CacheManager(
        Config(
          widget.url!,
          stalePeriod: const Duration(days: 0),
          maxNrOfCacheObjects: 0,
        ),
      ),
    ).then((value) => document1 = value);

    // if (changePdf!) {
    //   document = await PDFDocument.fromURL(
    //   widget.url!,
    //   // cacheManager: CacheManager(
    //   //   Config(
    //   //     widget.url!,
    //   //     stalePeriod: const Duration(days: 2),
    //   //     maxNrOfCacheObjects: 10,
    //   //   ),
    //   // ),
    // );
    // } else {
    //   document1 = await PDFDocument.fromURL(
    //   widget.url!,
    //   // cacheManager: CacheManager(
    //   //   Config(
    //   //     widget.url!,
    //   //     stalePeriod: const Duration(days: 2),
    //   //     maxNrOfCacheObjects: 10,
    //   //   ),
    //   // ),
    // );
    // }

    if (document != null) {
      setState(() => isLoading = false);
    }
  }
 void updateWidget(){
    setState(() {
      document1 = document;
    });
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
      File file = new File('$dir/${widget.url}.pdf');
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
    pdfUrl = widget.url;
    changePDF();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.url != null && widget.url != ""
        ? document1 == null
            ? Center(
                child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
              ))
            : new ListView(
                children: [
                  Container(
                    height: 40,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: PDFViewer(
                        // progressIndicator: CircularProgressIndicator(),
                        maxScale: 10,
                        document: document1!,
                        enableSwipeNavigation: true,
                        showIndicator: true,
                        lazyLoad: false,
                        showNavigation: false,
                        showPicker: false,
                        zoomSteps: 2,
                        scrollDirection: Axis.vertical,

                        // controller: _controller,
                      )),
                  // Container(
                  //   height: 0,
                  //   width: 0,
                  //   child: BlocListener<HomeBloc, HomeState>(
                  //       bloc: _homeBloc,
                  //       listener: (context, state) async {
                  //         if (state is BottomNavigationBarSuccess) {
                  //           AppTheme.setDynamicTheme(
                  //               Globals.appSetting, context);
                  //           // Globals.homeObject = state.obj;
                  //           Globals.appSetting =
                  //               AppSetting.fromJson(state.obj);
                  //           if (Globals.appSetting.isCustomApp! == false) {

                  //           }

                  //           setState(() {});
                  //         }
                  //       },
                  //       child: EmptyContainer()),
                  // ),
                ],
              )
        : NoDataFoundErrorWidget(
            isResultNotFoundMsg: false,
            isNews: false,
            isEvents: false,
          );
  }

  // onchange() {
  //   _controller.addListener(() {
  //     if (_controller.page == 0) {}
  //   });
  // }
  // Future refreshPage() async {
  //   refreshKey.currentState?.show(atTop: false);
  //   _homeBloc.add(FetchBottomNavigationBar());
  //   setState(() {
  //     changePDF();
  //   });
  // }
}
