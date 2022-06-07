import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/OrderItemData.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class OrderDetailsComponent extends StatefulWidget {
  static String tag = '/OrderDetailsComponent';
  OrderItemData? orderDetailsData;

  OrderDetailsComponent({this.orderDetailsData});

  @override
  OrderDetailsComponentState createState() => OrderDetailsComponentState();
}

class OrderDetailsComponentState extends State<OrderDetailsComponent> {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.scaffoldBackgroundColor,
            boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
            border: Border.all(color: context.dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: cachedImage(
            widget.orderDetailsData!.image.validate(),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(12),
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.orderDetailsData!.itemName.validate(),
              style: boldTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text('Price:', style: primaryTextStyle()),
                2.width,
                Text(getAmount(widget.orderDetailsData!.itemPrice.validate()), style: boldTextStyle()),
              ],
            ),
            createRichText(list: [
              TextSpan(text: 'Store -', style: secondaryTextStyle()),
              TextSpan(text: widget.orderDetailsData!.storeName.validate(), style: secondaryTextStyle()),
            ]).visible(widget.orderDetailsData!.storeName.validate().isNotEmpty),
          ],
        ).expand(),
        Text('x ${widget.orderDetailsData!.qty.validate().toString()}', style: primaryTextStyle()),
      ],
    ).paddingBottom(16);
  }
}
