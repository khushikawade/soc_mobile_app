import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  //Colors

  static const Color kPrimaryColor = Color(0xfff7a42a);
  static const Color kBackgroundColor = Colors.white; 
  static const Color kOnPrimaryColor = Colors.white;
  static const Color kSecondaryColor = Color(0xff535353);
  static const Color kFontColor1 = Colors.black;
  static const Color kFontColor2 = Colors.white;
  static const Color kCardColor = Color(0xffFFFFFF);
  static const Color kShadowColor = Color(0xff000000);
  static Color kListTileColor = Color(0xffD8D8D8).withOpacity(0.12);
  static Color kIconColor = Color(0xff535353).withOpacity(0.75); 

  //Font-sizes
  static const double kButtonFontSize = 18.0;
  static const double kSubtitleFontSize = 14.0;
  static const double kTitleFontSize = 28.0;
  static const double kCaptionFontSize = 16.0;
  static const double kBottomSheetTitleSize = 20.0;

  //Borders
  static const double kBorderRadius = 6.0;
  static const double kBorderWidth = 1.0;
  static const double kBottomSheetModalUpperRadius = 25.0;

  //Paddings
  static const double kBodyPadding = 16.0;

  static final ThemeData lightTheme = ThemeData(
      // fontFamily: 'Poppins',
      primaryColor: kPrimaryColor,
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
          headline6: TextStyle(
              fontSize: kTitleFontSize,
              color: kPrimaryColor,
              fontFamily: 'Poppins-SemiBold'),
          caption: TextStyle(
              fontSize: kCaptionFontSize,
              color: kFontColor1,
              fontWeight: FontWeight.w500),
          subtitle1:
              TextStyle(fontSize: kSubtitleFontSize, color: kSecondaryColor)),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            TextStyle(color: kSecondaryColor, fontSize: kSubtitleFontSize),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: kBorderWidth, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: kBorderWidth, color: kBackgroundColor),
            borderRadius: BorderRadius.circular(kBorderRadius)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                  fontSize: kButtonFontSize, fontWeight: FontWeight.w600)),
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(56)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(kBorderRadius))),
              foregroundColor:
                  MaterialStateProperty.all<Color>(kOnPrimaryColor))),
      radioTheme: RadioThemeData(
          overlayColor: MaterialStateProperty.all<Color>(kSecondaryColor),
          fillColor: MaterialStateProperty.all<Color>(kPrimaryColor)));

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
