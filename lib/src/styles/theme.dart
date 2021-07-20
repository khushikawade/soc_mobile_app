import 'package:flutter/material.dart';
import '../globals.dart';

class AppTheme {
  //
  AppTheme._();

  //Colors

  static const Color kPrimaryColor = Color(0xffffffff);
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
  static const Color kTxtFieldColor = Color(0xffBCC5D4);
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

  //Borders
  static const double kBorderRadius = 0.0;
  static const double kBorderWidth = 1.0;
  static const double kBottomSheetModalUpperRadius = 25.0;

  //Paddings
  static const double kBodyPadding = 16.0;

  static final ThemeData lightTheme = ThemeData(
      // fontFamily: 'Roboto',
      primaryColor: kPrimaryColor,
      accentColor: kAccentColor,
      errorColor: Colors.red,
      scaffoldBackgroundColor: kBackgroundColor,
      backgroundColor: kBackgroundColor,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            color: kOnPrimaryColor,
            fontSize: Globals.deviceType == Globals.phone
                ? kTitleFontSize
                : kTitleFontSize + 0),
        color: kPrimaryColor,
        foregroundColor: kOnPrimaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: kOnPrimaryColor,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: kPrimaryColor,
        onPrimary: kOnPrimaryColor,
        // primaryVariant: Colors.white38,
        secondary: kSecondaryColor,
      ),
      cardTheme: CardTheme(color: kCardColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor, foregroundColor: kOnPrimaryColor),
      iconTheme: IconThemeData(
        color: kIconColor,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + 0,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.bold,
          color: kAccentColor,
        ),
        headline2: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + 0,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.bold,
          color: kAccentColor,
        ),
        headline3: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kHeadline2TextFontSize
              : kHeadline2TextFontSize + 0,
          fontFamily: 'Roboto Bold',
          color: kFontColor2,
        ),
        headline4: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kHeadline4TextFontSize
              : kHeadline4TextFontSize + 0,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.w400,
          color: kAccentColor,
        ),
        headline5: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kHeadline1TextFontSize
              : kHeadline1TextFontSize + 0,
          fontFamily: 'Roboto Bold',
          fontWeight: FontWeight.w600,
          color: kAccentColor,
        ),
        headline6: TextStyle(
            fontSize: Globals.deviceType == Globals.phone
                ? kTitleFontSize
                : kTitleFontSize + 0,
            color: kAccentColor,
            fontFamily: 'Roboto-SemiBold'),
        caption: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kCaptionFontSize
              : kCaptionFontSize + 0,
          color: kFontColor1,
          fontWeight: FontWeight.normal,
          height: 1.2,
        ),
        subtitle1: TextStyle(
            fontSize: Globals.deviceType == Globals.phone
                ? kSubtitleFontSize
                : kSubtitleFontSize + 0,
            color: kAccentColor,
            fontWeight: FontWeight.normal),
        subtitle2: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kSubtitle2FontSize
              : kSubtitle2FontSize + 0,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
        ),
        bodyText1: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kBodyText1FontSize
              : kBodyText1FontSize + 0,
          color: kAccentColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto Regular',
          height: 1.5,
        ),
        bodyText2: TextStyle(
          fontSize: Globals.deviceType == Globals.phone
              ? kBodyText1FontSize
              : kBodyText1FontSize + 0,
          color: kAccentColor,
          fontFamily: 'Roboto Regular',
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kTxtFieldColor),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle: TextStyle(
            color: kTxtFieldColor,
            fontSize: Globals.deviceType == Globals.phone
                ? kSubtitleFontSize
                : kSubtitleFontSize + 0),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kTxtfieldBorderColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                fontSize: Globals.deviceType == Globals.phone
                    ? kButtonFontSize
                    : kButtonFontSize + 0,
                fontWeight: FontWeight.w500,
                color: kBlackColor,
              )),
              backgroundColor:
                  MaterialStateProperty.all<Color>(kButtonbackColor),
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(56)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(kBorderRadius))),
              foregroundColor: MaterialStateProperty.all<Color>(kBlackColor))),
      radioTheme: RadioThemeData(
          overlayColor: MaterialStateProperty.all<Color>(kSecondaryColor),
          fillColor: MaterialStateProperty.all<Color>(kBackgroundColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 10,
        selectedLabelStyle: TextStyle(
            color: Color(0xFF4a5aa6),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == Globals.phone
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + 0),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF4a5aa6),
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xff89A7D7),
        ),
        unselectedLabelStyle: TextStyle(
            color: Color(0xff89A7D7),
            fontFamily: 'Roboto Regular',
            fontSize: Globals.deviceType == Globals.phone
                ? kSubtitle2FontSize
                : kSubtitle2FontSize + 8),
        selectedItemColor: Color(0xff4a5aa6),
        unselectedItemColor: Color(0xff89A7D7),
        showUnselectedLabels: true,
      ));

  // static final ThemeData darkTheme = ThemeData(
  //   scaffoldBackgroundColor: Colors.black,
  //   appBarTheme: AppBarTheme(
  //     color: Colors.black,
  //     iconTheme: IconThemeData(
  //       color: Colors.white,
  //     ),
  //   ),
  //   colorScheme: ColorScheme.light(
  //     primary: Colors.black,
  //     onPrimary: Colors.black,
  //     primaryVariant: Colors.black,
  //     secondary: Colors.red,
  //   ),
  //   cardTheme: CardTheme(
  //     color: Colors.black,
  //   ),
  //   iconTheme: IconThemeData(
  //     color: Colors.white54,
  //   ),
  //   textTheme: TextTheme(

  //   ),
  // );
}
