import 'package:Soc/src/modules/social/ui/socialeventdescription.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/inwebview.dart';
import 'package:Soc/src/widgets/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../overrides.dart';

// ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
  SliderWidget({
    required this.obj,
    required this.cuurentIndex,
    required this.issocialpage,
    required this.date,
  });
  var obj;
  int cuurentIndex;
  bool issocialpage;
  String date;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  static const double _kPadding = 16.0;
  static const double _KButtonSize = 110.0;
  var _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  int pageinitialIndex = 0;
  int pageViewCurrentIndex = 0;
  int pageviewLastIndex = 10;
  static const _kCurve = Curves.ease;
  var object;
  var link;
  var link2;

  @override
  void initState() {
    super.initState();
    pageviewLastIndex = 10;
    object = widget.obj;
  }

  Widget _buildItem(
    String newsLine,
    String newsTimeStamp,
  ) {
    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: Container(
        child: Column(
          children: [
            _buildnewsLines(newsLine),
            SpacerWidget(_kPadding / 2),
            _buildnewTimeStamp(newsTimeStamp),
            SpacerWidget(_kPadding * 4),
            // _buildbuttomsection(),
          ],
        ),
      ),
    );
  }

  Widget _buildnewTimeStamp(String newsTimeStamp) {
    return Row(
      children: [
        Container(
            child: Text(
          newsTimeStamp,
          style: Theme.of(context).textTheme.subtitle1,
        )),
      ],
    );
  }

  Widget _buildnewsLines(String newsLines) {
    return Column(
      children: [
        // heading1.isNotEmpty && heading1.length > 1
        // ?
        Expanded(
            child: Text(
          newsLines,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.headline2,
        )),
        // : Text("1"),
        SpacerWidget(_kPadding),

        // heading3.isNotEmpty && heading3.length > 1
        Expanded(
            child: Text(
          newsLines,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.headline2,
        )),
        // : Text("3"),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          elevation: 0.0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              const IconData(0xe80d,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
              color: AppTheme.kIconColor1,
              size: 20,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 100.0, height: 50.0, child: BearIconWidget()),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {});
                    if (widget.cuurentIndex > 0) {
                      _controller.previousPage(
                          duration: _kDuration, curve: _kCurve);
                      --widget.cuurentIndex;
                    }
                  },
                  icon: Icon(
                    const IconData(0xe80c,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: widget.cuurentIndex == 0
                        ? AppTheme.kDecativeIconColor
                        : AppTheme.kBlackColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            HorzitalSpacerWidget(_kPadding / 3),
            IconButton(
              onPressed: () async {
                setState(() {});
                if (widget.cuurentIndex < object.length - 1) {
                  _controller.nextPage(duration: _kDuration, curve: _kCurve);
                  ++widget.cuurentIndex;
                }
              },
              icon: (Icon(
                const IconData(0xe815,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: widget.cuurentIndex == widget.obj.length - 1
                    ? AppTheme.kDecativeIconColor
                    : AppTheme.kBlackColor,
                size: 20,
              )),
            ),
            HorzitalSpacerWidget(_kPadding / 3),
          ]),
      body: Column(children: <Widget>[
        Flexible(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.obj.length,
            onPageChanged: (indexnumber) {
              pageViewCurrentIndex = indexnumber;
              print(pageViewCurrentIndex);
            },
            itemBuilder: (BuildContext context, int index) {
              return widget.issocialpage
                  ? SocialDescription(object: object[widget.cuurentIndex])
                  : Container();

              //  Newdescription(
              //     newsobject: object[widget.cuurentIndex],
              //     date: widget.date,
              //   );
            },
          ),
        )
      ]),
      bottomSheet:
          widget.issocialpage ? buttomButtonsWidget(context) : Container(),
    );
  }

  Widget buttomButtonsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_kPadding / 2),
      color: AppTheme.kBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () async {
                _buildlink();
                // print(link2);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InAppBrowser(link: link2, isSocialpage: true)));
              },
              child: Text("More"),
            ),
          ),
          SizedBox(
            width: _kPadding / 2,
          ),
          SizedBox(
            width: _KButtonSize,
            height: _KButtonSize / 2,
            child: ElevatedButton(
              onPressed: () {
                _onShareWithEmptyOrigin(context);
              },
              child: Text("Share"),
            ),
          ),
        ],
      ),
    );
  }

  Future _buildlink() async {
    link = widget.obj[widget.cuurentIndex].link.toString();

    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(link);
    matches.forEach((match) {
      link2 = link.substring(match.start, match.end);
    });
    print(link2);
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body = widget.obj[widget.cuurentIndex].title["__cdata"] +
        widget.obj[widget.cuurentIndex].link.toString();
    ;

    await Share.share(body,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
