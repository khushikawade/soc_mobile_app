import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../../../../overrides.dart';

class ShareApp extends StatefulWidget {
  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  static const double _kPadding = 16.0;
  static const double _kiconsize = 30.0;
  static const double _kbuttonsize = 50.0;
  // GlobalKey<SharePopupState> _myKey = GlobalKey();

  _onShareWithEmptyOrigin(BuildContext context) async {
    RenderBox? box = context.findRenderObject() as RenderBox;
    final String body =
        "Hi, I downloaded the PS 456 Bronx Bears app. You should check it out! Download the app at https://play.google.com/store/apps/details?id=com.app.p1676CB";
    final subject = "Love the PS 456 Bronx Bears app!";
    await Share.share(body,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget _buildsharebutton(String label, IconData buttonicon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kPadding, vertical: _kPadding / 2.5),
      child: Container(
        color: AppTheme.kButtonbackColor,
        height: _kbuttonsize,
        child: InkWell(
          onTap: () {
            _onShareWithEmptyOrigin(context);
          },
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
                      child: Icon(
                        buttonicon,
                        color: AppTheme.kIconColor3,
                      ))),
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
      appBar: CustomAppBarWidget(
        isSearch: false,
        isShare: false,
        sharedpopBodytext: '',
        sharedpopUpheaderText: '',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppTheme.kListBackgroundColor2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildsharebutton(
              "Share via Twitter",
              const IconData(0xe818,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
            ),
            _buildsharebutton(
              "Share via Facebook",
              const IconData(0xe81b,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
            ),
            _buildsharebutton(
              "Rate in Google Play",
              const IconData(0xe81a,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
            ),
            _buildsharebutton(
              "Mail in Link",
              const IconData(0xe819,
                  fontFamily: Overrides.kFontFam,
                  fontPackage: Overrides.kFontPkg),
            ),
          ],
        ),
      ),
    );
  }
}
