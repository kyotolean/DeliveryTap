import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MyOrderListItemComponent extends StatefulWidget {
  static String tag = '/MyOrderListItemComponent';

  CartModel? myOrderData;

  MyOrderListItemComponent({this.myOrderData});

  @override
  MyOrderListItemComponentState createState() => MyOrderListItemComponentState();
}

class MyOrderListItemComponentState extends State<MyOrderListItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.scaffoldBackgroundColor,
                boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
                border: Border.all(color: context.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: cachedImage(widget.myOrderData!.image.validate(), height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
            ),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.myOrderData!.itemName.validate(),
                  style: boldTextStyle(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.height,
                Text(widget.myOrderData!.description.validate(), style: secondaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.clip),
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₴${widget.myOrderData!.itemPrice} x ${widget.myOrderData!.qty}', style: secondaryTextStyle()),
                    Text(getAmount(widget.myOrderData!.itemPrice! * widget.myOrderData!.qty!), style: boldTextStyle(size: 14)),
                  ],
                )
              ],
            ).expand(),
          ],
        ).paddingOnly(left: 16, right: 16, bottom: 16),
      ],
    );
  }
}
