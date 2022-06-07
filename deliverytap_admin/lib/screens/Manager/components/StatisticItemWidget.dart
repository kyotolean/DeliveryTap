import 'package:flutter/material.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class OrderItemWidgetPhone extends StatefulWidget {
  final OrderModel? orderModel;

  OrderItemWidgetPhone({this.orderModel});

  @override
  _OrderItemWidgetPhoneState createState() => _OrderItemWidgetPhoneState();
}

class _OrderItemWidgetPhoneState extends State<OrderItemWidgetPhone> {
  UserModel userData = UserModel();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userService.getUserById(userId: widget.orderModel!.userID).then((value) {
      userData = value;
      setState(() {});
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      //crossAxisAlignment: CrossAxisAlignment.start,
      runSpacing: 16,
      children: [
        orderItemDetail(ORDER_NUMBER, widget.orderModel!.orderId.validate()),
        orderItemDetail(ORDER_DATETIME, '${DateFormat('dd-MM-yyyy hh:mm a').format(widget.orderModel!.createdAt!)}'),
        Container(
          width: statisticsItemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AMOUNT, style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
              8.height,
              Row(
                children: [
                  Text('${widget.orderModel!.totalPrice.validate().toAmount()}', style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                  6.width,
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(widget.orderModel!.paymentMethod.validate(), style: primaryTextStyle(color: Colors.white, size: 12), overflow: TextOverflow.ellipsis),
                  ).cornerRadiusWithClipRRect(defaultRadius)
                ],
              )
            ],
          ),
        ),
        orderItemDetail(PAYMENT_STATUS, widget.orderModel!.paymentStatus.validate()),
        orderItemDetail(USERNAME, userData.name.validate()),
        orderItemDetail(USEREMAIL, userData.email.validate()),
      ],
    );
  }
}

Widget orderItemDetail(String title, String data) {
  return Container(
    width: statisticsItemWidth,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
        8.height,
        Text(data, style: primaryTextStyle(), overflow: TextOverflow.ellipsis).withTooltip(msg: data),
      ],
    ),
  );
}
