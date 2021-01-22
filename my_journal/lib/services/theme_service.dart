import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService {
  final Color mainBlack = Colors.black45;
  final Color mainWhite = Colors.white70;
  final Color mainColor = Colors.teal[500];
  bool darkMode = false;

  //region Change Theme
  void changeTheme(bool isDarkMode, BuildContext context) {
    darkMode = isDarkMode;
    DynamicTheme.of(context).setThemeData(getThemeData());
  }
  //endregion

  //region Get Theme Data
  ThemeData getThemeData() {
    if (darkMode) {
      //region Dark Theme

      TextTheme basicTextThemeDark(TextTheme base) {
        return base.copyWith(
          headline1: GoogleFonts.mcLaren(color: mainWhite, fontSize: 40.0),
          headline2: GoogleFonts.mcLaren(color: mainWhite, fontSize: 32.0),
          headline3: GoogleFonts.mcLaren(color: mainWhite, fontSize: 20.0),
          headline4: GoogleFonts.mcLaren(color: mainWhite, fontSize: 16.0),
          headline5: GoogleFonts.mcLaren(color: mainWhite, fontSize: 14.0),
          headline6: GoogleFonts.mcLaren(color: mainWhite, fontSize: 12.0),
          subtitle1: GoogleFonts.mcLaren(color: mainWhite),
          subtitle2: GoogleFonts.mcLaren(
              color: mainWhite, decoration: TextDecoration.underline),
          bodyText1: GoogleFonts.mcLaren(color: mainWhite),
          bodyText2: GoogleFonts.mcLaren(color: mainWhite),
        );
      }

      final ThemeData baseDark = ThemeData.dark();
      return baseDark.copyWith(
          textTheme: basicTextThemeDark(baseDark.textTheme),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.grey[900],
          ),
          primaryColor: mainColor,
          iconTheme: IconThemeData(color: mainWhite),
          accentColor: mainColor,
          primaryColorLight: mainColor,
          sliderTheme: SliderThemeData(
              activeTrackColor: mainColor, thumbColor: mainColor),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: mainColor, foregroundColor: Colors.white),
          buttonColor: Colors.yellow);
      //endregion
    } else {
      //region Light Theme

      TextTheme basicTextThemeLight(TextTheme base) {
        return base.copyWith(
          headline1: GoogleFonts.mcLaren(color: mainBlack, fontSize: 40.0),
          headline2: GoogleFonts.mcLaren(color: mainBlack, fontSize: 32.0),
          headline3: GoogleFonts.mcLaren(color: mainBlack, fontSize: 20.0),
          headline4: GoogleFonts.mcLaren(color: mainBlack, fontSize: 16.0),
          headline5: GoogleFonts.mcLaren(color: mainBlack, fontSize: 14.0),
          headline6: GoogleFonts.mcLaren(color: mainBlack, fontSize: 12.0),
          subtitle1: GoogleFonts.mcLaren(color: mainBlack),
          subtitle2: GoogleFonts.mcLaren(
              color: mainBlack, decoration: TextDecoration.underline),
          bodyText1: GoogleFonts.mcLaren(color: mainBlack),
          bodyText2: GoogleFonts.mcLaren(color: mainBlack),
        );
      }

      final ThemeData baseLight = ThemeData.light();
      return baseLight.copyWith(
          textTheme: basicTextThemeLight(baseLight.textTheme),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.grey[400],
          ),
          primaryColor: mainColor,
          iconTheme: IconThemeData(color: mainWhite),
          accentColor: mainColor,
          primaryColorLight: mainColor,
          sliderTheme: SliderThemeData(
              activeTrackColor: mainColor, thumbColor: mainColor),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: mainColor),
          buttonColor: Colors.yellow);
      //endregion
    }
  }
  //endregion
}
