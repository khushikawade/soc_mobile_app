import 'package:Soc/src/Globals.dart';
import 'package:Soc/src/modules/home/ui/search.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';
import '../overrides.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget(
      {Key? key,
      required this.isSearch,
      required this.isShare,
      required this.appBarTitle,
      required this.sharedpopUpheaderText,
      required this.sharedpopBodytext,
      this.isCenterIcon,
      this.ishtmlpage,
      required this.language})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? islinearProgress = false;
  String appBarTitle;
  bool? isSearch;
  bool? isShare;
  String? sharedpopBodytext;
  String? sharedpopUpheaderText;
  bool? ishtmlpage;
  bool? isCenterIcon;
  String? language;

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  static const double _kLabelSpacing = 15.0;
  static const double _kIconSize = 50.0;
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: BackButtonWidget(),
      title: widget.isCenterIcon != null && widget.isCenterIcon == true
          ? SizedBox(width: 100.0, height: 60.0, child: AppLogoWidget())
          : widget.language != null && widget.language != "English"
              ? TranslationWidget(
                  message: widget.appBarTitle,
                  fromLanguage: "en",
                  toLanguage: widget.language,
                  builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(
                  widget.appBarTitle,
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
      actions: [
        widget.isSearch == true
            ? SearchButtonWidget(
                language: widget.language,
              )
            : Container(
                height: 0,
              ),
        widget.isShare == true &&
                widget.isShare == true &&
                widget.sharedpopBodytext != 'null'
            ? IconButton(
                onPressed: () {
                  widget.sharedpopBodytext != null &&
                          widget.sharedpopUpheaderText != 'null' &&
                          widget.sharedpopBodytext!.length > 1
                      ? shareobj.callFunction(
                          context,
                          widget.sharedpopBodytext.toString(),
                          widget.sharedpopUpheaderText.toString())
                      : print("null");
                },
                icon: Icon(
                  Icons.share,
                  size: Globals.deviceType == "phone" ? 18 : 24,
                ),
              )
            : Container(),
        widget.ishtmlpage == true
            ? IconButton(
                onPressed: () {
                  widget.sharedpopBodytext != null &&
                          widget.sharedpopUpheaderText != 'null' &&
                          widget.sharedpopBodytext!.length > 1
                      ? shareobj.callFunction(
                          context,
                          widget.sharedpopBodytext.toString(),
                          widget.sharedpopUpheaderText.toString())
                      : print("null");
                },
                icon: Icon(
                  Icons.share,
                  size: Globals.deviceType == "phone" ? 18 : 24,
                ))
            : Container(
                height: 0,
              ),
        HorzitalSpacerWidget(_kLabelSpacing / 3)
      ],
    );
  }

  // _progressBar(double progress, BuildContext context) {
  //   return LinearProgressIndicator(
  //     backgroundColor: Colors.white70.withOpacity(0),
  //     value: progress == 1.0 ? 0 : progress,
  //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
  //   );
  // }
}
