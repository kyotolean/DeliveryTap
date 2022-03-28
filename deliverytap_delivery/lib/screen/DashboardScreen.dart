import 'package:deliverytap_delivery/screen/SignUpScreen.dart';
import 'package:deliverytap_delivery/screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/screen/OrderHistoryScreen.dart';
import 'package:deliverytap_delivery/screen/LoginScreen.dart';
import 'package:deliverytap_delivery/screen/PendingOrderScreen.dart';
import 'package:deliverytap_delivery/screen/ReviewScreen.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with AfterLayoutMixin<DashboardScreen> {
  int mCurrent = 0;

  List<Widget> page = [
    PendingOrderScreen(),
    OrderHistoryScreen(),
    ReviewScreen(),
    PendingOrderScreen(),
  ];

  @override
  void afterFirstLayout(BuildContext context) {
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (!appStore.isLoggedIn) {
        LoginScreen().launch(context, isNewTask: true);
      } else {
        /* if (result.notification.additionalData!.containsKey('orderId')) {
          String? orderId = result.notification.additionalData!['orderId'];

          TrackingScreen(orderId: orderId).launch(context);
        }*/
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: white,
      color: primaryColor,
      onRefresh: () async {
        setState(() {});
        await 2.seconds.delay;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            mCurrent = value;
            setState(() {});
          },
          currentIndex: mCurrent,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'New Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.av_timer),
              label: 'Order History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              label: 'Review',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
        body: page[mCurrent],
      ),
    );
  }
}
