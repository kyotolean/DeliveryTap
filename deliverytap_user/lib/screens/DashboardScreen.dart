import 'dart:ui';

import 'package:deliverytap_user/screens/ProfileFragment.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'LoginScreen.dart';
import 'HomeFragment.dart';
import 'OrderFragment.dart';
import 'CartFragment.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  List<Widget> screens = [
    HomeFragment(),
    OrderFragment(),
    CartFragment(),
    ProfileFragment()
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(milliseconds: 400));

    setStatusBarColor(
      context.scaffoldBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorPrimary,
        unselectedItemColor: Colors.grey,
        backgroundColor: white,
        onTap: (index) {
          if (index == 1 || index == 3) {
            if (!appStore.isLoggedIn) {
              LoginScreen().launch(context);
              return;
            }
          }
          selectedIndex = index;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedLabelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 16),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), label: "Order"),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: screens[selectedIndex],
      ),
    );
  }
}
