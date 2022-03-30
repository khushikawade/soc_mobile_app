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
  String? pdfPath;
  String? pdfUrl;
  bool stopScroll = true;

  @override
  void didUpdateWidget(covariant HomePdfViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    pdfUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: stopScroll ? NeverScrollableScrollPhysics() : null,
      children: [
        Container(
          height: 40,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: PDF(
                    pageSnap: true,
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
