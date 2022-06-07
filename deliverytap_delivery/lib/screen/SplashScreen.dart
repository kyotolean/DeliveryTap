import 'package:deliverytap_delivery/screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:deliverytap_delivery/screen/DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    if (getBoolAsync(IS_LOGGED_IN)) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      LoginScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center
    )
      );
  }
}
