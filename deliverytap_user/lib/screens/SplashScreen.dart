import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/services/AuthService.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/screens/LoginScreen.dart';
import 'package:deliverytap_user/screens/DashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';

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
    await 2.seconds.delay;
    setStatusBarColor(
      scaffoldColorDark,
      statusBarIconBrightness: Brightness.light,
    );

    if (appStore.isLoggedIn) {
      appStore.clearCart();
      await myCartDBService.getCartList().then((value) {
        value.forEach((element) {
          appStore.addToCart(element);
        });
      });

      DashboardScreen().launch(context, isNewTask: true);
    } else {
      LoginScreen().launch(context, isNewTask: true);
    }
    }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Container(
        child: Text(mAppName, style: primaryTextStyle(size: 36, color: Colors.white)),
      ).center(),
    );
  }
}