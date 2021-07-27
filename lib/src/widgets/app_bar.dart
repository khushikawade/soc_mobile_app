import 'package:Soc/src/modules/home/ui/search.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../overrides.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({
    Key? key,
    required this.isSearch,
    required this.isShare,
    required this.sharedpopUpheaderText,
    required this.sharedpopBodytext,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? islinearProgress = false;

  bool? isSearch;
  bool? isShare;
  String? sharedpopBodytext;
  String? sharedpopUpheaderText;

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  static const double _kLabelSpacing = 15.0;
  static const double _kIconSize = 50.0;
  double lineProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: _kLabelSpacing, left: _kLabelSpacing / 1.5),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                const IconData(0xe80d,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kIconColor1,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
      actions: [
        widget.isSearch == true
            ? IconButton(
                onPressed: () {
                  // print(widget.isSearch);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                                isbuttomsheet: true,
                              )));
                },
                icon: Icon(
                  const IconData(0xe805,
                      fontFamily: Overrides.kFontFam,
                      fontPackage: Overrides.kFontPkg),
                ))
            : Container(),
        widget.isShare == true &&
                widget.isShare == true &&
                widget.sharedpopBodytext != 'null'
            ? IconButton(
                onPressed: () {
                  widget.sharedpopBodytext != null &&
                          widget.sharedpopUpheaderText != 'null' &&
                          widget.sharedpopBodytext!.length > 1
                      ? _onShareWithEmptyOrigin(
                          context,
                          widget.sharedpopBodytext.toString(),
                          widget.sharedpopUpheaderText.toString())
                      : print("null");
                },
                icon: Icon(Icons.share),
              )
            : Container(),
        HorzitalSpacerWidget(_kLabelSpacing / 3)
      ],
    );
  }

  _onShareWithEmptyOrigin(
      BuildContext context, String body, String subject) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body1 = body;
    // "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
    final subject1 = subject;
    await Share.share(body1,
        subject: subject1,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  // _progressBar(double progress, BuildContext context) {
  //   return LinearProgressIndicator(
  //     backgroundColor: Colors.white70.withOpacity(0),
  //     value: progress == 1.0 ? 0 : progress,
  //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
  //   );
  // }
}
