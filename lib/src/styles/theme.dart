import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //
  // AppTheme._();

  // dark
  static const Color kAccentColor2 = Colors.black;

  //Colors

  static Color kPrimaryColor = Colors.greenAccent;
  static const Color kAccentColor = Color(0xff2D3F98);
  static const Color kBlackColor = Colors.black;
  static const Color kBackgroundColor = Colors.white;
  static const Color kOnPrimaryColor = Color(0xff808ED3);
  static const Color kSecondaryColor = Color(0xff535353);
  static const Color kButtonbackColor = Color(0xff89A7D7);
  static const Color kFontColor1 = Colors.black;
  static const Color kFontColor2 = Colors.white;
  static const Color kCardColor = Color(0xffFFFFFF);
  static const Color kShadowColor = Color(0xff000000);
  static const Color kTxtfieldBorderColor = Color(0xffBCC5D4);

  static Color? kShimmerBaseColor = Colors.grey[300];
  static Color? kShimmerHighlightColor = Colors.grey[100];

  static const Color kTxtFieldColor = Colors.grey;
  static Color kListTileColor = Color(0xffD8D8D8).withOpacity(0.12);
  static Color kIconColor = Color(0xff535353).withOpacity(0.75);
  static const Color kIconColor2 = Color(0xff8aa8d8);
  static const Color kIconColor1 = Color(0xff171717);

  static const Color kIconColor3 = Colors.black;
  static const Color kListBackgroundColor2 = Color(0xffF5F5F5);
  static const Color kListBackgroundColor3 = Color(0xffe9ebf7);
  static const Color kListIconColor3 = Color(0xff8ca9d8);
  static const Color kDividerColor = Color(0xff979AA6);
  static const Color kDividerColor2 = Color(0xffe1e4e7);
  static const Color kDividerColorDark = Colors.black;
  static const Color kFieldbackgroundColor = Color(0xffDBDBDB);
  static const Color kprefixIconColor = Color(0xffbcc5d4);
  static const Color kmapBackgroundColor = Color(0xffF4F1EF);
  static const Color kIndicatorBackColor = Color(0xff979AA6);
  static const Color kIndicatorColor = Color(0xffFFFFFF);
  static const Color kIndicatorColor2 = Color(0xffFFFFFF);
  static const Color kDecativeIconColor = Color(0xff8d8d8d);
  static const Color kactivebackColor = Color(0xff548952);
  static const Color kactiveTrackColor = Color(0xffCDECE1);
  static const Color kinactiveTrackColor = Color(0xffd4d4d4);
  static const Color ListColor2 = Color(0xFFF7F7F7);

  //Font-sizes
  static const double kButtonFontSize = 14.0;
  static const double kSubtitleFontSize = 13.0;
  static const double kHeadline1TextFontSize = 22.0;
  static const double kHeadline2TextFontSize = 16.0;
  static const double kHeadline4TextFontSize = 15.0;
  static const double kSubtitle2FontSize = 10.0;
  static const double kBodyText1FontSize = 14.0;
  static const double kTitleFontSize = 28.0;
  static const double kCaptionFontSize = 14.0;
  static const double kBottomSheetTitleSize = 20.0;
  static const double kSize = 8.0;
  static const double kIconSize = 40.0;
  static const double kTabIconSize = 55.0;

  // Banner Height
  static double kBannerHeight = 15;

  // Setting Height Factor For School & Staff Discription Images
  static const double kDetailPageImageHeightFactor = 30;

  //Borders
  static const double kBorderRadius = 0.0;
  static const double kBorderWidth = 1.0;
  static const double kBottomSheetModalUpperRadius = 25.0;

  //Paddings
  static const double kBodyPadding = 16.0;

  //List bottom pading
  static const double klistPadding = 45.0;

  //Hyperlink / External Link Style

  static final linkStyle = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: Colors.blue,
    fontSize: Globals.deviceType == "phone"
        ? AppTheme.kBodyText1FontSize
        : AppTheme.kBodyText1FontSize + AppTheme.kSize,
    color: Colors.blue, //AppTheme.kAccentColor,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto Regular',
    height: 1.5,
  );

  static final ThemeData lightTheme = ThemeData(

      // fontFamily: 'Roboto',
      primaryColor: Colors.blue,
      accentColor: kAccentColor,
      errorColor: Colors.red,
      cardTheme: CardTheme(color: kCardColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor, foregroundColor: kOnPrimaryColor),
      iconTheme: IconThemeData(
        color: kIconColor,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline3: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          color: kFontColor2,
        ),
        headline4: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline4TextFontSize
              : kHeadline4TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline5: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline6: TextStyle(
            fontSize: Globals.deviceType == "phone"
                ? kTitleFontSize
                : kTitleFontSize + kSize,
            color: kAccentColor,
            fontFamily: 'Roboto-SemiBold'),
        caption: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kCaptionFontSize
              : kCaptionFontSize + kSize,
          color: kFontColor1,
          fontWeight: FontWeight.normal,
          height: 1.2,
        ),
        subtitle1: TextStyle(
            fontSize: Globals.deviceType == "phone"
                ? kSubtitleFontSize
                : kSubtitleFontSize + kSize,
            color: kAccentColor,
            fontWeight: FontWeight.normal),
        subtitle2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kSubtitle2FontSize
              : kSubtitle2FontSize + kSize,
          fontWeight: FontWeight.normal,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
        ),
        bodyText1: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kBodyText1FontSize
              : kBodyText1FontSize + kSize,
          color: kAccentColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto Regular',
          height: 1.5,
        ),
        bodyText2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kBodyText1FontSize
              : kBodyText1FontSize + kSize,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
          fontWeight: FontWeight.normal,
          height: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kTxtFieldColor),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: TextStyle(
            color: kTxtFieldColor,
            height: 1.2,
            fontSize: Globals.deviceType == "phone"
                ? kSubtitleFontSize
                : kSubtitleFontSize + kSize),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
      ),
      radioTheme: RadioThemeData(
          overlayColor: MaterialStateProperty.all<Color>(kSecondaryColor),
          fillColor: MaterialStateProperty.all<Color>(kBackgroundColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 10,
        selectedLabelStyle: TextStyle(
            color: Color(0xFF4a5aa6),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == "phone"
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + kSize),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF4a5aa6),
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xff89A7D7),
        ),
        unselectedLabelStyle: TextStyle(
            color: Color(0xff89A7D7),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == "phone"
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + kSize),
        selectedItemColor: Color(0xff4a5aa6),
        unselectedItemColor: Color(0xff89A7D7),
        showUnselectedLabels: true,
      ));

  static final ThemeData darkTheme = ThemeData(
      // fontFamily: 'Roboto',
      primaryColor: Colors.black,
      // primarySwatch: Colors.grey,
      accentColor: kAccentColor2,
      errorColor: Colors.red,
      cardTheme: CardTheme(color: kCardColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor, foregroundColor: kOnPrimaryColor),
      iconTheme: IconThemeData(
        color: kIconColor,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline3: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          color: kFontColor2,
        ),
        headline4: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline4TextFontSize
              : kHeadline4TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline5: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + kSize,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.normal,
          color: kAccentColor,
        ),
        headline6: TextStyle(
            fontSize: Globals.deviceType == "phone"
                ? kTitleFontSize
                : kTitleFontSize + kSize,
            color: kAccentColor,
            fontFamily: 'Roboto-SemiBold'),
        caption: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kCaptionFontSize
              : kCaptionFontSize + kSize,
          color: kFontColor1,
          fontWeight: FontWeight.normal,
          height: 1.2,
        ),
        subtitle1: TextStyle(
            fontSize: Globals.deviceType == "phone"
                ? kSubtitleFontSize
                : kSubtitleFontSize + kSize,
            color: kAccentColor,
            fontWeight: FontWeight.normal),
        subtitle2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kSubtitle2FontSize
              : kSubtitle2FontSize + kSize,
          fontWeight: FontWeight.normal,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
        ),
        bodyText1: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kBodyText1FontSize
              : kBodyText1FontSize + kSize,
          color: kAccentColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto Regular',
          height: 1.5,
        ),
        bodyText2: TextStyle(
          fontSize: Globals.deviceType == "phone"
              ? kBodyText1FontSize
              : kBodyText1FontSize + kSize,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
          fontWeight: FontWeight.normal,
          height: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kTxtFieldColor),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: TextStyle(
            color: kTxtFieldColor,
            height: 1.2,
            fontSize: Globals.deviceType == "phone"
                ? kSubtitleFontSize
                : kSubtitleFontSize + kSize),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
      ),
      radioTheme: RadioThemeData(
          overlayColor: MaterialStateProperty.all<Color>(kSecondaryColor),
          fillColor: MaterialStateProperty.all<Color>(kBackgroundColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        elevation: 10,
        selectedLabelStyle: TextStyle(
            color: Color(0xFF4a5aa6),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == "phone"
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + kSize),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF4a5aa6),
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xff89A7D7),
        ),
        unselectedLabelStyle: TextStyle(
            color: Color(0xff89A7D7),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == "phone"
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + kSize),
        selectedItemColor: Color(0xff4a5aa6),
        unselectedItemColor: Color(0xff89A7D7),
        showUnselectedLabels: true,
      ));

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;
  void setDarkMode() async {
    _themeData = darkTheme;
  }

  void setLightMode() async {
    _themeData = lightTheme;
  }

  static setDynamicTheme(AppSetting appSetting, BuildContext context) {
    Color _primaryColor = Utility.getColorFromHex(appSetting.primaryColorC!);
    Color _secondaryColor =
        Utility.getColorFromHex(appSetting.secondaryColorC!);
    Color _backgroundColor =
        Utility.getColorFromHex(appSetting.backgroundColorC!);
    Color _fontColor = appSetting.fontColorC != null
        ? Utility.getColorFromHex(appSetting.fontColorC!)
        : kBlackColor;
    // Dark colors are define here
    Color _darkBackground = Color(0xff000000);
    Color _darkSecondary = Color(0xff181A1C);
    Color _darkBackgroundColor = Color(0xff000000);
    //4d4d4d

    AdaptiveTheme.of(context).setTheme(
        notify: true,
        light: AdaptiveTheme.of(context).lightTheme.copyWith(
              //Primary color
              primaryColor: _primaryColor,
              colorScheme: ColorScheme.light(
                onPrimary: _primaryColor,
                primary: _primaryColor,
                secondary: _secondaryColor,
                background: _backgroundColor,
                primaryVariant: _fontColor,
              ),
              //Background color
              backgroundColor: _backgroundColor,
              scaffoldBackgroundColor: _backgroundColor,
              accentColor: _primaryColor,
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                    color: _primaryColor,
                    fontSize: Globals.deviceType == "phone"
                        ? kTitleFontSize
                        : kTitleFontSize + kSize),
                color: _backgroundColor,
                foregroundColor: _primaryColor,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: _primaryColor,
                ),
              ),
              iconTheme: IconThemeData(
                color: _primaryColor,
              ),

              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: _fontColor),
                fillColor: Theme.of(context).colorScheme.background,
                isDense: true,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintStyle: TextStyle(
                    color: _fontColor,
                    height: 1.2,
                    fontSize: Globals.deviceType == "phone"
                        ? kSubtitleFontSize
                        : kSubtitleFontSize + kSize),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                ),
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: Globals.deviceType == "phone"
                            ? kButtonFontSize
                            : kButtonFontSize + kSize,
                        fontWeight: FontWeight.w500,
                        color: _backgroundColor,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_primaryColor),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size.fromHeight(56)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(kBorderRadius))),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(_backgroundColor))),

              //Text Theme starts

              textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline1TextFontSize
                      : kHeadline1TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: _fontColor,
                ),
                headline2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline2TextFontSize
                      : kHeadline2TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: _fontColor,
                ),
                headline3: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline2TextFontSize
                      : kHeadline2TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  color: _fontColor,
                ),
                headline4: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline4TextFontSize
                      : kHeadline4TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: _fontColor,
                ),
                headline5: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline1TextFontSize
                      : kHeadline1TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: _fontColor,
                ),
                headline6: TextStyle(
                    fontSize: Globals.deviceType == "phone"
                        ? kTitleFontSize
                        : kTitleFontSize + kSize,
                    color: _fontColor,
                    fontFamily: 'Roboto-SemiBold'),
                caption: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kCaptionFontSize
                      : kCaptionFontSize + kSize,
                  color: _fontColor,
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
                subtitle1: TextStyle(
                    fontSize: Globals.deviceType == "phone"
                        ? kSubtitleFontSize
                        : kSubtitleFontSize + kSize,
                    color: _fontColor,
                    fontWeight: FontWeight.normal),
                subtitle2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kSubtitle2FontSize
                      : kSubtitle2FontSize + kSize,
                  color: _fontColor,
                  fontFamily: 'Roboto Regular',
                ),
                bodyText1: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kBodyText1FontSize
                      : kBodyText1FontSize + kSize,
                  color: _fontColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto Regular',
                  height: 1.5,
                ),
                bodyText2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kBodyText1FontSize
                      : kBodyText1FontSize + kSize,
                  color: _fontColor,
                  fontFamily: 'Roboto Regular',
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
              ),
              checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                      width: 1.5, color: Theme.of(context).primaryColor),
                  splashRadius: 0),

              //Text theme ends
            ),
        dark: AdaptiveTheme.of(context).lightTheme.copyWith(
              //Primary color
              primaryColor: _primaryColor,
              colorScheme: ColorScheme.light(
                  onPrimary: Colors.white,
                  primary: Colors.black,
                  secondary: _darkSecondary,
                  background: _darkBackground,
                  primaryVariant: Colors.white),
              //Background color
              backgroundColor: _darkBackgroundColor,
              scaffoldBackgroundColor: _darkBackgroundColor,
              accentColor: _primaryColor,
              // textButtonTheme: Theme.of(context).,
              // dialogBackgroundColor: Colors.grey,
              dialogTheme: DialogTheme(
                backgroundColor: _darkBackgroundColor,
                contentTextStyle: TextStyle(color: Colors.white),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(_primaryColor)),
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                    color: _primaryColor,
                    fontSize: Globals.deviceType == "phone"
                        ? kTitleFontSize
                        : kTitleFontSize + kSize),
                color: _darkBackgroundColor,
                foregroundColor: _primaryColor,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: _primaryColor,
                ),
              ),
              iconTheme: IconThemeData(
                color: _primaryColor,
              ),

              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Theme.of(context).colorScheme.background,
                isDense: true,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintStyle: TextStyle(
                    color: Colors.white,
                    height: 1.2,
                    fontSize: Globals.deviceType == "phone"
                        ? kSubtitleFontSize
                        : kSubtitleFontSize + kSize),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                ),
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: Globals.deviceType == "phone"
                            ? kButtonFontSize
                            : kButtonFontSize + kSize,
                        fontWeight: FontWeight.w500,
                        color: _backgroundColor,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_primaryColor),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size.fromHeight(56)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(kBorderRadius))),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(_backgroundColor))),

              //Text Theme starts

              textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline1TextFontSize
                      : kHeadline1TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                headline2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline2TextFontSize
                      : kHeadline2TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                headline3: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline2TextFontSize
                      : kHeadline2TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  color: Colors.white,
                ),
                headline4: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline4TextFontSize
                      : kHeadline4TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                headline5: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kHeadline1TextFontSize
                      : kHeadline1TextFontSize + kSize,
                  fontFamily: 'Roboto Bold',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                headline6: TextStyle(
                    fontSize: Globals.deviceType == "phone"
                        ? kTitleFontSize
                        : kTitleFontSize + kSize,
                    color: Colors.white,
                    fontFamily: 'Roboto-SemiBold'),
                caption: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kCaptionFontSize
                      : kCaptionFontSize + kSize,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
                subtitle1: TextStyle(
                    fontSize: Globals.deviceType == "phone"
                        ? kSubtitleFontSize
                        : kSubtitleFontSize + kSize,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                subtitle2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kSubtitle2FontSize
                      : kSubtitle2FontSize + kSize,
                  color: Colors.white,
                  fontFamily: 'Roboto Regular',
                ),
                bodyText1: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kBodyText1FontSize
                      : kBodyText1FontSize + kSize,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto Regular',
                  height: 1.5,
                ),
                bodyText2: TextStyle(
                  fontSize: Globals.deviceType == "phone"
                      ? kBodyText1FontSize
                      : kBodyText1FontSize + kSize,
                  color: Colors.white,
                  fontFamily: 'Roboto Regular',
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
              ),

              checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                      width: 1.5, color: Theme.of(context).primaryColor),
                  splashRadius: 0),

              //Text theme ends
            ));
  }

  // Dark theme color are define here

}
