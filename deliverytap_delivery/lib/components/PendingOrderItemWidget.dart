import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:deliverytap_delivery/model/UserModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppWidgets.dart';

class PendingOrderItemWidget extends StatefulWidget {
  final OrderModel? orderData;
  final Function? onAccept;

  PendingOrderItemWidget({this.orderData, this.onAccept});

  @override
  PendingOrderItemWidgetState createState() => PendingOrderItemWidgetState();
}

class PendingOrderItemWidgetState extends State<PendingOrderItemWidget> {
  AsyncMemoizer<UserModel> userMemoizer = AsyncMemoizer();

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
    return FutureBuilder<UserModel>(
      future: userMemoizer.runOnce(() => userService.getUserById(userId: widget.orderData!.userId)),
      builder: (_, snap) {
        UserModel? data = snap.data;

        return Container(
          decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  orderStatusWidget(widget.orderData!.orderStatus).flexible(fit: FlexFit.loose),
                  Text('#${widget.orderData!.orderId}', style: boldTextStyle(size: 10)),
                ],
              ),
              8.height,
              if (snap.hasData)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data!.name.validate()}', style: primaryTextStyle(size: 15), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                    Icon(Icons.access_time_rounded, color: grayColor, size: 18),
                    4.width,
                    widget.orderData!.createdAt!.isToday
                        ? Text(DateFormat.jm().format(widget.orderData!.createdAt!), style: secondaryTextStyle(size: 13))
                        : Text(DateFormat('dd/MM/yyyy\nhh:mm a').format(widget.orderData!.createdAt!), style: secondaryTextStyle(size: 10), textAlign: TextAlign.right),
                  ],
                ),
              8.height,
              if (snap.hasData)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.call, color: blueButtonColor).onTap(() {
                      launch('tel://${data!.number.validate()}');
                    }),
                    8.width,
                    Text(data!.number.validate(), style: primaryTextStyle(size: 15)),
                  ],
                ),
              4.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.home, color: blueButtonColor),
                  4.width,
                  Text(widget.orderData!.userAddress.validate(), style: secondaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis).expand()
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    onTap: () async {
                      widget.onAccept?.call();
                    },
                    child: Text('Accept', style: boldTextStyle(color: Colors.white)),
                    color: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.orderData!.totalAmount.toCurrencyAmount()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: boldTextStyle(color: primaryColor, size: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 25, color: blueButtonColor),
                        onPressed: () {

                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
