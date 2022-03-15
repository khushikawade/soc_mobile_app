import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
  Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  // final _controller = PageController();

  String? pdfPath;
  PDFDocument? document;
  PDFDocument? document1;
  PDFDocument? doc;
  String? pdfUrl;
  bool stopScroll = true;
  // final refreshKey = GlobalKey<RefreshIndicatorState>();
  // HomeBloc _homeBloc = HomeBloc();

  // changePDF() async {
  //   document = await PDFDocument.fromURL(
  //     widget.url!,
  //     cacheManager: CacheManager(
  //       Config(
  //         widget.url!,
  //         stalePeriod: const Duration(days: 0),
  //         maxNrOfCacheObjects: 0,
  //       ),
  //     ),
  //   );
  //   // if (changePdf!) {
  //   //   document = await PDFDocument.fromURL(
  //   //   widget.url!,
  //   //   // cacheManager: CacheManager(
  //   //   //   Config(
  //   //   //     widget.url!,
  //   //   //     stalePeriod: const Duration(days: 2),
  //   //   //     maxNrOfCacheObjects: 10,
  //   //   //   ),
  //   //   // ),
  //   // );
  //   // } else {
  //   //   document1 = await PDFDocument.fromURL(
  //   //   widget.url!,
  //   //   // cacheManager: CacheManager(
  //   //   //   Config(
  //   //   //     widget.url!,
  //   //   //     stalePeriod: const Duration(days: 2),
  //   //   //     maxNrOfCacheObjects: 10,
  //   //   //   ),
  //   //   // ),
  //   // );
  //   // }

  //   if (document != null) {
  //     setState(() => isLoading = false);
  //   }
  // }

  // void updateWidget() {
  //   setState(() {
  //     document1 = document;
  //   });
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
  //     File file = new File('$dir/new_pdf.pdf');
  //     await file.writeAsBytes(rs.data!);
  //     return file;
  //   } else {
  //     return null!;
  //   }
  // }

  @override
  void didUpdateWidget(covariant HomePdfViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    //  createFileOfPdfUrl(widget.url).then((f) async {
    //    File file = File(f.path);
    //     doc = await PDFDocument.fromFile(file);
    //     setState(()  {

    //       isLoading = false;
    //     });
    //   });
    // changePDF();
  }

  @override
  void initState() {
    super.initState();
    pdfUrl = widget.url;
    // changePDF();
    // createFileOfPdfUrl(widget.url).then((f) async {
    //   File file = File(f.path);
    //     doc = await PDFDocument.fromFile(file);
    //   setState(()  {

    //     isLoading = false;
    //   });
    // });
  }
  //  Future<File> createFileOfPdfUrl() async {
  //   Completer<File> completer = Completer();
  //   print("Start download file from internet!");
  //   try {
  //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
  //     // final url = "https://pdfkit.org/docs/guide.pdf";
  //     final url = widget.url;
  //     final filename = url.substring(url.lastIndexOf("/") + 1);
  //     var request = await HttpClient().getUrl(Uri.parse(url));
  //     var response = await request.close();
  //     var bytes = await consolidateHttpClientResponseBytes(response);
  //     var dir = await getApplicationDocumentsDirectory();
  //     print("Download files");
  //     print("${dir.path}/$filename");
  //     File file = File("${dir.path}/$filename");

  //     await file.writeAsBytes(bytes, flush: true);
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }

  //   return completer.future;
  // }

  @override
  Widget build(BuildContext context) {
    return
        // widget.url != null && widget.url != ""
        //     ? doc == null
        //         ? Center(
        //             child: CircularProgressIndicator(
        //             valueColor:
        //                 new AlwaysStoppedAnimation<Color>(Color(0xff4B80A5)),
        //           ))
        //         : new
        ListView(
      shrinkWrap: true,
      physics: stopScroll ? NeverScrollableScrollPhysics() : null,
      //   scrollDirection: Axis.values,
      children: [
        Container(
          height: 40,
        ),
        Container(
            // color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: PDF(
                    pageFling: true,
                    fitPolicy: FitPolicy.HEIGHT,

                    // fitEachPage: true,
                    // autoSpacing: true,
                    swipeHorizontal: false,
                    enableSwipe: true,
                    gestureRecognizers: Set()
                      ..add(Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer()
                            ..onDown = (DragDownDetails dragDownDetails) {
                              setState(() {
                                stopScroll = false;
                              });
                            }
                            ..onStart = (DragStartDetails dragStartDetails) {
                              setState(() {
                                stopScroll = true;
                              });
                            })))
                .cachedFromUrl(
              widget.url!,
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            )
            //         SfPdfViewer.network(
            // widget.url!,
            // enableDoubleTapZooming: true,

            // )

            //     PDFViewer(
            //   // progressIndicator: CircularProgressIndicator(),
            //   maxScale: 10,
            //   document: doc!,
            //   enableSwipeNavigation: true,
            //   showIndicator: true,
            //   lazyLoad: false,
            //   showNavigation: false,
            //   showPicker: false,
            //   zoomSteps: 2,
            //   scrollDirection: Axis.vertical,

            //   // controller: _controller,
            // )
            ),
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
    );
    // : NoDataFoundErrorWidget(
    //     isResultNotFoundMsg: false,
    //     isNews: false,
    //     isEvents: false,
    //   );
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
