import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/components/MyOrderBottomWidget.dart';
import 'package:deliverytap_user/components/MyOrderListItemComponent.dart';
import 'package:deliverytap_user/components/MyOrderUserInfoComponent.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/services/UserDBService.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MyOrderScreen extends StatefulWidget {
  static String tag = '/MyOrderScreen';

  String? orderAddress;

  MyOrderScreen({this.orderAddress});

  @override
  MyOrderScreenState createState() => MyOrderScreenState();
}

class MyOrderScreenState extends State<MyOrderScreen> {
  int totalAmount = 0;
  UserDBService? userDBService;

  double? userLatitude;
  double? userLongitude;
  bool? isOrder;
  String address = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    calculateTotal();
    getCurrentUserLocation();

    setStatusBarColor(
      scaffoldColorDark,
      statusBarIconBrightness: Brightness.light,
    );
  }

  getCurrentUserLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = geoPosition.longitude;
      userLongitude = geoPosition.latitude;
    });
  }

  void calculateTotal() {
    totalAmount = appStore.mCartList.sumBy(((e) => e!.itemPrice! * e.qty!)) + getIntAsync(DELIVERY_CHARGES);
    setState(() {});
  }

  @override
  void dispose() {
    setStatusBarColor(
      colorPrimary,
      statusBarIconBrightness: Brightness.dark,
    );
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("Checkout", color: colorPrimary, textColor: white, showBack: true),
        body: Column(
          children: [
            MyOrderUserInfoComponent(isOrder: true),
            16.height,
            Observer(
              builder: (_) => ListView.builder(
                itemCount: appStore.mCartList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return MyOrderListItemComponent(myOrderData: appStore.mCartList[index]);
                },
              ).expand(),
            ),
          ],
        ),
        bottomNavigationBar: MyOrderBottomWidget(
          totalAmount: totalAmount,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          orderAddress: address,
          isOrder: true,
          onPlaceOrder: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
