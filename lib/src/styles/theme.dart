import 'package:flutter/material.dart';

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
  static const Color kListBackgroundColor2 = Color(0xffF5F5F5);
  static const Color kListBackgroundColor3 = Color(0xffe9ebf7);
  static const Color kListIconColor3 = Color(0xff8ca9d8);
  static const Color kDividerColor = Color(0xff979AA6);
  static const Color kFieldbackgroundColor = Color(0xffDBDBDB);
  static const Color kprefixIconColor = Color(0xffbcc5d4);

  //Font-sizes
  static const double kButtonFontSize = 14.0;
  static const double kSubtitleFontSize = 14.0;
  static const double kHeadline1TextFontSize = 22.0;
  static const double kSubtitle2FontSize = 10.0;
  static const double kTitleFontSize = 28.0;
  static const double kCaptionFontSize = 16.0;
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
        titleTextStyle:
            TextStyle(color: kOnPrimaryColor, fontSize: kTitleFontSize),
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
            fontSize: kHeadline1TextFontSize,
            fontFamily: 'Roboto Bold',
            color: kAccentColor,
          ),
          headline6: TextStyle(
              fontSize: kTitleFontSize,
              color: kAccentColor,
              fontFamily: 'Roboto-SemiBold'),
          caption: TextStyle(
              fontSize: kCaptionFontSize,
              color: kFontColor1,
              fontWeight: FontWeight.w500),
          subtitle1: TextStyle(
              fontSize: kSubtitleFontSize,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          subtitle2: TextStyle(
            fontSize: kSubtitle2FontSize,
            color: kAccentColor,
            fontFamily: 'Roboto Regular',
          )),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kTxtFieldColor),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintStyle:
            TextStyle(color: kTxtFieldColor, fontSize: kSubtitleFontSize),
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
                fontSize: kButtonFontSize,
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
            fontSize: kSubtitle2FontSize),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF4a5aa6),
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xff89A7D7),
        ),
        unselectedLabelStyle: TextStyle(
            color: Color(0xff89A7D7),
            fontFamily: 'Roboto Regular',
            fontSize: kSubtitle2FontSize),
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
