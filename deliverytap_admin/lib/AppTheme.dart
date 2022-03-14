import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData theme = ThemeData(
    primarySwatch: createMaterialColor(colorPrimary),
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: scaffoldColorDark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: scaffoldSecondaryDark),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(headline6: TextStyle(color: textSecondaryColor)),
    dialogBackgroundColor: scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: scaffoldSecondaryDark,
    dialogTheme: DialogTheme(shape: dialogShape()),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldColorDark,
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
