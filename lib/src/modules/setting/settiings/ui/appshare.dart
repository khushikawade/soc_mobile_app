import 'package:Soc/src/modules/setting/settiings/ui/test.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareApp extends StatefulWidget {
  ShareApp({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  static const double _kPadding = 16.0;
  static const double _kiconsize = 30.0;
  static const double _kbuttonsize = 50.0;

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }

  Widget _buildsharebutton(String label, String buttonicon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kPadding, vertical: _kPadding / 2.5),
      child: Container(
        color: AppTheme.kButtonbackColor,
        height: _kbuttonsize,
        // width: _kbuttonsize * 2,
        child: InkWell(
          onTap: () => _onShareWithEmptyOrigin(context),
          // FlutterShare.share('check out my website https://example.com',
          //     subject: 'Look what I made!');

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => DemoApp()));

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                  height: _kiconsize,
                  width: _kiconsize * 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      buttonicon,
                      fit: BoxFit.fill,
                      height: _kiconsize,
                      width: _kiconsize * 2,
                    ),
                  )),
              HorzitalSpacerWidget(_kPadding * 2),
              Text(
                label,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildsharebutton(
              "Share via Twitter",
              'assets/images/twitter_img.png',
            ),
            _buildsharebutton(
              "Share via Facebook",
              'assets/images/facebookthumb.png',
            ),
            _buildsharebutton(
              "Rate in Google Play",
              'assets/images/Mobile_img.png',
            ),
            _buildsharebutton(
              "Mail in Link",
              'assets/images/email.png',
            ),
          ],
        ),
      ),
    );
  }
}
