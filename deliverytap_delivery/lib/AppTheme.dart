import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData theme = ThemeData(
    primarySwatch: createMaterialColor(colorPrimary),
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white, selectedItemColor: colorPrimary, unselectedItemColor: black),
    iconTheme: IconThemeData(color: scaffoldSecondaryDark),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
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
