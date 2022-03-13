import 'package:deliverytap_delivery/screen/SignUpScreen.dart';
import 'package:deliverytap_delivery/screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/screen/OrderHistoryScreen.dart';
import 'package:deliverytap_delivery/screen/LoginScreen.dart';
import 'package:deliverytap_delivery/screen/PendingOrderScreen.dart';
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
    OrderHistoryScreen()
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
              icon: Image.asset('images/NewOrder.png', color: Colors.grey, width: 26, height: 26),
              label: 'New Orders',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/OrderHistory.png', color: Colors.grey, width: 26, height: 26),
              label: 'Order History',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/review.png', color: Colors.grey, width: 26, height: 26),
              label: 'Review',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/profile.png', color: Colors.grey, width: 26, height: 26),
              label: 'Profile',
            ),
          ],
        ),
        body: page[mCurrent],
      ),
    );
  }
}
