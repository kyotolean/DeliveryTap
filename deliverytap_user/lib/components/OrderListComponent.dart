import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/OrderModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/OrderDetailsScreen.dart';

// ignore: must_be_immutable
class OrderListComponent extends StatefulWidget {
  static String tag = '/OrderListComponent';
  OrderModel? orderData;

  OrderListComponent({this.orderData});

  @override
  OrderListComponentState createState() => OrderListComponentState();
}

class OrderListComponentState extends State<OrderListComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
        border: Border.all(color: getOrderStatusColor(widget.orderData!.orderStatus).withOpacity(0.5)),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order Number".toUpperCase(), style: secondaryTextStyle(size: 10)),
                  Text('${widget.orderData!.orderId.validate()}', style: primaryTextStyle(size: 14)),
                ],
              ).expand(),
              Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius(8), border: Border.all(color: Colors.grey.shade500)),
                padding: EdgeInsets.all(6),
                child: Text("Order Detail", style: secondaryTextStyle(color: colorPrimary, size: 12)),
              )
            ],
          ),
          8.height,
          Text('${widget.orderData!.totalItem.validate()} Items', style: boldTextStyle(size: 14)),
          Text('Order on ${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderData!.createdAt!)}', style: secondaryTextStyle(size: 12)),
          8.height,
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: getOrderStatusColor(widget.orderData!.orderStatus).withOpacity(0.05)),
            child: Text(getOrderStatusText(widget.orderData!.orderStatus.validate()), style: boldTextStyle(color: getOrderStatusColor(widget.orderData!.orderStatus), size: 12)),
          ),
        ],
      ).onTap(() {
        OrderDetailsScreen(listOfOrder: widget.orderData!.listOfOrder, orderData: widget.orderData).launch(context);
      }, borderRadius: radius()),
    );
  }
}
