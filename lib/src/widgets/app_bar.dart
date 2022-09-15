import 'package:Soc/src/globals.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_logo_widget.dart';
import 'package:Soc/src/widgets/backbuttonwidget.dart';
import 'package:Soc/src/widgets/hori_spacerwidget.dart';
import 'package:Soc/src/widgets/searchbuttonwidget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget({
    Key? key,
    required this.isSearch,
    required this.isShare,
    required this.appBarTitle,
    required this.sharedpopUpheaderText,
    required this.sharedpopBodytext,
    this.isCenterIcon,
    this.ishtmlpage,
    this.marginLeft,
    required this.language,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  double? marginLeft;
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
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: BackButtonWidget(),
      title: widget.isCenterIcon != null && widget.isCenterIcon == true
          ? AppLogoWidget(
              marginLeft: widget.marginLeft,
            )
          : TranslationWidget(
              message: widget.appBarTitle,
              fromLanguage: "en",
              toLanguage: Globals.selectedLanguage,
              builder: (translatedMessage) => Text(
                translatedMessage.toString(),
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
      actions: [
        widget.isSearch == true
            ? SearchButtonWidget(
                language: Globals.selectedLanguage,
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
                  size: Globals.deviceType == "phone" ? 20 : 28,
                ),
              )
            : Container(),
        HorzitalSpacerWidget(_kLabelSpacing / 3)
      ],
    );
  }
}
