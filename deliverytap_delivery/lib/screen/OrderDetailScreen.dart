import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel? orderModel;

  OrderDetailScreen({this.orderModel});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
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
    return Scaffold(
      appBar: appBarWidget('#${widget.orderModel!.orderId}', color: context.cardColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.height,
            Text('Order Id', style: boldTextStyle()),
            8.height,
            Text('${widget.orderModel!.orderId!.validate()}', style: boldTextStyle(size: 12)),
            32.height,
            Text('Date', style: boldTextStyle()),
            8.height,
            Text(
              '${'Delivery to'} ${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderModel!.createdAt!)}',
              style: boldTextStyle(size: 12),
            ),
            32.height,
            Text('Delivery to', style: boldTextStyle()),
            8.height,
            Text(widget.orderModel!.userAddress.validate(), style: boldTextStyle(size: 12)),
            16.height,
            Text('Delivery charge ', style: boldTextStyle()),
            8.height,
            Text(widget.orderModel!.deliveryCharge.validate().toCurrencyAmount().toString(), style: boldTextStyle()),
            Divider(thickness: 2),
            16.height,
            Text('Order Items', style: boldTextStyle()).paddingLeft(16),
            32.height,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: widget.orderModel!.orderItems!.length,
              itemBuilder: (context, index) {
                return   Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.scaffoldBackgroundColor,
                        boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
                        border: Border.all(color: context.dividerColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel!.orderItems![index].itemName.validate(),
                          style: boldTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text('Price', style: primaryTextStyle()),
                            8.width,
                            Text(widget.orderModel!.orderItems![index].itemPrice.toCurrencyAmount().validate().toString(), style: boldTextStyle()),
                          ],
                        ),
                        4.height,
                        createRichText(list: [
                          TextSpan(text: '${'Restaurant'} :- ', style: secondaryTextStyle()),
                          TextSpan(text: widget.orderModel!.storeName.validate(), style: secondaryTextStyle()),
                        ])
                      ],
                    ).expand(),
                    Text('x ${widget.orderModel!.orderItems![index].qty.validate().toString()}', style: primaryTextStyle()),
                  ],
                ).paddingBottom(16);
              },
            ),
          ],
        ).paddingOnly(left: 16,right: 16),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 16),
        color: appStore.isDarkMode ? scaffoldColorDark : white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: primaryTextStyle(size: 18)),
                Text(widget.orderModel!.totalAmount.toCurrencyAmount().validate().toString(), style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
          ],
        ),
      ),
    );
  }
}
