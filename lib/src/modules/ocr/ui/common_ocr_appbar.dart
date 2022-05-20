import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/home.dart';
import 'package:Soc/src/modules/staff/ui/staff.dart';
import 'package:Soc/src/overrides.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sharepopmenu.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOcrAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  CustomOcrAppBarWidget(
      {Key? key, required this.isBackButton, this.isTitle, this.isFailureState})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  bool? isFailureState;
  bool? isBackButton;
  bool? isTitle;

  @override
  final Size preferredSize;

  @override
  _CustomOcrAppBarWidgetState createState() => _CustomOcrAppBarWidgetState();
}

class _CustomOcrAppBarWidgetState extends State<CustomOcrAppBarWidget> {
  double lineProgress = 0.0;
  SharePopUp shareobj = new SharePopUp();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: widget.isFailureState == true ? 200 : null,
      automaticallyImplyLeading: false,
      leading: widget.isFailureState == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                highlightText(
                    text: 'Scane Failure',
                    theme: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffCF6679),
                  ),
                  child: Icon(
                      IconData(0xe838,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      size: 19,
                      color: Colors.white),
                ),
              ],
            )
          : widget.isBackButton == true
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    IconData(0xe80d,
                        fontFamily: Overrides.kFontFam,
                        fontPackage: Overrides.kFontPkg),
                    color: AppTheme.kButtonColor,
                  ),
                )
              : null,
      actions: [
        Container(
            padding: widget.isFailureState != true
                ? EdgeInsets.only(right: 10)
                : EdgeInsets.zero,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (_) => false);
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => HomePage()),
                // );
              },
              icon: Icon(
                IconData(0xe874,
                    fontFamily: Overrides.kFontFam,
                    fontPackage: Overrides.kFontPkg),
                color: AppTheme.kButtonColor,
                size: 30,
              ),
            )),
        widget.isFailureState == true
            ? Container(
                padding: widget.isFailureState != true
                    ? EdgeInsets.only(right: 10)
                    : EdgeInsets.zero,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                      IconData(0xe838,
                          fontFamily: Overrides.kFontFam,
                          fontPackage: Overrides.kFontPkg),
                      size: 30,
                      color: Colors.grey),
                ),
              )
            : Container()
      ],
    );
  }

  Widget highlightText({required String text, required theme}) {
    return TranslationWidget(
      message: text,
      toLanguage: Globals.selectedLanguage,
      fromLanguage: "en",
      builder: (translatedMessage) => Center(
        child: Text(
          translatedMessage.toString(),
          // maxLines: 2,
          //overflow: TextOverflow.ellipsis,
          // textAlign: TextAlign.center,
          style: theme,
        ),
      ),
    );
  }
}
