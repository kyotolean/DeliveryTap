import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(colorPrimary),
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: scaffoldColorDark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: appButtonColorDark, unselectedItemColor: white, selectedItemColor: primaryColor),
    iconTheme: IconThemeData(color: Colors.white),
    dialogBackgroundColor: scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: scaffoldSecondaryDark,
    appBarTheme: AppBarTheme(
      color: scaffoldColorDark,
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: scaffoldColorDark),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: scaffoldSecondaryDark),
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
