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

class _HomePdfViewerPageState extends State<HomePdfViewerPage>
    with WidgetsBindingObserver {
  bool isLoading = true;
  final ValueNotifier<String> url = ValueNotifier<String>('');
  Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  String? pdfPath;
  String? pdfUrl;
  bool stopScroll = true;
  var pdfViewerKey = UniqueKey();

  @override
  void didUpdateWidget(covariant HomePdfViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    pdfUrl = widget.url;
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      Future.delayed(Duration(milliseconds: 250), () {
        setState(() => pdfViewerKey = UniqueKey());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: stopScroll ? NeverScrollableScrollPhysics() : null,
      children: [
        Container(
          height: 25,
        ),
        Container(

            // Theme.of(context).colorScheme.primaryVariant,
            height: MediaQuery.of(context).size.height * 4,
            width: MediaQuery.of(context).size.width,
            child: PDF(
                    //night mode work only with android not ios
                    // nightMode: true,
                    // pageSnap: true,
                    pageFling: true,
                    fitPolicy: FitPolicy.WIDTH,
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
              placeholder: (progress) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (error) => Center(child: Text(error.toString())),
            )),
      ],
    );
  }
}
