import 'package:Soc/src/widgets/bearIconwidget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../overrides.dart';

class SocialAppUrlLauncher extends StatefulWidget {
  final String url;
  final bool? hideHeader;
  @override
  SocialAppUrlLauncher({Key? key, required this.url, this.hideHeader})
      : super(key: key);
  _SocialAppUrlLauncherState createState() => new _SocialAppUrlLauncherState();
}

class _SocialAppUrlLauncherState extends State<SocialAppUrlLauncher> {
  // launchUrl(url) async {
  //   if (await canLaunch(url)) {
  //     setState(() {
  //       _flag = false;
  //     });
  //     await launch(url);
  //     setState(() {
  //       _flag = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    const IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: Color(0xff171717),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          title: SizedBox(width: 100.0, height: 60.0, child: BearIconWidget()),
          // bottom: PreferredSize(
          //   child: _progressBar(lineProgress, context),
          //   preferredSize: Size.fromHeight(3.0),
          // ),
          actions: [
            Icon(Icons.share),
          ],
        ),
        body: WebView(
          initialUrl: '${widget.url}',
        ));
  }

  @override
  void dispose() {
    // _controller();
    // _animation1.di
    super.dispose();
  }
}
