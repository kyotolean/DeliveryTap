import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/components/OrderHistoryItemWidget.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/services/OrderService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../main.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

class OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget('Order History', showBack: false),
        body: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (context, documentSnapshot,index) {
            return OrderHistoryItemWidget(OrderModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>));
          },
          query: orderServices.orderQuery(
            orderStatus: [ORDER_STATUS_DELIVERING, ORDER_STATUS_COMPLETE, ORDER_STATUS_ASSIGNED, ORDER_STATUS_READY],
            city: appStore.userCurrentCity,
            deliveryBoyId: getStringAsync(USER_ID),
          ),
          isLive: true,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
          itemsPerPage: DocLimit,
          bottomLoader: Loader(),
          initialLoader: Loader(),
          onEmpty: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart),
              16.height,
              Text('Order not found', style: boldTextStyle()),
            ],
          ).center(),
          onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
        ),
      ),
    );
  }
}