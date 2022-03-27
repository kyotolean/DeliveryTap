import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/screens/DashboardScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderSuccessFullyDialog extends StatefulWidget {
  static String tag = '/OrderSuccessFullyDialog';

  @override
  OrderSuccessFullyDialogState createState() => OrderSuccessFullyDialogState();
}

class OrderSuccessFullyDialogState extends State<OrderSuccessFullyDialog> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: context.width(),
        ).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
        16.height,
        Text("Order Placed!", style: boldTextStyle(size: 18)),
        16.height,
        Text(
          "Thank you for placing your order with us.",
          style: primaryTextStyle(),
          textAlign: TextAlign.center,
        ).paddingOnly(left: 8, right: 8),
        30.height,
        AppButton(
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
          width: context.width(),
          color: colorPrimary,
          child: Text("Continue", style: boldTextStyle(color: Colors.white)),
          onTap: () {
            DashboardScreen().launch(context, isNewTask: true);
          },
        ).paddingOnly(left: 8, right: 8, bottom: 30)
      ],
    );
  }
}
